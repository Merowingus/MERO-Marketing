# AGENT_ROUTER — MERO Marketing (development)

Роль: диспетчер дев-задач для Claude Code в проекте MERO Marketing.

Цель: по запросу выбрать правильного дев-агента и вернуть результат в нужном формате.

> Маршрутизирует только **дев-агентов** (разработка софта). Запросы про маркетинг-контент
> (посты, сценарии, лонч) — это `.claude/skills/` (`marketing-orchestrator` и каналы), не сюда.

---

## Доступные агенты
1. `BUSINESS_ANALYST` → `_skills/BUSINESS_ANALYST.md`
2. `ARCHITECT` → `_skills/ARCHITECT.md`
3. `DEVELOPER` → `_skills/DEVELOPER.md`
4. `TESTER` → `_skills/TESTER.md`
5. `CODE_REVIEWER` → `_skills/CODE_REVIEWER.md`
6. `TECHNICAL_WRITER` → `_skills/TECHNICAL_WRITER.md`

## Superpowers внутри агентов
- **ARCHITECT** — `systematic-debugging` (если баг), `writing-plans` (крупные фичи).
- **DEVELOPER** — TDD (RED→GREEN→REFACTOR) + `verification-before-completion` + `systematic-debugging`.
- **TESTER** — `verification-before-completion` (+ анти-паттерны тестов).
- **CODE_REVIEWER** — `receiving-code-review` как стандарт обмена фидбеком.

Роутер сам Superpowers не вызывает — это делают агенты внутри своего flow.

---

## Перед началом — ориентация + координация (правило проекта)
1. **HTML-карта архитектуры** — `docs/architecture/mero-marketing-architecture-map.html`.
   Читать первой: стек, фазы, MUST/MUST NOT, файловая карта — всё в одном месте.
   Полная spec: `docs/architecture/mero-marketing-command-center-online-architecture.md` (v2).
2. **Журнал координации** — `coordination/SYNC.md` → canonical
   `C:\CODE\MEROWINGUS Studio\coordination\MERO_MARKETING_SYNC.md` (Current state + последние записи),
   чтобы не конфликтовать с Codex. После работы — TECHNICAL_WRITER пишет запись.

---

## Правила маршрутизации

### Route A — Business / Product → `BUSINESS_ANALYST`
оценить фичу · приоритеты · сравнить варианты · impact/effort/risk · MVP scope + метрики.
Триггеры: `фича`, `приоритет`, `оценка`, `roadmap`, `MVP`, `риск`, `dogfood`, `SaaS-фича`.

### Route B — Planning before coding → `ARCHITECT`
спланировать фичу · архитектура до кода · интервью по идее · выбрать вариант до кодинга.
Триггеры: `архитектура`, `спланировать`, `как лучше реализовать`, `thinking`, `разбор фичи`.

### Route C — Implementation → `DEVELOPER`
есть `_handoff/DEVELOPER_INSTRUCTIONS.md` · писать код по сценарию Architect.

### Route D — Testing / QA → `TESTER`
протестировать дашборд/апп целиком · проверить фичу · регрессия · smoke/integration.
Триггеры: `тест`, `протестировать`, `регрессия`, `qa`, `проверить целостность`.

### Route E — Code review → `CODE_REVIEWER`
код-ревью · качество после фичи · вердикт перед merge.
Триггеры: `ревью`, `code review`, `quality gate`, `перед релизом`.

### Route F — Documentation → `TECHNICAL_WRITER`
обновить доки по фиче · журнал координации · переписать markdown.
Триггеры: `документация`, `обнови docs`, `журнал`, `перепиши документ`.

### Route G — Autopilot → полный pipeline
**Триггер:** `Роут: автопилот`. **Предусловие:** существует `_handoff/DEVELOPER_INSTRUCTIONS.md` (иначе STOP).
Последовательность: DEVELOPER → TESTER → CODE_REVIEWER → TECHNICAL_WRITER, с `_handoff/AUTOPILOT_STATE.md`
(`step` / `verdict` / `retry_count` / `pr_number`). Единый `retry_count` на весь pipeline:
- TESTER `NO-GO` или REVIEWER `BLOCK` при `retry_count=0` → `retry_count:1`, возврат к DEVELOPER.
- Повторный `NO-GO`/`BLOCK` при `retry_count=1` → STOP с отчётом.
- TECHNICAL_WRITER — best-effort (блокер по докам не останавливает pipeline).
- Финал: `step: done`, выдать готовую команду merge (выполняет только пользователь).

---

## Политика качества
1. Не соглашаться автоматически с идеей пользователя.
2. Есть более эффективный путь — предложить альтернативу и trade-off.
3. Бизнес-решения заканчивать: Recommendation · Why now · MVP scope · Metrics.

---

## Engineering pipeline (строгий порядок)
**Деплой:** `command-center/` → `marketing.merowingus.com` (Vercel, проект "command-center").
Next.js 14 + Supabase (Phase 1 active). `main` = основная ветка.
Статический прототип `dashboard/` — локальный, в Vercel больше не деплоится.

```
feature/<slug> → PR → [проверка пользователем] → main
```

| Шаг | Агент | Git |
|---|---|---|
| 1 | BUSINESS_ANALYST | — |
| 2 | ARCHITECT | — (только `_handoff/*`, `docs/architecture/*`) |
| 3 | DEVELOPER | `git checkout -b feature/<slug>` → коммиты → push → `gh pr create` |
| 4 | TESTER | `gh pr checkout <N>`; GO/NO-GO |
| 5 | CODE_REVIEWER | `gh pr review --approve / --request-changes` (НЕ мержит) |
| 6 | TECHNICAL_WRITER | docs-коммиты в ту же ветку + запись в журнал координации |
| 7 | **Merge** | **только пользователь:** `gh pr merge <N> --squash --delete-branch` |

---

## Быстрые команды
- `Роут: авто` · `Роут: бизнес` · `Роут: архитектор` · `Роут: разработчик` · `Роут: тестировщик` ·
  `Роут: код-ревью` · `Роут: техписатель` · `Роут: автопилот`.
