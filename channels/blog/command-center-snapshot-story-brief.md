# Blog brief — Command Center and `snapshot.v1`

Status: parked until Phase 2 has at least one real import story.

Audience: builders, technical founders, AI product managers, indie hackers.

Working angle: a small build-in-public story about turning messy launch work into a real operating system.

## Why this is a good story

This is not just "we built a dashboard." The real story is that marketing stopped being scattered notes,
chat memory, TikTok numbers, Reddit posts, and agent output. It became a shared contract between humans
and agents.

The arc is strong:

1. Divergentum needed distribution, not another feature.
2. Reddit and TikTok created the first real campaign mess.
3. A local dashboard appeared so the work had one visible surface.
4. Claude Code turned that into a live owner-only Command Center.
5. The missing piece was trust between agents: what exactly can Codex send, and what exactly can Claude Code import?
6. `snapshot.v1` became that contract.

## Draft titles

- I Built a Marketing Dashboard, Then Realized the Dashboard Was Not the Point
- The Small JSON Contract That Made My AI Agents Work Together
- From TikTok Chaos to a Marketing Command Center
- Building a Marketing OS for a Game I Actually Want to Play
- Why My Marketing Dashboard Needed a Schema Before It Needed More Charts

## Core takeaway

The important move was not automation first. It was contract first.

Before connecting GA4, TikTok, Reddit, Instagram, or YouTube directly, we defined the shape of a trusted
marketing update:

- what campaign state changed;
- which channel it belongs to;
- which metric is real vs pending;
- what source produced it;
- what period it covers;
- what the next action is.

That made future automation safer. Manual work today becomes connector-compatible tomorrow.

## Real artifacts to cite

- Live Command Center: `https://marketing.merowingus.com`
- Architecture map: `https://marketing.merowingus.com/architecture`
- Schema: `docs/schema/snapshot.v1.schema.json`
- Example snapshot: `docs/schema/examples/divergentum-launch.snapshot.v1.json`
- Coordination journal: `C:\CODE\MEROWINGUS Studio\coordination\MERO_MARKETING_SYNC.md`
- Current live data source before Phase 2: `command-center/lib/dashboard-data.ts`

## Facts that are safe to say now

- Divergentum web 1.0 is live.
- Reddit foundation is live.
- First TikTok launch batch has 7 videos.
- Command Center is live behind owner magic-link auth.
- Architecture map is live.
- `snapshot.v1` schema exists as the first Codex ↔ Claude Code contract.
- Metrics are intentionally pending until recorded or imported.

## Do not claim yet

- Do not claim the import flow works until Phase 2 is built.
- Do not claim GA4/TikTok/Reddit APIs are connected.
- Do not claim signups, conversion rates, retention, or traffic numbers without source data.
- Do not present `snapshot.v1` as a universal Studio schema. It is MERO Marketing-specific. Other tools copy the pattern, not the schema.

## Wait for this before writing the final blog draft

Write the full post after one of these happens:

1. First real manual snapshot is imported into the live Command Center.
2. Supabase tables + RLS are live and seeded from dashboard data.
3. GA4 connector imports the first real metric.

Best version: wait until #1 happens. That gives the post a satisfying "it worked" moment without needing a full connector.

## Suggested article outline

1. Hook: I thought I was building a dashboard. I was really building trust between agents.
2. Context: Divergentum launch, Reddit, TikTok, first real marketing loop.
3. The mess: data in chats, videos, notes, dashboards, and agent handoffs.
4. Local prototype: enough to see the whole campaign.
5. Live Command Center: owner-only, magic-link, architecture map.
6. The uncomfortable question: how do two agents update one system without corrupting it?
7. The contract: `snapshot.v1`.
8. Why pending values matter: honest marketing beats fake completeness.
9. What comes next: upload/import, Supabase, GA4, then social connectors.
10. Soft CTA: follow the build or try Divergentum.

## TECHNICAL_WRITER final task

When Phase 2 has a real import moment, use this brief to write an English build-in-public blog draft for
`merowingus.com/blog`.

Required style:

- first person;
- human, direct, no AI-sounding polish;
- honest about what is built vs planned;
- include one concrete code/data artifact, preferably a small `snapshot.v1` excerpt;
- include a short repurpose plan for LinkedIn and X.

Potential primary SEO keyword:

- AI marketing dashboard

Secondary phrases:

- build in public
- AI agents workflow
- marketing command center
- JSON schema contract
- indie game marketing
