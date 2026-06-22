# MERO Marketing — Agent roster

Reusable, product-agnostic marketing agents. Each is a skill in `../.claude/skills/<name>/SKILL.md`,
runs on the Claude model, and is parametrized by {product · ICP · channel}. Fuel = [`../strategies/`](../strategies/).

## Agents (think + produce)

| Agent | Skill | Does | From strategy | Status |
|---|---|---|---|---|
| **Script Writer** | `script-writer` | Reels/Shorts/TikTok scripts (POV/demo) | instagram-2h, guerrilla | ✅ Built |
| **Positioning Distiller** | `positioning` | product → ICP, pains, USP, wow-hook | guerrilla | Planned (next, foundation) |
| **Community Seeder** | `community-seeder` | DevLog/seed posts per platform (Reddit/Discord/forums) | guerrilla | Planned |
| **Launch-Day Playbook** | `launch-playbook` | Product Hunt / HN / Reddit launch kit | guerrilla, funding | Planned |
| **SEO Brief Writer** | `seo-brief` | keywords → meta + article ToR (feeds MERO SEO) | seo | Later |
| **Funnel Designer** | `funnel` | lead-magnet + freemium funnel + copy | instagram-2h, seo | Later |
| **Funding & Outreach** | `funding-outreach` | funding-source match + pitch + influencer DMs | funding | Later |

## Micro-tools (small utilities, build when needed)

- Meta-tag generator (title ≤60, desc ≤155) · UTM/link builder · Posting calendar
- KPI definer (activation / signup→paid / churn / SERP) — ties to the Lean loop
- 14-day launch template (the studio Planner instantiates it per product)

## How a new agent is born

1. Take a pattern from a real strategy in `../strategies/`.
2. Generalize it (remove product specifics → params).
3. Write `../.claude/skills/<name>/SKILL.md` (inputs → method → output → rules), zero-fabrication.
4. Test it on Divergentum first (the first case study), then it's reusable for the next product.
