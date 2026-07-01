# YouTube Shorts Factory — auto-cut mode

Date: 2026-07-01

## Goal

Add a reusable local workflow that can inspect a longer source video, produce visual review artifacts,
and render draft 1080x1920 Shorts candidates without committing generated media to git.

## Scope

- Add `channels/youtube/shorts-factory/Invoke-AutoCut.ps1`.
- Reuse local portable ffmpeg/ffprobe from `.tools/`.
- Output generated artifacts under ignored `Output/.../_shorts_factory/auto-cut/`.
- Preserve source audio by default; do not add music in auto-cut mode.
- Add manual start-time override for human-curated cuts.

## Verification

- Ran auto analysis for `first tiktok.mp4`.
- Rendered 5 automatic draft candidates.
- Rendered 3 curated draft candidates from starts `0,24,108`.
- Verified curated MP4s with ffprobe: 45s, 1080x1920, audio present.

## Notes

For `first tiktok.mp4`, pure scene detection only found two strong visual changes because much of the
video is long-form text gameplay. The useful workflow is therefore:

1. Generate contact sheet.
2. Pick human starts from the sheet.
3. Rerun with `-ManualStartsSec`.

