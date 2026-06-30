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

## Music attribution

The manifest includes the required attribution from Divergentum's music credits:

`Music by Kevin MacLeod (incompetech.com) — Licensed under Creative Commons: By Attribution 4.0`

Keep this attribution in YouTube descriptions unless the track source changes.

## Notes

- `first tiktok.mp4` is longer than Shorts format, so the manifest trims it to 58 seconds.
- `Divergentum - 8 Fantasy races.mp4` is 97 seconds and remains valid for YouTube Shorts.
- Rendered videos are generated artifacts and should not be committed to git.
