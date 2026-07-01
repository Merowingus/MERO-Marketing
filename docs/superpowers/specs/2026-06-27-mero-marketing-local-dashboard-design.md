# MERO Marketing local dashboard design

## Goal

Build a local HTML dashboard for the Divergentum launch so Mykola can see the marketing picture,
current plan, running experiments, TikTok launch batch, and GA4 setup needs in one place.

This is an MVP command center, not a public product page. It should be useful today and easy to move
into the Merowingus Studio website later.

## Location

Create the dashboard in:

`E:\CODE\MERO MARKETING\dashboard\`

Files:

- `index.html` — static dashboard shell and markup.
- `styles.css` — local dashboard styles using Merowingus Studio tokens.
- `data.js` — editable manual data source for metrics, channel states, actions, and links.
- `assets/logo.png` — copied Merowingus Studio logo for local portability.

## Design system requirements

Use the Merowingus Studio visual system from:

`E:\CODE\MEROWINGUS Studio\website\Design\`

Relevant source decisions:

- Shared Studio design tokens:
  - `tokens/colors.css`
  - `tokens/typography.css`
  - `tokens/spacing.css`
  - `tokens/charts.css`
- MERO Marketing service theme:
  - `ui_kits/mero-marketing.theme.css`
  - `--brand-h: 320`
- Internal-service feel:
  - closer to the Planner app shell than the public landing pages;
  - dark board, panel cards, compact status badges, practical tables.
- Brand asset:
  - use `E:\CODE\MEROWINGUS Studio\website\assets\logo.png`.

The local MVP should not depend on loading files from `E:\CODE\MEROWINGUS Studio` at runtime. Copy
only the required logo into the dashboard and reproduce the small set of token variables needed for
the standalone HTML.

## Content model

`data.js` will expose one `dashboardData` object with:

- campaign summary;
- KPI cards;
- channels;
- experiments;
- TikTok launch videos;
- next actions;
- UTM links;
- GA4 setup checklist.

The first version uses manual data entry, because GA4 API authentication is unnecessary overhead for
the local dashboard. A later Studio implementation can replace `data.js` with a generated JSON file,
database, or analytics API.

## Page sections

1. **Header**
   - Merowingus Studio logo.
   - Title: `MERO Marketing Command Center`.
   - Product context: `Divergentum launch`.
   - Last updated date.

2. **Focus strip**
   - Current focus: Reddit foundation live, TikTok first batch uploaded, 24–72h observation window,
     dashboard MVP next.
   - Small status pills for `Live`, `Running`, `Next`, `Parked`.

3. **KPI cards**
   - TikTok videos uploaded.
   - Running experiments.
   - Active channels.
   - Website link status.
   - GA4 setup status.

4. **Channel board**
   - Reddit, TikTok, Blog, Discord, Product Hunt / HN, SEO.
   - Each card shows status, role, next step, and primary metric.

5. **TikTok launch batch**
   - Seven uploaded videos.
   - Manual 24h / 48h / 72h fields for views, likes, comments, profile visits, website clicks, signups.
   - Notes column for qualitative learnings.

6. **Experiment table**
   - Mirror the active rows from `experiments.md`.
   - Show hypothesis, metric, verdict, and possible skill/agent evolution.

7. **Next actions**
   - Short operational list for the next 24–72h.
   - Separate “do not do yet” list to protect focus.

8. **GA4 setup**
   - Checklist for events, key events, UTM discipline, and DebugView checks.
   - Manual link to the recommended profile UTM URL.

## GA4 and measurement design

Recommended events:

- `sign_up`
- `login`
- `purchase`
- `turn_taken`
- `session_5_turns`
- `campaign_started`
- `character_created`

Recommended key events:

- `sign_up`
- `session_5_turns`
- `purchase`

UTM convention:

- `utm_source=tiktok|reddit|blog|discord`
- `utm_medium=social|community|owned`
- `utm_campaign=divergentum_launch_june_2026`
- `utm_content=<video_or_post_name>`

The dashboard should show setup status and manual metrics now. Live GA4 integration is explicitly
out of scope for the local MVP.

## Non-goals

- No authentication.
- No database.
- No GA4 API integration in v1.
- No public hosting in v1.
- No editing UI beyond changing `data.js`.
- No paid ads reporting yet.

## Acceptance criteria

- Opening `dashboard/index.html` in a browser shows a polished Merowingus Studio styled dashboard.
- The logo is visible in the header.
- The dashboard works offline as local files.
- All visible metrics are either real current facts from project files or clearly marked as pending/manual.
- TikTok launch state reflects that seven videos were uploaded on 2026-06-27.
- The next action list protects the current focus: measure TikTok, keep Reddit warm, then dashboard/analytics.
- Data can be updated by editing `dashboard/data.js` without touching layout or styles.
