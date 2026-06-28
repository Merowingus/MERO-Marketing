# Experiments → Skills (how marketing automates itself)

> The empirical engine: every channel/tactic is an **experiment** with a hypothesis and a metric.
> Run small, measure on real numbers (GA4 + UTM), then **what wins graduates into a skill/agent** so
> next time it's one command — not hand-work. What loses gets killed with a note on why.

## The loop

```
Hypothesis  →  Run (small, one tactic)  →  Measure (GA4 goal + UTM)  →  Verdict
                                                                         │
                          ┌──────────────────────────────────────────────┤
                          ▼ WIN (repeatable)            ▼ ITERATE          ▼ KILL
                Graduate into a skill/agent     tweak one variable    note why, drop
                (.claude/skills/<name>,         and re-run            (don't re-run blind)
                 product-agnostic)
```

**Graduation rule:** a tactic becomes a skill when it works **twice** (or once, decisively) and the
steps are repeatable. Generalize it (remove product specifics → params {product · ICP · channel}),
write `.claude/skills/<name>/SKILL.md`, and add it to [`agents/README.md`](agents/README.md). The
proven playbook also gets captured in studio `tools/marketing-tool.md`.

**Measure with real signals:** GA4 goals (`sign_up`, `turn_taken ≥ 5`, `purchase`) + a unique **UTM**
per experiment so you know which source actually converted. No UTM = no experiment.

## Log

| Date | Experiment | Channel | Hypothesis | Metric / result | Verdict | → Skill? |
|---|---|---|---|---|---|---|
| 2026-06-22 | Reddit DevLog ("party cancelled" story) | r/Solo_Roleplaying, r/DnD | high-intent players convert from an honest dev story | signups via UTM | running | → `community-seeder` if it wins |
| 2026-06-22 | Per-class POV clips | one video platform | the visual wow drives organic reach | views → signups via UTM | running | extend `script-writer` presets |
| 2026-06-22 | "Last 10%" blog post | merowingus.com/blog | build-in-public earns trust + SEO | traffic, time-on-page | running | refine `content-engine` angle |
| 2026-06-22 | Product Hunt + Show HN | PH / HN | one-day spike + IT/angel visibility | launch-day signups | planned | → `launch-playbook` if it wins |
| 2026-06-24 | Five-class choice gallery | r/Divergentum | a low-pressure visual question earns first community comments and reveals class interest | comments by class + stated reasons | planned | feed class hooks into `reddit` / `tiktok` |
| 2026-06-27 | TikTok first launch batch: classes, races/portraits, gameplay | TikTok | short visual proof can introduce Divergentum faster than text and reveal which hook earns attention | views, watch time, comments, profile visits, website clicks when link unlocks, signups via TikTok | running | extend `script-writer` + `tiktok` launch presets if repeatable |

> Add a row per experiment as you run it. Fill `result` + `verdict` after measuring. Winners with a
> filled "→ Skill?" become the next agents — that's how the marketing gets more automated each round.
