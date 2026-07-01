# YouTube Shorts Factory v1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert the existing Divergentum short videos into publish-ready YouTube Shorts/Reels assets with metadata, licensed in-game music, and Merowingus Studio watermarking.

**Architecture:** Keep the factory local and file-driven. Store the reusable script and manifest in `channels/youtube/shorts-factory/`. Read source videos from `Output/Tik-tok_youtube_instagram/`, read licensed music from `C:\CODE\Divergentum\public\audio\music`, and write generated outputs to `Output/Tik-tok_youtube_instagram/_shorts_factory/`.

**Tech Stack:** PowerShell, portable ffmpeg/ffprobe in `.tools/ffmpeg`, JSON manifest, Markdown metadata, CSV upload sheet.

## Global Constraints

- Use only music from `C:\CODE\Divergentum\public\audio\music`.
- Keep generated rendered videos out of git.
- Use the 20% Merowingus Studio watermark overlay by default.
- Do not fake metrics or upload results.
- Default render should not burn text over gameplay UI; generate captions/text plans, and allow `-BurnText` as an optional flag.

---

### Task 1: Local ffmpeg

**Files:**
- Generated local tool: `E:\CODE\MERO MARKETING\.tools\ffmpeg\...\ffmpeg.exe`
- Modify: `E:\CODE\MERO MARKETING\.gitignore`

**Interfaces:**
- Produces: a local ffmpeg path discoverable by the render script.

- [ ] Install portable ffmpeg under `.tools/ffmpeg`.
- [ ] Add `.tools/` to `.gitignore`.
- [ ] Verify `ffmpeg -version` and `ffprobe -version`.

### Task 2: Manifest and render script

**Files:**
- Create: `E:\CODE\MERO MARKETING\channels\youtube\shorts-factory\shorts-manifest.json`
- Create: `E:\CODE\MERO MARKETING\channels\youtube\shorts-factory\Invoke-ShortsFactory.ps1`
- Create: `E:\CODE\MERO MARKETING\channels\youtube\shorts-factory\README.md`

**Interfaces:**
- Consumes: source videos, music files, watermark overlay.
- Produces: metadata Markdown, captions `.ass`, upload-sheet CSV, rendered `.mp4`.

- [ ] Add one manifest item per current source video.
- [ ] Include title, description, hashtags, pinned comment, on-screen text, UTM link, music file, trim duration.
- [ ] Write metadata files and upload sheet from the manifest.
- [ ] Render 1080x1920 MP4 with blurred background, foreground video, watermark, and mixed/added music.

### Task 3: Render and verify

**Files:**
- Generated output: `E:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram\_shorts_factory\`

**Interfaces:**
- Produces: publish-ready local files.

- [ ] Run the script once.
- [ ] Verify every rendered MP4 exists.
- [ ] Probe rendered duration/size.
- [ ] Commit scripts/manifest/docs, not rendered videos.
