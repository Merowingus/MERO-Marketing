# MERO Marketing Dashboard Theme Switcher Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the local MERO Marketing dashboard light-first, visually aligned with merowingus.com, while preserving the existing dark dashboard through a theme switcher.

**Architecture:** Keep the dashboard static and dependency-free. Theme state lives on `document.documentElement.dataset.theme`, persists through `localStorage`, and swaps the logo source between `logo.png` and `logo-dark.png`. CSS uses Studio light tokens by default and overrides them in `[data-theme="dark"]`.

**Tech Stack:** HTML, CSS custom properties, vanilla JavaScript, local Node static server.

## Global Constraints

- Windows / PowerShell paths.
- No new dependencies.
- Reuse Merowingus Studio design tokens and rhythm from `E:\CODE\MEROWINGUS Studio\website`.
- Light theme is the default.
- Dark theme remains available.
- Marketing dashboard data remains in `dashboard/data.js`.

---

### Task 1: Theme shell and switcher

**Files:**
- Modify: `E:\CODE\MERO MARKETING\dashboard\index.html`

**Interfaces:**
- Consumes: `dashboard/assets/logo.png`, `dashboard/assets/logo-dark.png`.
- Produces: `data-theme-toggle`, `data-theme-label`, `brand-logo` IDs/classes for CSS and JS.

- [ ] Add `data-theme="light"` to `<html>`.
- [ ] Add a header action row inside `.hero` with a two-state theme button.
- [ ] Add inline JavaScript helpers:
  - `getInitialTheme()`
  - `setTheme(theme)`
  - click listener for the toggle
- [ ] Persist the chosen theme with `localStorage.setItem("mero-dashboard-theme", theme)`.
- [ ] Set `assets/logo.png` for light and `assets/logo-dark.png` for dark.

### Task 2: Light-first Studio CSS

**Files:**
- Modify: `E:\CODE\MERO MARKETING\dashboard\styles.css`

**Interfaces:**
- Consumes: the current dashboard class names.
- Produces: two themes through CSS variables: default light and `[data-theme="dark"]`.

- [ ] Replace root variables with Studio light tokens from `Design\tokens\colors.css`, keeping `--brand-h: 320` for MERO Marketing.
- [ ] Move current dark colors into `[data-theme="dark"]`.
- [ ] Update body, hero, cards, chart blocks, table headers, pipeline rows, and link rows to use semantic variables instead of hard-coded dark rgba values.
- [ ] Add `.topbar`, `.theme-toggle`, and light-style button states.
- [ ] Keep chart tokens readable in both themes.

### Task 3: Verification

**Files:**
- Verify: `E:\CODE\MERO MARKETING\dashboard\data.js`
- Verify: `E:\CODE\MERO MARKETING\dashboard\server.js`
- Verify: `E:\CODE\MERO MARKETING\dashboard\index.html`

**Interfaces:**
- Produces: a static dashboard that renders all dynamic sections in both themes.

- [ ] Run `node --check dashboard/data.js`.
- [ ] Run `node --check dashboard/server.js`.
- [ ] Run a Node render smoke test that evaluates `data.js` and the inline dashboard script.
- [ ] Run `git diff --check`.
- [ ] Manually inspect the final diff before committing.
