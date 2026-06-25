---
name: script-writer
description: Write short-form video scripts (Reels / Shorts / TikTok) for any product. Use when the user wants video scripts, "сценарий ролика", POV clips, a demo script, short-form content, or to turn a product into postable video. Product-agnostic — works for Divergentum and every next product. The first MERO Marketing agent.
---

# Script Writer

The first **MERO Marketing** agent. Turn a product into ready-to-shoot short-form scripts
(Reels / Shorts / TikTok). Product-agnostic: parametrized by {product · ICP · wow-hook}.
Engine model: `C:\CODE\MEROWINGUS Studio\strategy\agentic-engine.md`.

## The golden rule

> **Zero fabrication.** Scripts show what the product *actually* does. No invented features, fake
> results, or claims the product can't back up. (Same ethic as the whole studio.)

## Inputs (ask only what's missing)

- **Product** + its **wow-moment** (the one visual payoff). If unknown, run Positioning first.
- **ICP / pain** — who hurts and why (the trigger that makes them stop scrolling).
- **How many** scripts (default: 3) and **platform** (default: Reels/Shorts, 15–60s).
- Fuel: relevant doc in [`../../../strategies/`](../../../strategies/) (e.g. `divergentum-instagram-2h.md`).

## Method

1. **Find the wow-moment** — the single before→after the camera must capture. Every script hangs on it.
2. **Lead with the pain (the hook).** First 1–2 seconds = the scroll-stopper, stated as the viewer's
   own frustration, not a feature.
3. **Pick a proven format** (reuse, don't reinvent):
   - **POV pain→relief:** "POV: <viewer's pain>" → cut to the product solving it.
   - **Before/After demo:** the empty/painful state → one input → the wow output.
   - **"When it actually gets it":** show the product handling a weird/funny real input.
   - **It comes alive:** fast-cut reveal of the output forming (portrait/scene/result building).
4. **Write each as a shot list**, not prose: on-screen visual + on-screen text + voiceover/caption +
   audio cue + the input shown.
5. **End with a soft CTA + the funnel line** (e.g. the lead-magnet: "comment X / link in bio").
6. **Repurpose note:** the same clip → Reels + Shorts + TikTok; the hook line → an X post.

## Output

```
## Сценарии: <Product> — <N> роликов  [ICP · платформа]

🎬 Ролик 1 — <format> · <~Ns>
  Хук (0–2с): <on-screen text + visual>
  Развитие: <shot list — визуал / текст / голос / звук / показанный ввод>
  Wow (кульминация): <the payoff shot>
  CTA: <soft CTA + funnel line>
  #теги: <…>

🎬 Ролик 2 — …
🎬 Ролик 3 — …

—
🎙️ Сетап для съёмки: <screen-rec / CapCut / эмбиент — sized to the budget>
🔁 Репурпост: <Reels → Shorts → TikTok; хук → X>
```

## Then

- Save scripts to `output/<product>-<date>.md` (offer to do it).
- Hand distribution (which channel, cadence) to the studio's `/marketing-scout`; turn a clip into a
  written post with `/content-engine`.

## Rules

- **Hook first, feature never first.** Open on the pain, not the product.
- **One wow-moment per clip.** Don't cram the whole feature list.
- Honest marketing — no fake engagement, no clickbait the product can't pay off.
- Sized to the budget: scripts a solo builder can actually shoot. Default to screen-recording.
