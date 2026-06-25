# Codex and Claude Code Studio Sync — Design

## Goal

Give Codex in `C:\CODE\MERO MARKETING` and Claude Code in
`C:\CODE\MEROWINGUS Studio` one durable shared memory for cross-project decisions, plans, handoffs,
implementation results, and blockers.

The system coordinates agents through files and Git. It does not attempt to connect model sessions
directly.

## Responsibility model

- Both Codex and Claude Code may research, brainstorm, and design.
- Codex owns marketing strategy, campaigns, content, experiments, and metric definitions in
  `C:\CODE\MERO MARKETING`.
- Claude Code owns implementation of Studio website UI and backend in
  `C:\CODE\MEROWINGUS Studio`.
- Studio implementation tasks use the existing engineering pipeline:
  `_handoff/DEVELOPER_INSTRUCTIONS.md` and `_handoff/TEST_PLAN.md`.
- Both agents read and update the shared journal around cross-project work.

## Files

### Canonical journal

`C:\CODE\MEROWINGUS Studio\coordination\MERO_MARKETING_SYNC.md`

The Studio is the head project and the future host of the MERO Marketing dashboard, so the canonical
cross-agent state lives there.

### Marketing pointer

`C:\CODE\MERO MARKETING\coordination\SYNC.md`

This file contains only the canonical path and the operating protocol. It must not duplicate journal
state.

### Agent instructions

- Studio `CLAUDE.md` tells Claude Code to read and update the journal.
- MERO Marketing `CLAUDE.md` and `AGENTS.md` tell Claude Code and Codex to do the same.

## Journal structure

1. `Protocol`
2. `Current state`
3. `Current weekly focus`
4. `Approved decisions`
5. `Studio implementation queue`
6. `Marketing queue`
7. `Blockers`
8. `Log`, newest entry first
9. Reusable entry template

The current state remains short. Large specs, plans, screenshots, and implementation details stay in
their owning repositories and are linked from the journal.

## Update protocol

### Before cross-project work

1. Read the canonical journal.
2. Check the latest repository state instead of trusting stored commit heads.
3. Open only the linked spec, handoff, or checkpoint needed for the task.

### After cross-project work

1. Update current state if facts changed.
2. Add a newest-first log entry containing:
   - agent;
   - work completed;
   - decisions;
   - files changed;
   - commit or PR;
   - blockers;
   - next owner and next step.
3. Do not mark planned work as implemented.

### Studio implementation handoff

1. Codex or Claude Code may prepare the approved design.
2. The Studio Architect translates it into the existing 14-section developer handoff and test plan.
3. Claude Code implements through a Studio feature branch and PR.
4. Claude Code records actual implementation, deviations, verification, and PR status in the journal.
5. Codex then updates campaign plans and analytics based on shipped reality.

## Initial weekly focus, June 25, 2026

### Main wheel

Run the Divergentum launch through two channels:

- Reddit is the spearhead for high-intent players.
- TikTok is the organic reach loop.

This supports product traction, reusable content, and public trust at the same time.

### Work under 5–10 hours

- Reddit: publish unique DevLog posts in one or two suitable communities and answer early comments.
- TikTok: launch the account and publish one or two POV clips showing input, a 5e check, and the game
  response or visual payoff.
- Measurement: verify UTM attribution and GA4 events for `sign_up` and `turn_taken`.
- Discord: create `#hall-of-fame` as a supporting UGC store, not a third acquisition channel.
- Blog: publish the existing “last 10 percent” draft and create a shortened LinkedIn version without
  treating LinkedIn as a separate channel.

### Definition of Done

- Reddit and TikTok are live.
- Unique Reddit posts are published and early comments receive replies.
- One or two TikTok clips are published.
- UTM attribution works.
- GA4 shows `sign_up` and `turn_taken` by source.
- Discord contains `#hall-of-fame`.
- The existing build-in-public article is published.

### Explicitly parked

Product Hunt, Hacker News, YouTube, X, full LinkedIn operations, SEO articles, Divergentum mobile,
Planner v2, and speculative new tools or agents.

## First cross-agent project

The first project governed by this protocol is the MERO Marketing Dashboard.

- Codex defines the marketing data model, workflow, campaign state, experiments, and required metrics.
- Claude Code implements the dashboard in the Studio using the existing design system and the
  `mero-marketing.theme.css` theme.
- The dashboard design remains in brainstorming until separately approved.

## Consistency rules

- Repository files remain the source for plans and produced assets.
- The journal stores pointers and state, not duplicate content.
- Live facts override stale journal notes.
- Known playable Divergentum classes are Fighter, Rogue, Wizard, Druid, and Paladin. The class list
  is not an open blocker.
- Existing unrelated working-tree changes must not be overwritten or bundled into sync commits.
