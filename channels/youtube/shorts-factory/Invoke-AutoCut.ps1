[CmdletBinding()]
param(
  [string]$SourceVideo = "first tiktok.mp4",
  [string]$InputDir = "",
  [string]$OutputDir = "",
  [string]$RunName = "",
  [string]$Watermark = "channels/youtube/assets/merowingus-studio-watermark-shorts-1080x1920-20.png",
  [int]$CandidateCount = 5,
  [double]$SegmentDurationSec = 45,
  [double]$SceneThreshold = 0.18,
  [string]$ManualStartsSec = "",
  [int]$MaxSceneFrames = 80,
  [switch]$AnalyzeOnly,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

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
    VideoCodec = [string]$video.codec_name
    AudioCodec = if ($audio) { [string]$audio.codec_name } else { "" }
  }
}

function Format-InvariantNumber {
  param([double]$Value)
  return $Value.ToString("0.###", [System.Globalization.CultureInfo]::InvariantCulture)
}

function New-SafeSlug {
  param([string]$Value)
  $slug = $Value.ToLowerInvariant()
  $slug = [regex]::Replace($slug, "\.[a-z0-9]+$", "")
  $slug = [regex]::Replace($slug, "[^a-z0-9]+", "-")
  $slug = $slug.Trim("-")
  if ([string]::IsNullOrWhiteSpace($slug)) {
    return "video"
  }
  return $slug
}

function Invoke-Native {
  param(
    [Parameter(Mandatory = $true)][string]$Exe,
    [Parameter(Mandatory = $true)][object[]]$Arguments,
    [Parameter(Mandatory = $true)][string]$LogPath
  )

  $oldErrorActionPreference = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  try {
    $output = & $Exe @Arguments 2>&1
    $exitCode = $LASTEXITCODE
  }
  finally {
    $ErrorActionPreference = $oldErrorActionPreference
  }

  $output | Out-String | Set-Content -LiteralPath $LogPath -Encoding UTF8
  if ($exitCode -ne 0) {
    throw "Command failed ($exitCode): $Exe. See log: $LogPath"
  }

  return $output
}

function Read-SceneTimes {
  param([Parameter(Mandatory = $true)][string]$LogPath)

  if (-not (Test-Path -LiteralPath $LogPath)) {
    return @()
  }

  $matches = Select-String -LiteralPath $LogPath -Pattern "pts_time:([0-9]+(?:\.[0-9]+)?)" -AllMatches
  $times = New-Object System.Collections.Generic.List[double]
  foreach ($line in $matches) {
    foreach ($match in $line.Matches) {
      $times.Add([double]::Parse($match.Groups[1].Value, [System.Globalization.CultureInfo]::InvariantCulture))
    }
  }

  return @($times | Sort-Object -Unique)
}

