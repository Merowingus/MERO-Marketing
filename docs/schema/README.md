# MERO Marketing schema contracts

This folder is the contract layer between the marketing producer and the Command Center importer.

- Producer: Codex, a manual marketing workflow, scripts, or future connectors.
- Consumer: Claude Code / `command-center` upload pipeline / future Supabase import jobs.
- Current contract: [`snapshot.v1.schema.json`](snapshot.v1.schema.json).
- Example: [`examples/divergentum-launch.snapshot.v1.json`](examples/divergentum-launch.snapshot.v1.json).

## What `snapshot.v1` is

`mero.marketing.snapshot.v1` is a full campaign state update. It can describe:

- campaign summary and current focus;
- focus strip and KPI cards;
- channels and their next steps;
- experiments and verdicts;
- assets such as TikToks, Reddit posts, blog posts, or pages;
- metrics with a required period and source;
- next actions.

It is intentionally not a universal Studio schema. MERO SEO and MERO Product may copy the pattern, but
they should create their own domain schemas.

## Validation rules

Reject the upload when:

- `schemaVersion` is missing or not `mero.marketing.snapshot.v1`;
- `tenantId`, `productId`, or `campaignId` is unknown;
- a channel/asset/experiment/metric has no stable `id`;
- a metric has no `period`;
- a metric has no `source`;
- a metric has `valueStatus: "actual"` but no numeric `value`;
- unknown fields are present;
- duplicate IDs appear within the same collection.

Warn but accept when:

- optional notes are missing;
- social performance metrics are still pending;
- a channel is parked;
- a metric uses `valueStatus: "pending"` or `valueStatus: "not_available"`;
- a URL is missing for an uploaded asset that has not been copied into the dashboard yet.

## How Codex should produce a snapshot

1. Use real campaign state only. Do not invent metrics.
2. Use `valueStatus: "pending"` for metrics that are expected but not recorded yet.
3. Keep IDs stable between snapshots. Example: `tiktok_wizard` should not become `wizard_video_1`.
4. Include `source` on every metric, even if the source is manual.
5. Keep `summary.lastUpdated` aligned with the marketing state being reported.

## How Claude Code should consume a snapshot

1. Validate JSON against `snapshot.v1.schema.json`.
2. Check IDs against the tenant/product/channel registry.
3. Reject unknown fields and malformed records.
4. Upsert rows by stable IDs and metric period/source dedupe keys.
5. Store the original uploaded file for audit and rollback.
6. Show a human-readable validation report before applying destructive changes.

## Minimal valid shape

```json
{
  "schemaVersion": "mero.marketing.snapshot.v1",
  "generatedAt": "2026-06-29T16:00:00Z",
  "tenantId": "merowingus",
  "productId": "divergentum",
  "campaignId": "divergentum_launch_june_2026",
  "summary": {
    "title": "MERO Marketing Command Center",
    "status": "launch_in_progress",
    "lastUpdated": "2026-06-27",
    "currentFocus": "Capture first TikTok metrics and keep Reddit warm."
  },
  "focus": [],
  "kpis": [],
  "channels": [],
  "experiments": [],
  "assets": [],
  "metrics": [],
  "nextActions": []
}
```
