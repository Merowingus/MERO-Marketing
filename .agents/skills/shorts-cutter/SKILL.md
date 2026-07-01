---
name: shorts-cutter
description: Reusable video cutting workflow for turning source videos from `Output/Tik-tok_youtube_instagram/Shorts - to cut` into TikTok/Reels/YouTube Shorts packages in `Output/Tik-tok_youtube_instagram/Shorts -done`. Use when the user asks to inspect, preview, cut, slice, auto-cut, нарезать видео, зробити шортси, сделать шортсы из длинного видео, or process videos dropped into the Shorts input folder.
---

# Shorts Cutter

Turn a longer source video into reviewable, publishable short-form candidates. The goal is not blind
automation. The goal is a repeatable human-in-the-loop workflow: see the video, pick strong starts,
render candidates, verify files, then decide what to publish.

## Ground rules

- Zero fabrication: do not invent what happens in the clip.
- Source videos to cut must come from `Shorts - to cut` unless the user explicitly names another file.
- Final deliverables must go to `Shorts -done`.
- Scratch analysis may stay under ignored `Output/.../_shorts_factory/auto-cut/`.
- Keep reusable logic in `channels/youtube/shorts-factory/`.
- Preserve source audio by default. Do not add music unless the user asks.
- Prefer human-curated starts after contact-sheet review over blind scene detection.
- Do not process other videos in `Output/Tik-tok_youtube_instagram` just because they are nearby.
- Use absolute Windows paths.

## Default paths

- Input videos: `E:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram\Shorts - to cut`
- Final output: `E:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram\Shorts -done`
- Auto-cut script: `E:\CODE\MERO MARKETING\channels\youtube\shorts-factory\Invoke-AutoCut.ps1`
- Scratch output root: `E:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram\_shorts_factory\auto-cut`
- Watermark: `channels/youtube/assets/merowingus-studio-watermark-shorts-1080x1920-20.png`

## Workflow

1. Read project context first:
   - `E:\CODE\MEROWINGUS Studio\coordination\MERO_MARKETING_SYNC.md`
   - `E:\CODE\MERO MARKETING\channels\youtube\shorts-factory\README.md`
2. Confirm git state. If code/scripts/docs will change, work on a feature branch.
3. Inspect only the source video(s) placed in `Shorts - to cut` with `ffprobe` or `Invoke-AutoCut.ps1 -AnalyzeOnly`.
4. Generate visual review artifacts:
   - contact sheet for the full video;
   - scene frames;
   - preview frames for candidate starts.
5. Review the contact sheet visually. Pick starts with:
   - a hook or clear state change in the first 1-2 seconds;
   - readable UI;
   - not starting mid-scroll, mid-settings, or mid-wall-of-text;
   - a visible product truth: character creation, choice, inventory, battle, scene response.
6. Run curated cuts with `-ManualStartsSec`.
7. Render the final selected Shorts into `Shorts -done`, not into the scratch folder.
8. Write upload metadata into `Shorts -done`:
   - `upload-sheet.csv`;
   - `upload-sheet.json`;
   - `metadata/<short>.md`;
   - `previews/<short>.jpg`.
9. Verify each MP4 with `ffprobe`: duration, 1080x1920, audio present if expected.
10. Open preview/contact-sheet images for visual QA.
11. Report winners and weak candidates plainly. Recommend publish order.
12. If marketing state changes, update the coordination journal. Do not update live dashboard unless
    actual campaign/channel status changed.

## Commands

Analyze only:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "E:\CODE\MERO MARKETING\channels\youtube\shorts-factory\Invoke-AutoCut.ps1" -InputDir "E:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram\Shorts - to cut" -SourceVideo "first tiktok.mp4" -AnalyzeOnly -Force
```

Automatic candidates:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "E:\CODE\MERO MARKETING\channels\youtube\shorts-factory\Invoke-AutoCut.ps1" -InputDir "E:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram\Shorts - to cut" -SourceVideo "first tiktok.mp4" -Force
```

Curated candidates:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "E:\CODE\MERO MARKETING\channels\youtube\shorts-factory\Invoke-AutoCut.ps1" -InputDir "E:\CODE\MERO MARKETING\Output\Tik-tok_youtube_instagram\Shorts - to cut" -SourceVideo "first tiktok.mp4" -RunName "first-tiktok-curated" -ManualStartsSec "0,24,108" -CandidateCount 3 -SegmentDurationSec 45 -Force
```

## Choosing starts

Use automatic scene detection as a first pass, not the final editor. For UI-heavy gameplay recordings,
scene detection often misses the real marketing beats. Contact sheet review is the important step.

Strong starts:

- existing on-screen hook;
- character/race/class screen;
- inventory opening or item use;
- choice selection;
- visible combat/action;
- generated scene/result appearing.

Weak starts:

- settings modal;
- browser/devtools visible;
- middle of a long paragraph;
- repeated static tavern text;
- cursor hovering with no meaningful change.

## Output to user

Keep it practical:

- which input folder was used;
- where the final outputs are;
- which candidates are technically valid;
- which are worth publishing;
- which starts need adjustment;
- exact command to rerun.