function Test-VideoReadable {
  param(
    [Parameter(Mandatory = $true)][string]$Ffprobe,
    [Parameter(Mandatory = $true)][string]$Path
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    return $false
  }

  $oldErrorActionPreference = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  try {
    $raw = & $Ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $Path 2>$null
    $exitCode = $LASTEXITCODE
  }
  finally {
    $ErrorActionPreference = $oldErrorActionPreference
  }

  if ($exitCode -ne 0 -or [string]::IsNullOrWhiteSpace($raw)) {
    return $false
  }

  $duration = 0.0
  if (-not [double]::TryParse($raw.Trim(), [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$duration)) {
    return $false
  }

  return $duration -gt 1
}

function Select-CandidateStarts {
  param(
    [Parameter(Mandatory = $true)][double[]]$SceneTimes,
    [Parameter(Mandatory = $true)][double]$Duration,
    [Parameter(Mandatory = $true)][int]$Count,
    [Parameter(Mandatory = $true)][double]$SegmentDuration
  )

  $maxStart = [Math]::Max(0, $Duration - $SegmentDuration)
  $minSpacing = [Math]::Max(10, $SegmentDuration * 0.72)
  $starts = New-Object System.Collections.Generic.List[double]

  $starts.Add(0)

  foreach ($time in $SceneTimes) {
    if ($starts.Count -ge $Count) {
      break
    }

    $start = [Math]::Min($maxStart, [Math]::Max(0, $time - 2))
    $tooClose = $false
    foreach ($existing in $starts) {
      if ([Math]::Abs($existing - $start) -lt $minSpacing) {
        $tooClose = $true
        break
      }
    }

    if (-not $tooClose) {
      $starts.Add($start)
    }
  }

  $fallbackIndex = 1
  while ($starts.Count -lt $Count -and $Duration -gt $SegmentDuration) {
    $start = ($maxStart * $fallbackIndex) / [Math]::Max(1, $Count - 1)
    $fallbackIndex++

    $tooClose = $false
    foreach ($existing in $starts) {
      if ([Math]::Abs($existing - $start) -lt ($minSpacing * 0.65)) {
        $tooClose = $true
        break
      }
    }

    if (-not $tooClose) {
      $starts.Add($start)
    }

    if ($fallbackIndex -gt ($Count * 4)) {
      break
    }
  }

  return @($starts | Sort-Object | Select-Object -First $Count)
}

function ConvertTo-ManualStarts {
  param(
    [Parameter(Mandatory = $true)][string]$Value,
    [Parameter(Mandatory = $true)][double]$Duration,
    [Parameter(Mandatory = $true)][double]$SegmentDuration
  )

  if ([string]::IsNullOrWhiteSpace($Value)) {
    return @()
  }

  $maxStart = [Math]::Max(0, $Duration - $SegmentDuration)
  $starts = New-Object System.Collections.Generic.List[double]
  foreach ($part in ($Value -split ",")) {
    $trimmed = $part.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
      continue
    }

    $parsed = 0.0
    if (-not [double]::TryParse($trimmed, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$parsed)) {
      throw "Invalid manual start time: $trimmed"
    }

    $starts.Add([Math]::Min($maxStart, [Math]::Max(0, $parsed)))
  }

  return @($starts | Sort-Object -Unique)
}

function Write-CandidateReport {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$SourcePath,
    [Parameter(Mandatory = $true)][object]$Info,
    [Parameter(Mandatory = $true)][object[]]$Candidates,
    [Parameter(Mandatory = $true)][int]$SceneCount,
    [Parameter(Mandatory = $true)][string]$ContactSheetPath,
    [Parameter(Mandatory = $true)][string]$SelectionMode
  )

  $sourceName = [System.IO.Path]::GetFileName($SourcePath)
  $durationText = [Math]::Round($Info.Duration, 1)
  $audioText = if ($Info.HasAudio) { $Info.AudioCodec } else { "none" }

  $lines = @(
    ("# Auto-cut report - {0}" -f $sourceName),
    "",
    ("Source: {0}" -f $SourcePath),
    ("Duration: {0} sec" -f $durationText),
    ("Size: {0}x{1}" -f $Info.Width, $Info.Height),
    ("Video codec: {0}" -f $Info.VideoCodec),
    ("Audio: {0}" -f $audioText),
    ("Selection mode: {0}" -f $SelectionMode),
    "Scene threshold: auto-cut run metadata",
    ("Detected scene frames: {0}" -f $SceneCount),
    ("Contact sheet: {0}" -f $ContactSheetPath),
    "",
    "## Candidate shorts",
    "",
    "| Rank | Start | End | Duration | Rendered | Preview |",
    "|---:|---:|---:|---:|---|---|"
  )

  foreach ($candidate in $Candidates) {
    $lines += "| $($candidate.Rank) | $($candidate.StartSec)s | $($candidate.EndSec)s | $($candidate.DurationSec)s | $($candidate.RenderedFile) | $($candidate.PreviewFile) |"
  }

  $lines += @(
    "",
    "## Human review notes",
    "",
    "- Open the contact sheet first, then the preview images.",
    "- Keep candidates with a clear UI state change or obvious gameplay action in the first 1-2 seconds.",
    "- If a segment begins mid-sentence or mid-scroll, adjust StartSec manually in the generated CSV/manifest before final render.",
    "- This tool finds visual candidates; the final hook/title still needs human judgment."
  )

  $lines | Set-Content -LiteralPath $Path -Encoding UTF8
}

