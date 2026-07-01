# MERO Marketing Dashboard brainstorm checkpoint

**Status:** Queued for the next working session. No implementation has started.

## Why this exists

MERO Marketing needs one command center that shows:

- what is planned;
- what is currently being produced;
- what has been published;
- which experiments are running;
- what results each channel and asset produced;
- website visits, registrations, activation, return, and purchase metrics where available.

The dashboard should become the online face of the internal MERO Marketing system, not another
separate spreadsheet that drifts away from the agents and campaign files.

## Existing home

The Merowingus Studio website already has a `MERO Marketing` card in:

`E:\CODE\MEROWINGUS Studio\website\tools.html`

It is currently marked `Soon`. The dashboard can eventually live behind this section while the
public marketing page remains part of the Studio website.

## Ground truth already available

MERO Marketing currently stores useful structured facts in:

- `ROADMAP.md` for Now / Next / Later;
- `campaigns/<product>/` for campaign plans and assets;
- `channels/<channel>/` for prepared content;
- `experiments.md` for hypotheses, metrics, and verdicts;
- product analytics in GA4;
- product telemetry and user data in Divergentum's existing backend where appropriate.

## Design questions for the brainstorm

1. **Source of truth:** Should plans and statuses remain Markdown/Git-first, move into a database, or
   use a hybrid model?
2. **MVP audience:** Is the first dashboard private/self-only, public read-only, or split into an
   internal control panel and a public showcase?
3. **Analytics:** Which numbers must be live in v1: visits, UTM source, `sign_up`, first session,
   D7 return, purchase, content views, or all of them?
4. **Updates:** Should agents write status directly into dashboard data, or should the dashboard
   derive state from existing files and analytics?
5. **Hosting:** Should the first version be generated into the current static Studio website, or
   should the MERO Marketing section become a small authenticated web app?

## Preliminary architecture options to compare

### A. Git-first generated dashboard

Read Markdown campaign files and generate a static dashboard during deployment. Simple and cheap,
but live analytics require a separate snapshot job.

### B. Database-first control panel

Store campaigns, tasks, assets, experiments, and metrics in a database. Best for live updates, but
duplicates the current file-based workflow and creates migration work immediately.

### C. Hybrid command center

Keep plans and content in Git as the durable source. Add a small database/API layer only for live
analytics, publication records, and status changes that need interaction. The dashboard combines
both.

**Current recommendation to examine first:** Option C. It preserves the agent workflow already in
use and adds a live layer only where files are weak.

## Resume here

After the TikTok design checkpoint, begin a separate brainstorming flow for the dashboard.

First question:

**Who must be able to see the MVP dashboard?**

1. Mykola only, behind authentication.
2. Mykola gets the full dashboard; visitors see a public read-only progress page.
3. Everything is public from the start.

Do not implement until the dashboard design is approved and written as a dedicated spec.
