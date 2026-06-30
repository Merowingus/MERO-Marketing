# Snapshot v1 Schema Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create the first shared MERO Marketing snapshot contract so Codex can produce validated campaign updates and Claude Code can safely consume them in Phase 2.

**Architecture:** Store the versioned JSON Schema and examples under `docs/schema/` as the canonical contract source. The schema is product-specific to MERO Marketing, not a universal Studio schema, but the pattern can be copied by future tools. Keep v1 focused on campaign state, focus strip, KPIs, channels, experiments, assets, metrics, and next actions.

**Tech Stack:** JSON Schema Draft 2020-12, JSON examples, Markdown docs.

## Global Constraints

- Zero fabrication: schema examples may contain pending values, but no fake performance numbers.
- Contract name: `mero.marketing.snapshot.v1`.
- Producer: Codex / manual marketing workflow.
- Consumer: Claude Code / future upload/import endpoint.
- Reject unknown fields through `additionalProperties: false`.
- Every metric must have a period and source.
- Every record that can be upserted must have a stable `id`.

---

### Task 1: Create schema files

**Files:**
- Create: `C:\CODE\MERO MARKETING\docs\schema\snapshot.v1.schema.json`
- Create: `C:\CODE\MERO MARKETING\docs\schema\examples\divergentum-launch.snapshot.v1.json`

**Interfaces:**
- Produces: a schema with top-level fields `schemaVersion`, `generatedAt`, `tenantId`, `productId`, `campaignId`, `summary`, `focus`, `kpis`, `channels`, `experiments`, `assets`, `metrics`, `nextActions`.
- Produces: a valid example snapshot with no fabricated metrics.

- [ ] Define reusable `$defs` for `tone`, `status`, `period`, `source`, and `id`.
- [ ] Define required arrays for channels, experiments, assets, metrics, and next actions.
- [ ] Allow explicit pending metric values with `valueStatus: "pending"` instead of fake numbers.
- [ ] Create the Divergentum example snapshot from current dashboard state.

### Task 2: Document how to use the contract

**Files:**
- Create: `C:\CODE\MERO MARKETING\docs\schema\README.md`
- Modify: `C:\CODE\MERO MARKETING\docs\architecture\mero-marketing-command-center-online-architecture.md`

**Interfaces:**
- Produces: a human-readable contract guide for Codex and Claude Code.
- Links architecture section 6 to the schema files.

- [ ] Explain producer/consumer roles.
- [ ] Explain reject vs warn behavior.
- [ ] Link the schema and example snapshot from the architecture doc.

### Task 3: Verify and commit

**Files:**
- Verify all new JSON files.

**Interfaces:**
- Produces: parseable JSON files and clean git diff.

- [ ] Parse `snapshot.v1.schema.json` with Node.
- [ ] Parse `divergentum-launch.snapshot.v1.json` with Node.
- [ ] Run a minimal schema consistency smoke test for required top-level fields.
- [ ] Run `git diff --check`.
- [ ] Commit with `docs: add snapshot v1 schema`.
