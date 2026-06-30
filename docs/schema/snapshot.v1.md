# snapshot.v1 — MERO Marketing Upload Contract

**Schema ID:** `https://marketing.merowingus.com/schema/snapshot.v1.schema.json`
**Draft:** JSON Schema 2020-12
**Status:** Active — Phase 2 import contract

---

## What this is

A `snapshot.v1` document is a **versioned, self-describing JSON payload** that captures the complete marketing state of one product at one point in time: campaign focus, channel statuses, running experiments, uploaded assets, and quantitative metrics.

It is the **handshake between the marketing content side (Codex) and the engineering side (Claude Code / Command Center)**. Codex writes snapshots; Claude Code validates and imports them into Supabase; the Command Center reads from Supabase and renders the live dashboard.

One snapshot = one product × one campaign × one point in time.

---

## Roles

| Role | Tool | Responsibility |
|---|---|---|
| **Producer** | Codex | Writes the JSON, signs with `producer` field |
| **Validator** | Claude Code (Phase 2 import route) | Validates against schema before touching DB |
| **Consumer** | Command Center / Supabase | Reads stored data, renders dashboard |

The schema enforces the contract so neither side has to trust the other blindly.

---

## Top-level structure

```
snapshot.v1
├── schemaVersion       const — "mero.marketing.snapshot.v1"
├── generatedAt         ISO 8601 date-time (UTC)
├── tenantId            id — who owns this data
├── productId           id — which product
├── campaignId          id — which campaign
├── producer            object — who/what generated this file
├── summary             object — one-line campaign state
├── focus[]             strip of 3–6 focus items (what's live/next/parked)
├── kpis[]              headline numbers for the dashboard header
├── channels[]          per-channel status + next action
├── experiments[]       running/closed experiments with verdict
├── assets[]            content assets (videos, posts, pages)
├── metrics[]           quantitative measurements with source + dedupeKey
├── nextActions[]       ordered list of next steps
└── notes               optional free-text producer note
```

All objects use `additionalProperties: false`. Unknown fields are rejected.

---

## Field reference

### Root identity

| Field | Type | Required | Notes |
|---|---|---|---|
| `schemaVersion` | `const` | ✅ | Always `"mero.marketing.snapshot.v1"`. Fail fast if wrong. |
| `generatedAt` | `date-time` | ✅ | When the file was produced. UTC. |
| `tenantId` | id | ✅ | Slug of the studio tenant, e.g. `merowingus`. |
| `productId` | id | ✅ | Slug of the product, e.g. `divergentum`. |
| `campaignId` | id | ✅ | Slug of the campaign, e.g. `divergentum_launch_june_2026`. |

### `producer` (optional but strongly recommended)

Who generated this file. Used for audit and debugging.

```json
"producer": {
  "name": "Codex",
  "tool": "codex",
  "notes": "Optional free text about this run."
}
```

`tool` enum: `codex` | `claude_code` | `manual` | `connector` | `script`

### `summary`

Campaign-level state in one object. Powers the Command Center header.

| Field | Type | Required |
|---|---|---|
| `title` | string | ✅ |
| `status` | enum | ✅ |
| `lastUpdated` | date | ✅ |
| `currentFocus` | string | ✅ |
| `subtitle` | string | — |
| `statusLabel` | string | — |
| `owner` | string | — |
| `website` | uri | — |
| `profileUtm` | uri | — |

`status` enum: `launch_in_progress` | `running` | `paused` | `complete` | `parked`

---

## Array items

### `focus[]` — focus strip

3–6 items shown as a strip on the dashboard. Each item has a label, a one-word value, and a tone.

```json
{ "id": "tiktok_batch", "label": "TikTok batch", "value": "Running", "tone": "running" }
```

All four fields are required. `tone` uses the shared tone enum (see below).

### `kpis[]` — headline numbers

Headline metrics for the dashboard top section. `value` accepts either a number or a string (use a string for "Pending", "Basic", etc.).

```json
{ "id": "tiktok_videos_uploaded", "label": "TikTok videos uploaded", "value": 7, "detail": "classes, races, gameplay", "tone": "live" }
```

All five fields required.

### `channels[]` — channel status

One entry per channel. `status` and `tone` may differ: a channel can have `status: "done"` with `tone: "done"`, which is not possible for all other item types.

| Field | Type | Required |
|---|---|---|
| `id` | id | ✅ |
| `name` | string | ✅ |
| `role` | string | ✅ |
| `status` | enum | ✅ |
| `tone` | tone | ✅ |
| `next` | string | ✅ |
| `metric` | string | ✅ |
| `notes` | string | — |

