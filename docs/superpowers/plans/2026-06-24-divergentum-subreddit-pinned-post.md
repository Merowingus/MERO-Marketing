# Divergentum Subreddit Pinned Post Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Produce a publish-ready English pinned welcome post for `r/Divergentum`, plus gallery captions and the tracked game link.

**Architecture:** The deliverable is one focused Markdown asset in `channels/reddit/`. It contains publication metadata, the post body, gallery order and captions, and a final fact and style checklist. The copy is built only from the approved design and verified Divergentum documentation.

**Tech Stack:** Markdown, Reddit, Divergentum product documentation, GA4 and UTM attribution.

## Global Constraints

- Write in first-person English at approximately 700–900 words.
- Focus on the game and its ideas, not the internal development process.
- Use a natural, personal voice without startup language or inflated claims.
- Do not use em dashes or double hyphens as prose punctuation.
- Avoid generic hooks, repetitive three-part lists, fake quotations, rhetorical filler, excessive headings, and tidy slogan-like conclusions.
- Do not claim full D&D rules coverage or mechanically unlimited actions.
- Name only the five verified playable classes: Fighter, Rogue, Wizard, Druid, and Paladin.
- Use one soft CTA link near the end.
- Do not optimize for evading automated authorship detectors.

---

### Task 1: Draft the pinned post

**Files:**
- Create: `channels/reddit/divergentum-subreddit-welcome-2026-06-24.md`

**Interfaces:**
- Consumes: `docs/superpowers/specs/2026-06-24-divergentum-subreddit-pinned-post-design.md`
- Produces: A complete English Reddit post body and publication metadata.

- [ ] **Step 1: Write the title and opening**

Use a direct title that sounds like a person introducing a project they care about. Open with the creator's relationship to D&D and computer RPGs, without claiming extensive tabletop play experience.

- [ ] **Step 2: Write the origin story**

Explain that another solo RPG showed how absorbing this format could be, while leaving the creator wanting stronger mechanics, clearer design, and a more complete fantasy atmosphere. Do not name or attack the other project.

- [ ] **Step 3: Explain the intended experience**

Describe coherent art direction, warm fairy-tale colors, environmental sound, music, free-text actions, a responsive Dungeon Master, and the player's responsibility for the depth of the story.

- [ ] **Step 4: Explain the rules scope**

Use the official D&D character sheet image as a transition into the scale of D&D mechanics. State that the first release deliberately focuses on five classes with a solid base of attributes, checks, equipment, combat, spells, and class abilities.

- [ ] **Step 5: Write the invitation**

Invite readers to play, share what worked or broke immersion, join `r/Divergentum`, and influence the next stage. Include:

```text
https://www.divergentum.com/?utm_source=reddit&utm_medium=community&utm_campaign=divergentum_subreddit_welcome
```

### Task 2: Add gallery captions and publishing notes

**Files:**
- Modify: `channels/reddit/divergentum-subreddit-welcome-2026-06-24.md`

**Interfaces:**
- Consumes: The five approved image paths from the design.
- Produces: Numbered gallery order, short captions, source note for the official D&D screenshot, and pinning instructions.

- [ ] **Step 1: Add the five-image order**

List the cinematic cover, gameplay screen, character screen, inventory screen, and official D&D character sheet in that order.

- [ ] **Step 2: Add concise captions**

Keep each caption to one sentence. Describe only what is visible or verifiably implemented.

- [ ] **Step 3: Add the source note**

State clearly that the fifth image is a screenshot of the official D&D character sheet used to illustrate rules complexity and is not Divergentum UI.

### Task 3: Editorial and factual verification

**Files:**
- Modify: `channels/reddit/divergentum-subreddit-welcome-2026-06-24.md`
- Read: `C:\CODE\Divergentum\_docs\PROGRESS.md`
- Read: `C:\CODE\Divergentum\_docs\DND_RULES.md`

**Interfaces:**
- Consumes: Draft copy and verified product documentation.
- Produces: Publish-ready copy with no unsupported product claims.

- [ ] **Step 1: Verify product claims**

Confirm every mentioned class and mechanic against the project documentation. Remove or qualify anything not demonstrably shipped.

- [ ] **Step 2: Run the style scan**

Search for em dashes, double hyphens, generic marketing phrases, repeated sentence openings, excessive colon-led lists, and artificial conclusion language. Rewrite each occurrence in plain speech.

- [ ] **Step 3: Read aloud for rhythm**

Split sentences that carry too many clauses. Preserve a few short, imperfectly symmetrical paragraphs so the post reads like a person talking about a game they care about.

- [ ] **Step 4: Check length and formatting**

Keep the body between 700 and 900 words, confirm one external link, and ensure the title, body, captions, and notes are clearly separated.

- [ ] **Step 5: Verify the Markdown diff**

Run:

```powershell
git diff --check
```

Expected: no whitespace errors.
