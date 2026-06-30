[CmdletBinding()]
param(
  [string]$ManifestPath = "",
  [string]$InputDir = "",
  [string]$MusicRoot = "",
  [string]$OutputDir = "",
  [switch]$SkipRender,
  [switch]$BurnText,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($ManifestPath)) {
  $ManifestPath = Join-Path $PSScriptRoot "shorts-manifest.json"
}

function Get-RepoRoot {
  return (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..")).Path
}

function Find-LocalTool {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [Parameter(Mandatory = $true)]
    [string]$RepoRoot
  )

  $command = Get-Command $Name -ErrorAction SilentlyContinue
  if ($command) {
    return $command.Source
  }

  $local = Get-ChildItem -LiteralPath (Join-Path $RepoRoot ".tools") -Recurse -Filter "$Name.exe" -ErrorAction SilentlyContinue |
    Sort-Object FullName |
    Select-Object -First 1
  if ($local) {
    return $local.FullName
  }

  throw "Could not find $Name. Install portable ffmpeg under .tools/ffmpeg or add it to PATH."
}

function Get-JsonFile {
  param([Parameter(Mandatory = $true)][string]$Path)
  return Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Get-VideoInfo {
  param(
    [Parameter(Mandatory = $true)][string]$Ffprobe,
    [Parameter(Mandatory = $true)][string]$Path
  )

  $raw = & $Ffprobe -v error -print_format json -show_streams -show_format $Path
  if ($LASTEXITCODE -ne 0) {
    throw "ffprobe failed for $Path"
  }

  $json = $raw | ConvertFrom-Json
  $video = $json.streams | Where-Object { $_.codec_type -eq "video" } | Select-Object -First 1
  $audio = $json.streams | Where-Object { $_.codec_type -eq "audio" } | Select-Object -First 1

  return [pscustomobject]@{
    Duration = [double]$json.format.duration
    Width = [int]$video.width
    Height = [int]$video.height
    HasAudio = [bool]$audio
  }
}

function Get-OptionalNumber {
  param(
    [object]$Object,
    [string]$Property,
    [double]$Default
  )

  if ($null -ne $Object.PSObject.Properties[$Property] -and $null -ne $Object.$Property) {
    return [double]$Object.$Property
  }
  return $Default
}

function Format-InvariantNumber {
  param([double]$Value)
  return $Value.ToString("0.###", [System.Globalization.CultureInfo]::InvariantCulture)
}

function Format-AssTime {
  param([double]$Seconds)
  $safe = [Math]::Max(0, $Seconds)
  $ts = [TimeSpan]::FromSeconds($safe)
  $centiseconds = [Math]::Floor($ts.Milliseconds / 10)
  return "{0}:{1:00}:{2:00}.{3:00}" -f [Math]::Floor($ts.TotalHours), $ts.Minutes, $ts.Seconds, $centiseconds
}

function Escape-AssText {
  param([string]$Text)
  return $Text.Replace("\", "\\").Replace("{", "\{").Replace("}", "\}").Replace("`r`n", "\N").Replace("`n", "\N")
}

function ConvertTo-FfmpegFilterPath {
  param([string]$Path)
  $full = (Resolve-Path -LiteralPath $Path).Path.Replace("\", "/")
  return $full.Replace(":", "\:").Replace("'", "\'")
}

function Write-AssCaptions {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][object[]]$Lines,
    [Parameter(Mandatory = $true)][double]$Duration
  )

  $header = @(
    "[Script Info]",
    "ScriptType: v4.00+",
    "PlayResX: 1080",
    "PlayResY: 1920",
    "ScaledBorderAndShadow: yes",
    "",
    "[V4+ Styles]",
    "Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding",
    "Style: Default,Segoe UI Semibold,58,&H00FFFFFF,&H000000FF,&HAA000000,&H66000000,-1,0,0,0,100,100,0,0,1,4,2,2,76,76,215,1",
    "",
    "[Events]",
    "Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text"
  )

  $events = New-Object System.Collections.Generic.List[string]
  if ($Lines.Count -gt 0) {
    $usable = [Math]::Max(4, $Duration - 1)
    $slot = $usable / $Lines.Count
    for ($i = 0; $i -lt $Lines.Count; $i++) {
      $start = 0.5 + ($i * $slot)
      $end = [Math]::Min($Duration - 0.2, $start + [Math]::Min(3.4, $slot * 0.82))
      if ($end -le $start) {
        $end = [Math]::Min($Duration, $start + 1.2)
      }
      $text = Escape-AssText ([string]$Lines[$i])
      $events.Add(("Dialogue: 0,{0},{1},Default,,0,0,0,,{2}" -f (Format-AssTime $start), (Format-AssTime $end), $text))
    }
  }

  ($header + $events) | Set-Content -LiteralPath $Path -Encoding UTF8
}

function Get-UniqueHashtags {
  param(
    [object[]]$DefaultHashtags,
    [object[]]$ItemHashtags
  )

  $seen = [ordered]@{}
  foreach ($tag in @($DefaultHashtags + $ItemHashtags)) {
    if ([string]::IsNullOrWhiteSpace([string]$tag)) {
      continue
    }
    $key = ([string]$tag).Trim()
    if (-not $seen.Contains($key)) {
      $seen[$key] = $true
    }
  }
  return @($seen.Keys)
}

function Write-MetadataFile {
  param(
    [Parameter(Mandatory = $true)][object]$Manifest,
    [Parameter(Mandatory = $true)][object]$Item,
    [Parameter(Mandatory = $true)][string]$RenderedFileName,
    [Parameter(Mandatory = $true)][string]$Path
  )

  $hashtags = Get-UniqueHashtags $Manifest.defaultHashtags $Item.hashtags
  $utm = "https://www.divergentum.com/?utm_source=youtube&utm_medium=shorts&utm_campaign=$($Manifest.campaignId)&utm_content=$($Item.utmContent)"
  $description = @(
    $Item.description,
    "",
    "Play Divergentum:",
    $utm,
    "",
    $Manifest.musicAttribution,
    "",
    ($hashtags -join " ")
  ) -join "`n"

  $content = @(
    "# $($Item.title)",
    "",
    ("Source video: ``{0}``" -f $Item.sourceVideo),
    ("Rendered file: ``{0}``" -f $RenderedFileName),
    ("Music: ``{0}``" -f $Item.music.file),
    "UTM: $utm",
    "",
    "## Description",
    "",
    $description,
    "",
    "## Pinned comment",
    "",
    $Item.pinnedComment,
    "",
    "## On-screen text plan",
    ""
  )

  foreach ($line in $Item.onScreenText) {
    $content += "- $line"
  }

  $content | Set-Content -LiteralPath $Path -Encoding UTF8

  return [pscustomobject]@{
    Order = $Item.order
    Slug = $Item.slug
    SourceVideo = $Item.sourceVideo
    RenderedFile = $RenderedFileName
    Title = $Item.title
    Description = $description
    Hashtags = ($hashtags -join " ")
    PinnedComment = $Item.pinnedComment
    Music = $Item.music.file
    UTM = $utm
  }
}

$repoRoot = Get-RepoRoot
$manifest = Get-JsonFile $ManifestPath

if ([string]::IsNullOrWhiteSpace($InputDir)) {
  $InputDir = $manifest.inputDir
}
if ([string]::IsNullOrWhiteSpace($MusicRoot)) {
  $MusicRoot = $manifest.musicRoot
}
if ([string]::IsNullOrWhiteSpace($OutputDir)) {
  $OutputDir = Join-Path $InputDir $manifest.outputDirName
}

$ffmpeg = Find-LocalTool "ffmpeg" $repoRoot
$ffprobe = Find-LocalTool "ffprobe" $repoRoot
$watermarkPath = Join-Path $repoRoot $manifest.watermark

$manifestOutDir = Join-Path $OutputDir "manifest"
$metadataDir = Join-Path $OutputDir "metadata"
$captionsDir = Join-Path $OutputDir "captions"
$renderedDir = Join-Path $OutputDir "rendered"
$logsDir = Join-Path $OutputDir "logs"

foreach ($dir in @($manifestOutDir, $metadataDir, $captionsDir, $renderedDir, $logsDir)) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

Copy-Item -LiteralPath $ManifestPath -Destination (Join-Path $manifestOutDir "shorts-manifest.json") -Force

$uploadRows = New-Object System.Collections.Generic.List[object]
$renderReport = New-Object System.Collections.Generic.List[object]

foreach ($item in ($manifest.items | Sort-Object order)) {
  $sourcePath = Join-Path $InputDir $item.sourceVideo
  $musicPath = Join-Path $MusicRoot $item.music.file
  if (-not (Test-Path -LiteralPath $sourcePath)) {
    throw "Missing source video: $sourcePath"
  }
  if (-not (Test-Path -LiteralPath $musicPath)) {
    throw "Missing music file: $musicPath"
  }
  if (-not (Test-Path -LiteralPath $watermarkPath)) {
    throw "Missing watermark file: $watermarkPath"
  }

  $info = Get-VideoInfo $ffprobe $sourcePath
  $duration = if ($null -ne $item.PSObject.Properties["trimDurationSec"] -and $null -ne $item.trimDurationSec) {
    [Math]::Min([double]$item.trimDurationSec, $info.Duration)
  } else {
    $info.Duration
  }
  $durationText = Format-InvariantNumber $duration

  $renderedFileName = "{0:00}-{1}.mp4" -f [int]$item.order, $item.slug
  $renderedPath = Join-Path $renderedDir $renderedFileName
  $metadataPath = Join-Path $metadataDir ("{0:00}-{1}.youtube.md" -f [int]$item.order, $item.slug)
  $captionsPath = Join-Path $captionsDir ("{0:00}-{1}.ass" -f [int]$item.order, $item.slug)
  $logPath = Join-Path $logsDir ("{0:00}-{1}.ffmpeg.log" -f [int]$item.order, $item.slug)

  Write-AssCaptions $captionsPath @($item.onScreenText) $duration
  $uploadRows.Add((Write-MetadataFile $manifest $item $renderedFileName $metadataPath))

  if ($SkipRender) {
    $renderReport.Add([pscustomobject]@{
      Slug = $item.slug
      Status = "metadata-only"
      Output = $renderedPath
      Duration = [Math]::Round($duration, 1)
    })
    continue
  }

  if ((Test-Path -LiteralPath $renderedPath) -and -not $Force) {
    $renderReport.Add([pscustomobject]@{
      Slug = $item.slug
      Status = "skipped-existing"
      Output = $renderedPath
      Duration = [Math]::Round($duration, 1)
    })
    continue
  }

  $sourceVolume = Format-InvariantNumber (Get-OptionalNumber $item "sourceAudioVolume" ([double]$manifest.defaultSourceAudioVolume))
  $musicVolume = Format-InvariantNumber (Get-OptionalNumber $item.music "volume" ([double]$manifest.defaultMusicVolume))

  $videoFilter = "[0:v]split=2[vbg][vfg];[vbg]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=28,eq=brightness=-0.08:saturation=0.85[bg];[vfg]scale=1080:1920:force_original_aspect_ratio=decrease[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2[base];[2:v]scale=1080:1920[wm];[base][wm]overlay=0:0"
  if ($BurnText) {
    $captionFilterPath = ConvertTo-FfmpegFilterPath $captionsPath
    $videoFilter = "$videoFilter,subtitles='$captionFilterPath'[v]"
  } else {
    $videoFilter = "$videoFilter[v]"
  }

  if ($info.HasAudio) {
    $audioFilter = "[0:a]volume=$sourceVolume[a0];[1:a]volume=$musicVolume[a1];[a0][a1]amix=inputs=2:duration=first:dropout_transition=2[a]"
  } else {
    $audioFilter = "[1:a]volume=$musicVolume[a]"
  }

  $filterComplex = "$videoFilter;$audioFilter"

  $ffArgs = @(
    "-hide_banner",
    "-y",
    "-i", $sourcePath,
    "-stream_loop", "-1",
    "-i", $musicPath,
    "-loop", "1",
    "-i", $watermarkPath,
    "-filter_complex", $filterComplex,
    "-map", "[v]",
    "-map", "[a]",
    "-c:v", "libx264",
    "-preset", "veryfast",
    "-crf", "20",
    "-pix_fmt", "yuv420p",
    "-c:a", "aac",
    "-b:a", "160k",
    "-movflags", "+faststart",
    "-t", $durationText,
    "-shortest",
    $renderedPath
  )

  $oldErrorActionPreference = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  try {
    $ffmpegOutput = & $ffmpeg @ffArgs 2>&1
    $ffmpegExitCode = $LASTEXITCODE
  }
  finally {
    $ErrorActionPreference = $oldErrorActionPreference
  }

  $ffmpegOutput | Out-String | Set-Content -LiteralPath $logPath -Encoding UTF8
  if ($ffmpegExitCode -ne 0) {
    throw "ffmpeg failed for $($item.slug). See log: $logPath"
  }

  $renderReport.Add([pscustomobject]@{
    Slug = $item.slug
    Status = "rendered"
    Output = $renderedPath
    Duration = [Math]::Round($duration, 1)
  })
}

$uploadRows | Sort-Object Order | Export-Csv -LiteralPath (Join-Path $OutputDir "upload-sheet.csv") -NoTypeInformation -Encoding UTF8
$renderReport | Sort-Object Slug | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $OutputDir "render-report.json") -Encoding UTF8

Write-Host "Shorts Factory complete:"
Write-Host "  Output: $OutputDir"
Write-Host "  Metadata: $metadataDir"
Write-Host "  Rendered: $renderedDir"
Write-Host "  Upload sheet: $(Join-Path $OutputDir 'upload-sheet.csv')"
