---
name: marketing-orchestrator
description: MERO Marketing control panel. Use when the user types /marketing-orchestrator, says "оркестратор", "меню маркетинга", "что умеет маркетинг", asks which marketing agent to use, or isn't sure where to start. Shows a numbered menu of every marketing agent and routes to the chosen one.
---

# MERO Marketing — Orchestrator

The entry menu for the marketing machine. Show the roster, the user picks a number, then **hand off to
that agent immediately**. Plans get built by `strategy-architect`; channel assets by the channel agents.

## Method

1. Show the menu (below).
2. User picks a number (or names a channel/task).
3. Invoke that skill and continue there. If unsure what they need, ask one question, then route.

## The menu

**🧭 Plan & strategy**
1. `strategy-architect` — build/adjust the strategy & channel-development plan (what to do, in what order, which agent next)
2. `positioning` — product → ICP, pains, USP, wow-hook *(planned)*

**📣 Channel agents** (each stores output in `channels/<name>/`)
3. `reddit` — community DevLog posts (r/Solo_Roleplaying, r/DnD…)
4. `instagram` — Reels + profile + DM lead-magnet funnel
5. `tiktok` — POV short-form clips
6. `youtube` — Shorts + demo videos
7. `x-twitter` — build-in-public threads
8. `linkedin` — personal-brand build-in-public posts
9. `product-hunt` — launch-day kit (title, first comment, assets)
10. `hacker-news` — Show HN post
11. `discord` — community hub / Hall of Fame setup
12. `blog` — own-site build-in-public posts (output → studio `blog/drafts/`)
13. `seo` — keyword/meta/article briefs (feed MERO SEO)

**🛠️ Shared / content**
14. `script-writer` — video scripts the channel agents reuse
15. `content-engine` (studio) — long-form posts

**🧪 Loop**
- Every run is an experiment → log it in [`../../../experiments.md`](../../../experiments.md). Winners graduate into new agents.

## Suggested future agents (propose when relevant)
- `funnel-designer` (lead-magnet + freemium funnel) · `funding-outreach` (Kickstarter/Patreon/itch.io + pitch)
- `influencer-outreach` (micro-influencer barter) · `email-newsletter` (Resend) · `pikabu` (RU audience)
- `repurposer` (one asset → all channels) · `analytics-utm` (UTM builder + GA4 readout)

## Rules
- Route fast — don't do the agent's job inside the menu.
- One wheel at a time: if the user wants "everything", send them to `strategy-architect` to sequence it.