`status` enum: `live` | `running` | `next` | `watch` | `parked` | `done`

### `experiments[]` — experiment log

Each experiment has a hypothesis, a metric to watch, and a verdict. A parked experiment keeps `verdict: "parked"` to signal intentional pause.

| Field | Type | Required |
|---|---|---|
| `id` | id | ✅ |
| `name` | string | ✅ |
| `channelId` | id | ✅ |
| `status` | enum | ✅ |
| `hypothesis` | string | ✅ |
| `metric` | string | ✅ |
| `verdict` | enum | ✅ |
| `startedAt` | date | — |
| `endedAt` | date | — |
| `notes` | string | — |

`status` enum: `planned` | `running` | `done` | `parked`

`verdict` enum: `pending` | `keep` | `iterate` | `stop` | `parked` | `win` | `loss`

### `assets[]` — content assets

Tracks every piece of content: TikTok videos, Reddit posts, blog posts, pages.

| Field | Type | Required |
|---|---|---|
| `id` | id | ✅ |
| `type` | enum | ✅ |
| `title` | string | ✅ |
| `status` | enum | ✅ |
| `channelId` | id | — |
| `experimentId` | id | — |
| `url` | uri | — |
| `publishedAt` | date-time | — |
| `tags` | string[] | — |
| `notes` | string | — |
| `utmContent` | string | — |

`type` enum: `video` | `image` | `post` | `blog_post` | `reddit_post` | `tiktok_video` | `page` | `other`

`status` enum: `planned` | `draft` | `uploaded` | `published` | `archived`

`utmContent` — the `utm_content` slug for this asset. When GA4 connectors arrive (Phase 3), the import pipeline uses this field to match GA4 traffic rows to the asset that drove them. Set it now if known; leave absent otherwise.

### `metrics[]` — quantitative measurements

The most structured object in the schema. Every real number in the system goes here with full traceability.

| Field | Type | Required |
|---|---|---|
| `id` | id | ✅ |
| `scope` | enum | ✅ |
| `metricKey` | id | ✅ |
| `valueStatus` | enum | ✅ |
| `confidence` | enum | ✅ |
| `dedupeKey` | string | ✅ |
| `period` | object | ✅ |
| `source` | object | ✅ |
| `channelId` | id | conditional |
| `assetId` | id | conditional |
| `experimentId` | id | conditional |
| `value` | number | conditional |
| `unit` | string | — |
| `notes` | string | — |

#### `scope`

`campaign` | `channel` | `asset` | `experiment` | `product`

**Conditional FK rule (enforced by schema):**

| scope | required field |
|---|---|
| `channel` | `channelId` |
| `asset` | `assetId` |
| `experiment` | `experimentId` |
| `campaign` / `product` | no extra FK |

#### `valueStatus` vs `confidence` — two different dimensions

These are not the same thing. Always set both.

| Field | Answers | Values |
|---|---|---|
| `valueStatus` | Does a numeric value exist yet? | `actual` · `pending` · `not_available` |
| `confidence` | How trustworthy is the number? | `estimated` · `reported` · `verified` |

- `actual` + `reported` — you read it off the TikTok dashboard
- `actual` + `verified` — you confirmed it via two sources (e.g. TikTok + GA4)
- `actual` + `estimated` — you extrapolated or guessed
- `pending` + `estimated` — metric not recorded yet; confidence reflects your expectation about quality when it is recorded
- `not_available` — the platform doesn't expose this metric at all

**When `valueStatus === "actual"`, `value` (number) becomes required.** This is enforced by the schema via `allOf/if/then`.

#### `dedupeKey`

Format: `{tenantId}:{source.type}:{productId}:{scope}:{channelId|null}:{assetId|null}:{metricKey}:{period.from}`

Example: `merowingus:manual:divergentum:channel:tiktok:null:videos_uploaded:2026-06-27`

The import pipeline uses this key for idempotent upsert (`INSERT … ON CONFLICT (dedupe_key) DO UPDATE`). Re-uploading the same snapshot never creates duplicates. The producer **must** construct and include this key; the importer does not synthesize it.

Rules for the key:
- Use `null` literally (string) when a component is absent.
- `source.type` must match the `source.type` field of the same metric object.
- `period.from` is the start date of the measurement window in `YYYY-MM-DD` format.

#### `source` object

```json
"source": {
  "type": "manual",
  "label": "TikTok studio dashboard, manually checked",
  "capturedAt": "2026-06-29T18:00:00Z",
  "url": "https://..."
}
```