$repoRoot = Get-RepoRoot
if ([string]::IsNullOrWhiteSpace($InputDir)) {
  $InputDir = "C:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram"
}

if ([string]::IsNullOrWhiteSpace($OutputDir)) {
  $OutputDir = Join-Path $InputDir "_shorts_factory\auto-cut"
}

$sourcePath = if ([System.IO.Path]::IsPathRooted($SourceVideo)) {
  $SourceVideo
} else {
  Join-Path $InputDir $SourceVideo
}

if (-not (Test-Path -LiteralPath $sourcePath)) {
  throw "Missing source video: $sourcePath"
}

$watermarkPath = if ([System.IO.Path]::IsPathRooted($Watermark)) {
  $Watermark
} else {
  Join-Path $repoRoot $Watermark
}

if (-not (Test-Path -LiteralPath $watermarkPath)) {
  throw "Missing watermark: $watermarkPath"
}

$ffmpeg = Find-LocalTool "ffmpeg" $repoRoot
$ffprobe = Find-LocalTool "ffprobe" $repoRoot
$slug = if ([string]::IsNullOrWhiteSpace($RunName)) {
  New-SafeSlug ([System.IO.Path]::GetFileName($sourcePath))
} else {
  New-SafeSlug $RunName
}
$runDir = Join-Path $OutputDir $slug
$analysisDir = Join-Path $runDir "analysis"
$sceneFramesDir = Join-Path $analysisDir "scene-frames"
$previewDir = Join-Path $runDir "previews"
$renderedDir = Join-Path $runDir "rendered-candidates"
$logsDir = Join-Path $runDir "logs"

foreach ($dir in @($analysisDir, $sceneFramesDir, $previewDir, $renderedDir, $logsDir)) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

$info = Get-VideoInfo $ffprobe $sourcePath
$info | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $analysisDir "ffprobe-summary.json") -Encoding UTF8

$contactSheetPath = Join-Path $analysisDir "contact-sheet-8sec.jpg"
if ($Force -or -not (Test-Path -LiteralPath $contactSheetPath)) {
  Invoke-Native $ffmpeg @(
    "-hide_banner",
    "-y",
    "-i", $sourcePath,
    "-vf", "fps=1/8,scale=320:-1,tile=5x10",
    "-frames:v", "1",
    $contactSheetPath
  ) (Join-Path $logsDir "contact-sheet.ffmpeg.log") | Out-Null
}

$sceneLogPath = Join-Path $logsDir "scene-detect.ffmpeg.log"
$sceneFramePattern = Join-Path $sceneFramesDir "scene-%03d.jpg"
if ($Force -or -not (Test-Path -LiteralPath $sceneLogPath)) {
  Invoke-Native $ffmpeg @(
    "-hide_banner",
    "-y",
    "-i", $sourcePath,
    "-vf", "select='gt(scene,$(Format-InvariantNumber $SceneThreshold))',scale=480:-1,showinfo",
    "-vsync", "vfr",
    "-frames:v", "$MaxSceneFrames",
    $sceneFramePattern
  ) $sceneLogPath | Out-Null
}

$sceneTimes = @(Read-SceneTimes $sceneLogPath)
$manualStarts = @(ConvertTo-ManualStarts $ManualStartsSec $info.Duration $SegmentDurationSec)
$selectionMode = if ($manualStarts.Count -gt 0) { "manual" } else { "auto" }
$candidateStarts = if ($manualStarts.Count -gt 0) {
  @($manualStarts | Select-Object -First $CandidateCount)
} else {
  @(Select-CandidateStarts $sceneTimes $info.Duration $CandidateCount $SegmentDurationSec)
}
$candidateRows = New-Object System.Collections.Generic.List[object]
$rank = 1

