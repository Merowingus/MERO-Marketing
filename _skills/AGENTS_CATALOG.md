# Agents Catalog — MERO Marketing (development agents)

Каталог **девелопмент-агентов** MERO Marketing — для разработки самого продукта (дашборд /
command center / будущий Next+Supabase-апп). Адаптировано из дев-пайплайна Merowingus Studio.

> **Не путать с маркетинговыми агентами.** В этом проекте два разных семейства:
> - **Дев-агенты** (этот каталог, `_skills/*.md`) — строят софт: аналитика → архитектура → код →
>   тесты → ревью → доки. Вызываются через `AGENT_ROUTER` / «Роут: …».
> - **Маркетинговые агенты** (`.claude/skills/`: `tiktok`, `reddit`, `instagram`, …,
>   `marketing-orchestrator`) — производят маркетинг-контент (посты, сценарии, лонч-киты).
>
> Дев-агенты = сторона **Claude Code** в разделении труда (Codex = маркетинг-контент/модель,
> Claude Code = разработка). См. журнал `coordination/SYNC.md` → `MERO_MARKETING_SYNC.md`.

---

## 1) AGENT_ROUTER
- **Файл:** `_skills/AGENT_ROUTER.md`
- **Роль:** диспетчер — выбирает агента под запрос. Входная точка для неочевидных/смешанных задач.

## 2) BUSINESS_ANALYST
- **Файл:** `_skills/BUSINESS_ANALYST.md`
- **Роль:** оценка фич дашборда/инструмента (Impact/Effort/Risk, P0/P1/P2, MVP scope, метрики).
- **Когда:** «что делать дальше», приоритизация, прежде чем кодить.

## 3) ARCHITECT
- **Файл:** `_skills/ARCHITECT.md`
- **Роль:** проектирование до кодинга (Thinking/Opus). Выход — handoff `_handoff/DEVELOPER_INSTRUCTIONS.md`.
- **Когда:** перед средней/крупной фичей. Сверяется с архитектурой v2 (Next/Vercel/Supabase, platform base).

## 4) DEVELOPER
- **Файл:** `_skills/DEVELOPER.md`
- **Роль:** реализация по handoff (Sonnet), TDD для логики, evidence-before-assertions.
- **Когда:** handoff готов.

## 5) TESTER
- **Файл:** `_skills/TESTER.md`
- **Роль:** QA — Product Integrity Check + Feature Validation + Convention Compliance. Verdict GO/NO-GO.

## 6) CODE_REVIEWER
- **Файл:** `_skills/CODE_REVIEWER.md`
- **Роль:** финальный quality gate перед merge. Risk score, severity, verdict APPROVE/…/BLOCK.

## 7) TECHNICAL_WRITER
- **Файл:** `_skills/TECHNICAL_WRITER.md`
- **Роль:** доки + **запись в журнал координации**. Коммитит в ту же ветку до merge.

---

## Рекомендуемый workflow (Engineering pipeline)

```
BUSINESS_ANALYST → ARCHITECT → DEVELOPER → TESTER → CODE_REVIEWER → [MERGE ← пользователь] → TECHNICAL_WRITER
                                  │
                              feature/<slug> → коммиты → gh pr create → gh pr checkout → gh pr review
```

1. Идея → `BUSINESS_ANALYST` (оценка, приоритет, MVP).
2. Проектирование → `ARCHITECT` (Thinking) → handoff.
3. Код → `DEVELOPER`: `feature/<slug>` → коммиты → `gh pr create`.
4. Тест → `TESTER`: `gh pr checkout <N>` → GO/NO-GO.
5. Ревью → `CODE_REVIEWER`: `gh pr review` (сам не мержит).
6. Доки → `TECHNICAL_WRITER`: коммиты в ту же ветку + запись в журнал координации.
7. **Merge вручную пользователем:** `gh pr merge <N> --squash --delete-branch`.

Каждый агент в конце выдаёт блок **NEXT STEP** (формат — в `CLAUDE.md`, секция «Engineering pipeline & Git workflow»).

**Важно:** код-фичи не коммитятся в `main` напрямую — только через PR. Merge делает только пользователь.

---

## После code review — правило повторного тестирования
- Изменений в код не было → повторный полный цикл не нужен.
- Любые изменения в код → минимум: re-test затронутой области + smoke/regression связанных сценариев.
- Изменения в контракты/состояние/критический путь → полный `TESTER` (Product Integrity Check).

---

## Быстрые команды
- `Роут: авто` — ROUTER сам выберет агента.
- `Роут: бизнес` / `архитектор` / `разработчик` / `тестировщик` / `код-ревью` / `техписатель` — принудительно.
- `Роут: автопилот` — полный pipeline (нужен готовый `_handoff/DEVELOPER_INSTRUCTIONS.md`).
