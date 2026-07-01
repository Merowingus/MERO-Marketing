# CLAUDE.md — MERO Marketing

You are the engine of **MERO Marketing** — the marketing tool/department of **Merowingus Studio**
(MERO Studio). This is a **parallel sibling project** to MERO SEO and MERO Job Hunt, under the studio
umbrella. All marketing work — content, distribution, **launches & releases**, leads, funding/outreach
— is built here.

> Parent studio: `E:\CODE\MEROWINGUS Studio`. Org model & shared engine:
> `E:\CODE\MEROWINGUS Studio\strategy\agentic-engine.md`. This project follows it.
>
> **Coordination journal (sync with Claude Code / Studio dev):** before & after work, read and update
> `E:\CODE\MEROWINGUS Studio\coordination\MERO_MARKETING_SYNC.md` (decisions · changes · commit/PR ·
> blockers · next step). Local pointer: [`coordination/SYNC.md`](coordination/SYNC.md).

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

- **Start at** `marketing-orchestrator` — the menu of every agent; it routes to the right one.
- **Plan with** `strategy-architect` — sequences channels and says which agent to build next.
- **One agent per channel** (`reddit`, `instagram`, `tiktok`, `youtube`, `x-twitter`, `linkedin`,
  `product-hunt`, `hacker-news`, `discord`, `blog`, `seo`); each stores output in `channels/<name>/`.
- **Agents live in** `.claude/skills/` (invocable as `/<name>` in this project).
- **Fuel lives in** [`strategies/`](strategies/); **experiments** in [`experiments.md`](experiments.md).
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
7. **Platform base, not tool internals.** What lets *other* Studio products plug in is the **shared
   layer** (design tokens · auth/tenant+RLS · the agentic engine · the contract/MCP convention) —
   **never** the internals of one tool. The pattern generalizes; the schema does not. Tools stay
   **parallel siblings**; cross-product work is orchestrated by **MERO Product (the Planner)**. Build
   marketing concretely on the shared stack now, keep the seams clean, and extract platform packages
   only when the second tool arrives (rule of three). See
   [`docs/architecture/mero-marketing-command-center-online-architecture.md`](docs/architecture/mero-marketing-command-center-online-architecture.md)
   → "Fit within the Studio platform".
8. **Environment:** Windows / PowerShell. Absolute paths.

## Map

```
CLAUDE.md            this file — how the project works
README.md            what MERO Marketing is
ROADMAP.md           Now/Next/Later (the marketing roadmap)
strategies/          fuel — real strategy docs (Divergentum: instagram-2h, guerrilla, seo, funding)
agents/              the roster (README) + per-agent notes
channels/<name>/     per-channel output (reddit, instagram, tiktok, … each agent writes here)
campaigns/<x>/       per-campaign plan + assets (e.g. campaigns/divergentum/)
experiments.md       experiment → skill loop (what wins becomes the next agent)
.claude/skills/      the skill-agents (orchestrator, strategy-architect, + one per channel)
_skills/             development agents (Architect→Developer→Tester→Reviewer→Writer + Router)
_handoff/            Architect→Developer contract files (per-feature, not deployed)
```

## Two agent families (don't mix them)

- **Marketing agents** — `.claude/skills/` (`marketing-orchestrator` + channels: tiktok, reddit, …).
  Produce marketing *content*. Codex-side of the work.
- **Development agents** — `_skills/` (`AGENT_ROUTER` + BUSINESS_ANALYST / ARCHITECT / DEVELOPER /
  TESTER / CODE_REVIEWER / TECHNICAL_WRITER). Build the *software* (dashboard / command center /
  future Next+Supabase app). Claude Code-side. Start at `_skills/AGENT_ROUTER.md` (`Роут: …`).
  Adapted from the Studio dev pipeline; see [`_skills/AGENTS_CATALOG.md`](_skills/AGENTS_CATALOG.md).

## Engineering pipeline & Git workflow

Pipeline: `BUSINESS_ANALYST → ARCHITECT → DEVELOPER → TESTER → CODE_REVIEWER → [MERGE←user] →
TECHNICAL_WRITER`. Deploy: `dashboard/` → `marketing.merowingus.com` (Vercel; manual
`vercel deploy --prod` for now). `main` = main branch.

- Code features go through `feature/<slug>` → PR → review → **user-only merge**
  (`gh pr merge <N> --squash --delete-branch`). No agent commits feature code to `main` or merges PRs.
- Small doc fixes may go straight to `main`.
- This repo is also worked by **Codex** (content/model). Before dev work read the coordination journal
  (`coordination/SYNC.md` → `MERO_MARKETING_SYNC.md`); if the working tree has unstaged changes, stop
  and ask rather than overwriting Codex's work.
- **Every agent ends with a `NEXT STEP` block** (git state · Done · Next agent · «Роут: …» call · Why ·
  Блокеры) so the pipeline chains cleanly.

## Current focus (2026-06-22)

Full agent system stood up: `marketing-orchestrator` (menu) + `strategy-architect` (planner) + one
agent per channel (reddit, instagram, tiktok, youtube, x-twitter, linkedin, product-hunt, hacker-news,
discord, blog, seo) + shared `script-writer`. Active job: the **Divergentum launch** —
[`campaigns/divergentum/`](campaigns/divergentum/). Each run is an experiment ([`experiments.md`](experiments.md));
winners graduate into new agents. Start at `marketing-orchestrator`.
