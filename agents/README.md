# MERO Marketing — Agent roster

Channel-per-agent model. Each agent is a skill in `../.claude/skills/<name>/SKILL.md`, knows its
channel's norms, and stores output in `../channels/<name>/`. Start at `marketing-orchestrator`.

## Meta-agents
| Agent | Role |
|---|---|
| **marketing-orchestrator** | The menu — shows every agent, routes to the chosen one |
| **strategy-architect** | Builds the strategy/channel-development plan; says which agent runs each step + which to build next |

## Channel agents (output → `../channels/<name>/`)
| Agent | Channel | Built |
|---|---|---|
| **reddit** | Reddit DevLog / community | ✅ |
| **instagram** | Reels + profile + DM funnel | ✅ |
| **tiktok** | POV short-form | ✅ |
| **youtube** | Shorts + demos (+ SEO titles) | ✅ |
| **x-twitter** | build-in-public threads | ✅ |
| **linkedin** | personal-brand posts (ICP A) | ✅ |
| **product-hunt** | launch-day kit | ✅ |
| **hacker-news** | Show HN | ✅ |
| **discord** | community hub / Hall of Fame | ✅ |
| **blog** | own-site posts (→ studio `blog/drafts/`) | ✅ |
| **seo** | keyword/meta/article briefs (→ MERO SEO app) | ✅ |

## Shared / content
| Agent | Role |
|---|---|
| **script-writer** | video scripts the IG/TikTok/YouTube agents reuse | ✅ |
| `content-engine` (studio) | long-form post format the blog agent uses | ✅ |

## Suggested future agents (build when a plan or experiment justifies)
- **positioning** — product → ICP, pains, USP, wow-hook (foundation the others lean on)
- **funnel-designer** — lead-magnet + freemium soft-limit funnel + copy
- **funding-outreach** — Kickstarter/Patreon/itch.io + pitch + investor angle
- **influencer-outreach** — micro-influencer barter (lifetime tier for honest review)
- **email-newsletter** — Resend sequences (welcome / re-engage)
- **pikabu** — RU community (Лига Ролевиков) — from the guerrilla strategy
- **repurposer** — one asset → all channels in one pass
- **analytics-utm** — UTM builder + GA4 readout (closes the experiment loop)

## How a new agent is born

Two paths — both end in a reusable skill:

**A. From a strategy doc** (a-priori): take a pattern from `../strategies/` → generalize (params
{product · ICP · channel}) → write `../.claude/skills/<name>/SKILL.md` → test on Divergentum first.

**B. From a winning experiment** (empirical — preferred once we have data): a tactic that *measurably
worked* (see [`../experiments.md`](../experiments.md)) graduates into a skill. This is how marketing
automates itself — each proven experiment becomes one command next time.