foreach ($start in $candidateStarts) {
  $duration = [Math]::Min($SegmentDurationSec, $info.Duration - $start)
  if ($duration -lt 4) {
    continue
  }

  $startRounded = [Math]::Round($start, 1)
  $endRounded = [Math]::Round($start + $duration, 1)
  $rankLabel = "{0:00}" -f $rank
  $previewPath = Join-Path $previewDir ("candidate-$rankLabel-preview.jpg")
  $renderedPath = Join-Path $renderedDir ("candidate-$rankLabel-$slug.mp4")

  if ($Force -or -not (Test-Path -LiteralPath $previewPath)) {
    Invoke-Native $ffmpeg @(
      "-hide_banner",
      "-y",
      "-ss", (Format-InvariantNumber $start),
      "-i", $sourcePath,
      "-frames:v", "1",
      "-q:v", "2",
      $previewPath
    ) (Join-Path $logsDir "candidate-$rankLabel-preview.ffmpeg.log") | Out-Null
  }

  $renderedReadable = Test-VideoReadable $ffprobe $renderedPath
  if (-not $AnalyzeOnly -and ($Force -or -not $renderedReadable)) {
    $videoFilter = '[0:v]split=2[vbg][vfg];[vbg]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=28,eq=brightness=-0.08:saturation=0.85[bg];[vfg]scale=1080:1920:force_original_aspect_ratio=decrease[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2[base];[1:v]scale=1080:1920[wm];[base][wm]overlay=0:0[v]'
    $args = New-Object System.Collections.Generic.List[object]
    foreach ($arg in @(
      "-hide_banner",
      "-y",
      "-ss", (Format-InvariantNumber $start),
      "-i", $sourcePath,
      "-loop", "1",
      "-i", $watermarkPath,
      "-filter_complex", $videoFilter,
      "-map", "[v]"
    )) {
      $args.Add($arg)
    }

    if ($info.HasAudio) {
      foreach ($arg in @("-map", "0:a:0", "-c:a", "aac", "-b:a", "160k")) {
        $args.Add($arg)
      }
    } else {
      $args.Add("-an")
    }

    foreach ($arg in @(
      "-c:v", "libx264",
      "-preset", "veryfast",
      "-crf", "20",
      "-pix_fmt", "yuv420p",
      "-movflags", "+faststart",
      "-t", (Format-InvariantNumber $duration),
      $renderedPath
    )) {
      $args.Add($arg)
    }

    Invoke-Native $ffmpeg $args.ToArray() (Join-Path $logsDir "candidate-$rankLabel-render.ffmpeg.log") | Out-Null
  }

  $candidateRows.Add([pscustomobject]@{
    Rank = $rank
    SourceVideo = [System.IO.Path]::GetFileName($sourcePath)
    StartSec = $startRounded
    EndSec = $endRounded
    DurationSec = [Math]::Round($duration, 1)
    PreviewFile = $previewPath
    RenderedFile = if ($AnalyzeOnly) { "" } else { $renderedPath }
    SuggestedHook = "Show one clear Divergentum screen change in the first two seconds."
  })

  $rank++
}

$candidateCsvPath = Join-Path $runDir "candidates.csv"
$candidateJsonPath = Join-Path $runDir "candidates.json"
$reportPath = Join-Path $runDir "auto-cut-report.md"

$candidateArray = @($candidateRows.ToArray())
$candidateArray | Export-Csv -LiteralPath $candidateCsvPath -NoTypeInformation -Encoding UTF8
$candidateArray | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $candidateJsonPath -Encoding UTF8
Write-CandidateReport `
  -Path $reportPath `
  -SourcePath $sourcePath `
  -Info $info `
  -Candidates $candidateArray `
  -SceneCount $sceneTimes.Count `
  -ContactSheetPath $contactSheetPath `
  -SelectionMode $selectionMode

Write-Host "Auto-cut complete:"
Write-Host "  Source: $sourcePath"
Write-Host "  Output: $runDir"
Write-Host "  Contact sheet: $contactSheetPath"
Write-Host "  Scene frames: $sceneFramesDir"
Write-Host "  Candidates: $candidateCsvPath"
Write-Host "  Report: $reportPath"
if (-not $AnalyzeOnly) {
  Write-Host "  Rendered candidates: $renderedDir"
}