`type` enum: `manual` | `ga4` | `tiktok` | `reddit` | `instagram` | `youtube` | `divergentum_backend` | `system`

### `nextActions[]` — next steps

Ordered list of actions. Synced with `ROADMAP.md → Now` section.

| Field | Type | Required |
|---|---|---|
| `id` | id | ✅ |
| `label` | string | ✅ |
| `status` | enum | ✅ |
| `detail` | string | ✅ |
| `owner` | string | — |
| `dueDate` | date | — |
| `origin` | string | — |

`status` enum: `next` | `running` | `watch` | `done` | `blocked` | `parked`

`origin` — a label saying where this action came from: `"roadmap"`, `"experiment/tiktok_first_launch_batch"`, `"connector/ga4"`. Not a foreign key; just a breadcrumb.

---

## Shared primitives

### `id` pattern

All ID fields match `^[a-z0-9][a-z0-9_-]*$`. Lowercase, no spaces, no uppercase. Hyphens and underscores allowed after the first character.

### `tone` enum

`live` | `running` | `next` | `watch` | `parked` | `done`

Used by: `focusItem`, `kpi`, `channel`, and the `tone` field on any item that appears on the dashboard. Drives visual color coding (live = green, running = brand pink, next = gold, watch = orange, parked / done = neutral grey).

### `period` object

```json
{ "from": "2026-06-27", "to": "2026-06-29" }
```

Both dates are `YYYY-MM-DD`. `from` ≤ `to`. For a single-day snapshot, `from === to`.

---

## Writing a valid snapshot (guide for Codex)

1. **Copy** `docs/schema/examples/divergentum-launch.snapshot.v1.json` as starting point.
2. **Set identity fields** (`tenantId`, `productId`, `campaignId`, `generatedAt`).
3. **Fill `summary`** — `currentFocus` should be one sentence, plain language.
4. **For every metric:**
   - Set `valueStatus: "actual"` only when you have a real number. Use `"pending"` otherwise — never invent a number.
   - Always set `confidence` — `estimated` is valid, just honest.
   - Construct `dedupeKey` following the format above. Double-check `source.type` matches.
5. **Zero fabrication rule:** if you don't have a number, `valueStatus: "pending"` is correct and expected. Do not set `value: 0` to satisfy the schema when the real value is unknown.
6. **Validate** before submitting. Use `ajv` or any JSON Schema 2020-12 validator with `strict: true`.

---

## Importing a snapshot (guide for Claude Code / Phase 2)

The import route (`POST /api/import/snapshot`) will:

1. Parse the JSON body.
2. Validate against `snapshot.v1.schema.json` — reject with 422 if invalid.
3. Upsert root identity into `campaigns` (by `tenantId + productId + campaignId`).
4. For each `channel`, upsert into `channels`.
5. For each `experiment`, upsert into `experiments`.
6. For each `asset`, upsert into `assets`.
7. For each `metric`, upsert into `metrics` using `dedupeKey` as the conflict key.
8. Update `snapshots` log table with `generatedAt` + `producer`.

Multi-tenant safety: all rows carry `tenant_id` at insert time. RLS policies at Supabase level prevent cross-tenant reads.

---

## What this schema does NOT cover

- **Connector-native raw data** (GA4 event rows, TikTok video-level analytics) — those feed the metrics after connector ETL (Phase 3), not directly as snapshot fields.
- **User / auth state** — handled by Supabase Auth, not the snapshot.
- **Media files** — assets carry metadata only; actual files live on TikTok / Reddit / the blog CDN.
- **Historical rollups** — the snapshot is a point-in-time state, not a timeseries. Timeseries is built in the DB by accumulating snapshots over time.

---

## Files

| File | Purpose |
|---|---|
| [`docs/schema/snapshot.v1.schema.json`](snapshot.v1.schema.json) | The canonical JSON Schema (source of truth) |
| [`docs/schema/examples/divergentum-launch.snapshot.v1.json`](examples/divergentum-launch.snapshot.v1.json) | Valid example instance (Divergentum launch, June 2026) |
| [`docs/schema/snapshot.v1.md`](snapshot.v1.md) | This document |

---

## Changelog

| Version | Date | Change |
|---|---|---|
| v1.0 | 2026-06-29 | Initial schema — Codex |
| v1.1 | 2026-06-30 | Added `confidence` + `dedupeKey` to metric (required); scope FK cross-validation; `tone` enum += `"done"`; `asset.utmContent`; renamed `nextAction.source` → `origin` — Claude Code |
