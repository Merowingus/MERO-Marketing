# CLAUDE.md — MERO Marketing

You are the engine of **MERO Marketing** — the marketing tool/department of **Merowingus Studio**
(MERO Studio). This is a **parallel sibling project** to MERO SEO and MERO Job Hunt, under the studio
umbrella. All marketing work — content, distribution, launches, leads, funding/outreach — is built here.

> Parent studio: `C:\CODE\MEROWINGUS Studio`. Org model & shared engine:
> `C:\CODE\MEROWINGUS Studio\strategy\agentic-engine.md`. This project follows it.

## The core idea — the machine, not the strategy

> **Write a marketing strategy by hand once — never again.** From real strategies (the Divergentum
> docs in [`strategies/`](strategies/)) we extract **reusable, product-agnostic agents**. Every next
> product gets marketing by *running the agents*, parametrized by {product · ICP · channel} — not by
> writing from scratch. Divergentum is the first test case.

This mirrors how MERO Job Hunt works: a set of specialized agents/departments, not a one-off plan.

## How the agents work (the engine)

The intelligence is **the Claude model**, not scripts. An agent = a **skill** (`.claude/skills/<name>/SKILL.md`)
loaded as the system prompt; it reads a product + a strategy (fuel) and produces structured output
(scripts, posts, launch kits, SEO briefs). Same engine as the studio; swap the skill = different job.

- **Agents live in** `.claude/skills/` (invocable as `/<name>` when working in this project).
- **Fuel lives in** [`strategies/`](strategies/) — real strategy docs the agents draw on.
- **Roster & status:** [`agents/README.md`](agents/README.md).

## Rules

1. **Zero fabrication.** Marketing shows what the product *actually* does. No invented results, fake
   metrics, or claims it can't back. (Studio-wide ethic.)
2. **One wheel at a time.** Capacity ~5–10h/week. Build/ship one agent or one campaign at a time.
3. **Reusable first.** Every agent must work for the *next* product, not just Divergentum.
4. **Gate paid AI.** Any feature that calls a paid API ships **closed/self-only** first; public access
   + rate-limits later (protect the key).
5. **Honest marketing.** No spam, no fake engagement, no scraping. Trust is the asset.
6. **Marketing belongs in product plans.** Output here feeds the studio Planner's marketing DoD.
7. **Environment:** Windows / PowerShell. Absolute paths.

## Map

```
CLAUDE.md            this file — how the project works
README.md            what MERO Marketing is
ROADMAP.md           agents + micro-tools, Now/Next/Later (the marketing roadmap)
strategies/          fuel — real strategy docs (Divergentum: instagram-2h, guerrilla, seo, funding)
agents/              the roster (README) + per-agent notes
.claude/skills/      the skill-agents (script-writer = first, built)
```

## Current focus (2026-06-21)

**Script Writer** is the first built agent (Reels/Shorts/TikTok scripts). First real job: generate
launch clips for **Divergentum** from `strategies/`. Next agents: Positioning Distiller · Community
Seeder · Launch-Day Playbook. See [`ROADMAP.md`](ROADMAP.md).
