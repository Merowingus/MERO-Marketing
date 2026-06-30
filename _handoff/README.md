# _handoff — Architect → Developer contract files

This folder holds the **handoff contract** between the development agents (`../_skills/`). It is the
single source of truth for an in-flight feature. Not deployed (lives outside `dashboard/`).

## Files (created/updated by agents, not by hand)
- `DEVELOPER_INSTRUCTIONS.md` — written by **ARCHITECT** (14-section format), read by **DEVELOPER**.
- `TEST_PLAN.md` — written by **ARCHITECT**, used by **TESTER** (and topped up by **CODE_REVIEWER**).
- `AUTOPILOT_STATE.md` — written by **AGENT_ROUTER** in `Роут: автопилот` mode
  (`step` / `verdict` / `retry_count` / `pr_number`).

These are working files — overwritten per feature. History lives in git + PRs, not here.

## Flow
`BUSINESS_ANALYST → ARCHITECT (writes handoff) → DEVELOPER (reads it) → TESTER → CODE_REVIEWER →
TECHNICAL_WRITER`. See [`../_skills/AGENTS_CATALOG.md`](../_skills/AGENTS_CATALOG.md).
