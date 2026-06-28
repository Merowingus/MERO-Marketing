# MERO Marketing Local Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a local HTML command center for the Divergentum marketing launch.

**Architecture:** A standalone static dashboard reads manual launch data from `dashboard/data.js` and renders it in `dashboard/index.html`. Styling lives in `dashboard/styles.css` and recreates the needed Merowingus Studio tokens, including the MERO Marketing hue.

**Tech Stack:** Static HTML, CSS custom properties, vanilla JavaScript, local image asset.

## Global Constraints

- Dashboard location: `C:\CODE\MERO MARKETING\dashboard\`.
- Use Merowingus Studio design tokens and MERO Marketing theme (`--brand-h: 320`).
- Include the Merowingus Studio logo copied from `C:\CODE\MEROWINGUS Studio\website\assets\logo.png`.
- Work offline as local files.
- Keep data editable in `dashboard/data.js`.
- Do not add auth, database, GA4 API integration, public hosting, or paid ads reporting in v1.
- Mark pending metrics clearly as manual or pending.

---

### Task 1: Create dashboard data source

**Files:**
- Create: `C:\CODE\MERO MARKETING\dashboard\data.js`

**Interfaces:**
- Produces: `window.dashboardData: object` with campaign, kpis, channels, tiktokVideos, experiments, actions, ga4, and links.
- Consumes: current marketing facts from `ROADMAP.md`, `experiments.md`, and `channels/tiktok/divergentum-tiktok-launch-log-2026-06-27.md`.

- [ ] **Step 1: Create `window.dashboardData`**

Create a data object with current launch facts, pending manual metrics, channel states, GA4 checklist, and UTM links.

- [ ] **Step 2: Verify JavaScript syntax**

Run: `node --check dashboard/data.js`

Expected: no syntax errors.

### Task 2: Create dashboard HTML shell

**Files:**
- Create: `C:\CODE\MERO MARKETING\dashboard\index.html`

**Interfaces:**
- Consumes: `window.dashboardData` from `dashboard/data.js`.
- Produces: semantic sections with `data-render` containers for cards, tables, channel board, and checklists.

- [ ] **Step 1: Create HTML skeleton**

Include local stylesheet, logo, header, focus strip, KPI section, channel board, TikTok table, experiment table, next actions, GA4 checklist, and UTM links.

- [ ] **Step 2: Add render script**

Use vanilla JavaScript functions to render arrays from `window.dashboardData`.

- [ ] **Step 3: Verify HTML file exists and references `data.js` and `styles.css`**

Run: `Select-String -Path dashboard/index.html -Pattern 'data.js|styles.css|logo.png'`

Expected: all three references found.

### Task 3: Create dashboard styles

**Files:**
- Create: `C:\CODE\MERO MARKETING\dashboard\styles.css`

**Interfaces:**
- Consumes: class names from `dashboard/index.html`.
- Produces: standalone Merowingus Studio styled dark internal dashboard using CSS variables.

- [ ] **Step 1: Add local token subset**

Reproduce the required Studio token variables, set `--brand-h: 320`, and use dark theme values by default.

- [ ] **Step 2: Style layout and components**

Implement app shell, header, cards, badges, channel grid, tables, progress bars, checklists, and responsive behavior.

- [ ] **Step 3: Verify CSS references token variables**

Run: `Select-String -Path dashboard/styles.css -Pattern '--brand-h|--accent|--chart-1|--highlight'`

Expected: all token names found.

### Task 4: Copy logo asset and verify dashboard

**Files:**
- Create: `C:\CODE\MERO MARKETING\dashboard\assets\logo.png`

**Interfaces:**
- Consumes: `C:\CODE\MEROWINGUS Studio\website\assets\logo.png`.
- Produces: portable local dashboard logo asset.

- [ ] **Step 1: Copy logo**

Copy `C:\CODE\MEROWINGUS Studio\website\assets\logo.png` to `C:\CODE\MERO MARKETING\dashboard\assets\logo.png`.

- [ ] **Step 2: Verify files**

Run: `Get-ChildItem dashboard -Recurse`

Expected: `index.html`, `styles.css`, `data.js`, and `assets/logo.png` exist.

- [ ] **Step 3: Verify no pending placeholders in dashboard files**

Run: `Select-String -Path dashboard\*.html,dashboard\*.css,dashboard\*.js -Pattern 'TODO|TBD|placeholder' -CaseSensitive:$false`

Expected: no output.
