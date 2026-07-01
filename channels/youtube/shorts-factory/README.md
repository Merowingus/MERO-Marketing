# MERO YouTube Shorts Factory

Local factory for turning existing Divergentum clips into publish-ready Shorts/Reels assets.

## Inputs

- Videos: `C:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram\*.mp4`
- Music: `C:\CODE\Divergentum\public\audio\music\**\*.mp3`
- Watermark: `channels/youtube/assets/merowingus-studio-watermark-shorts-1080x1920-20.png`
- Manifest: `channels/youtube/shorts-factory/shorts-manifest.json`

## Outputs

Generated files are written to:

`C:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram\_shorts_factory\`

Folders:

- `manifest/` — copied manifest for the run.
- `metadata/` — one YouTube-ready Markdown file per Short.
- `captions/` — generated `.ass` text plans.
- `rendered/` — final MP4 files.
- `logs/` — ffmpeg logs.
- `upload-sheet.csv` — spreadsheet-friendly upload metadata.
- `render-report.json` — render status report.

## Run

```powershell
.\channels\youtube\shorts-factory\Invoke-ShortsFactory.ps1 -Force
```

Optional: burn the generated text into the videos.

```powershell
.\channels\youtube\shorts-factory\Invoke-ShortsFactory.ps1 -Force -BurnText
```

Default behavior does **not** burn text over gameplay UI. It only renders video + music + watermark and
stores the text plan in metadata/captions.

## Auto-cut a longer video

Use this when a source video is longer than one Short and you want candidate cuts first.

```powershell
.\channels\youtube\shorts-factory\Invoke-AutoCut.ps1 -SourceVideo "first tiktok.mp4" -Force
```

Use manual start times when the contact sheet shows better human cuts than scene detection:

```powershell
.\channels\youtube\shorts-factory\Invoke-AutoCut.ps1 `
  -SourceVideo "first tiktok.mp4" `
  -RunName "first-tiktok-curated" `
  -ManualStartsSec "0,24,108" `
  -CandidateCount 3 `
  -SegmentDurationSec 45 `
  -Force
```

Generated auto-cut artifacts are written to:

`C:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram\_shorts_factory\auto-cut\<video-slug>\`

Folders/files:

- `analysis/contact-sheet-8sec.jpg` — quick visual scan of the whole video.
- `analysis/scene-frames/` — frames around detected visual changes.
- `previews/` — first frame for each candidate Short.
- `rendered-candidates/` — draft 1080×1920 MP4 cuts with the subtle watermark.
- `candidates.csv` / `candidates.json` — start/end times for manual refinement.
- `auto-cut-report.md` — human review checklist.

The auto-cut tool finds visual candidates; final hook/title selection still needs human judgment.
It preserves source audio when present and does not add music by default.

## Music attribution

The manifest includes the required attribution from Divergentum's music credits:

`Music by Kevin MacLeod (incompetech.com) — Licensed under Creative Commons: By Attribution 4.0`

Keep this attribution in YouTube descriptions unless the track source changes.

## Notes

- `first tiktok.mp4` is longer than Shorts format, so the manifest trims it to 58 seconds.
- `Divergentum - 8 Fantasy races.mp4` is 97 seconds and remains valid for YouTube Shorts.
- Rendered videos are generated artifacts and should not be committed to git.
