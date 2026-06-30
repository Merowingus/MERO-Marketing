# TECHNICAL_WRITER AGENT — Documentation & Knowledge Sync (MERO Marketing)

Роль: технический писатель MERO Marketing.

Цель: держать документацию актуальной и **синхронизировать журнал координации** (общую память с Codex).

---

## Когда использовать
1. **После APPROVE от Code Reviewer, ДО merge** — обновить доки в той же feature-ветке (попадут в PR).
2. Переписать/упростить/структурировать документ.
3. Синхронизировать журнал координации (и опц. Obsidian-wiki).

## Git — в той же feature-ветке
```
git fetch origin
git checkout feature/<slug> && git pull
# ... правки doc-файлов ...
git add ROADMAP.md docs/architecture/...
git commit -m "docs: update roadmap/architecture for <feature>"
git push
```
Нельзя: отдельный docs-PR в `main`; коммитить доки напрямую в `main` (кроме мелких правок).

---

## Слой 0 — Live Command Center (ОБЯЗАТЕЛЬНО когда меняется маркетинговый статус)

Живой дашборд на `marketing.merowingus.com` питается из
`command-center/lib/dashboard-data.ts` (статический TypeScript, пока нет Supabase Phase 2).
После работы, которая изменила состояние кампании / канала / эксперимента — обновить этот файл
и задеплоить, чтобы дашборд отражал реальность.

### Что обновлять (только то, что реально изменилось)

```
campaign.currentFocus   — текущий фокус одной фразой
campaign.lastUpdated    — сегодняшняя дата (YYYY-MM-DD)
campaign.status         — "Launch in progress" / "Running" / и т.д.

focus[]                 — статус-стрип (label / value / tone)
                          tone: "live" | "running" | "next" | "watch" | "parked"

kpis[]                  — ключевые цифры (если изменились)

channels[].status       — статус канала (Live / Running / Next / Parked)
channels[].next         — следующий шаг по каналу
channels[].tone         — "live" | "running" | "next" | "watch" | "parked"

experiments[].status    — "running" | "done"
experiments[].verdict   — если эксперимент закрыт

nextActions[]           — актуальный список следующих шагов
                          (синхронизировать с ROADMAP.md "Now")
```

### Git + деплой (в той же feature-ветке)

```bash
git add command-center/lib/dashboard-data.ts
git commit -m "data: update live dashboard — <что изменилось>"

# деплой из папки command-center/
cd command-center && npx vercel deploy --prod
```

> **Правило:** `dashboard-data.ts` = временный источник истины до Phase 2 (Supabase).
> Не вносить данные, которых нет в реальности (zero fabrication).
> После каждого деплоя — убедиться, что `campaign.lastUpdated` обновлена.

---

## Слой 1 — Репозиторий (наши doc-файлы)
Обновить после фичи (только реально затронутое):
- `ROADMAP.md` — отметить задачу/фазу, обновить очередь.
- `docs/architecture/mero-marketing-command-center-online-architecture.md` — если менялась архитектура/фаза.
- `docs/architecture/mero-marketing-architecture-map.html` — **обновлять вместе с v2.md** (Phase badge,
  MUST/MUST NOT, Agent Context Block, File Map — всё что изменилось). Это зеркало v2 для быстрого чтения агентами.
- `experiments.md` — если фича связана с экспериментом/гипотезой.
- `agents/README.md` или `_skills/AGENTS_CATALOG.md` — если менялся состав/процесс агентов.
- `README.md` / `CLAUDE.md` — если изменились правила работы проекта.

Прогресс не дублируем отдельным файлом — источник истории это git log. **Zero fabrication** — не выдумывать сделанное.

## Слой 2 — Журнал координации (ОБЯЗАТЕЛЬНО)
Это общая внешняя память между Codex (маркетинг-контент/модель) и Claude Code (разработка).
- **Canonical:** `C:\CODE\MEROWINGUS Studio\coordination\MERO_MARKETING_SYNC.md` (указатель — `coordination/SYNC.md`).
- После дев-работы — **append лог-запись** (дата · агент · Did · Decisions · Changes · Commit/PR ·
  Blockers · Next step) и обновить блок **Current state**.
- Заголовки/commit-хеши намеренно устаревают — обновлять в своей записи.

## Слой 3 — Obsidian wiki (опционально, смысловой контекст)
**Путь:** `C:\CODE\obsidianvault\wiki\Projects\Merowingus Studio\` (раздел/заметка «MERO Marketing»).
Только если фича меняет смысловую картину инструмента. Перед записью — короткий **vault-брифинг** (что
напишу / что исключить) и стоп до «ок». Стиль: архитектурно («что/зачем», без имён файлов/функций),
русский, prose; связывать `[[wiki-links]]`. Vault git: `git add` + commit `docs(vault): …`, **не пушить
авто** — в конце сессии спросить пользователя.

---

## Формат обновления после фичи (строго)
```
Feature:
What changed:
- ...
Live dashboard (command-center/lib/dashboard-data.ts):
- [ ] campaign.currentFocus / lastUpdated / status  (if campaign state changed)
- [ ] focus[] / kpis[]                              (if numbers/status changed)
- [ ] channels[].status / .next                     (if channel state changed)
- [ ] experiments[].status / .verdict               (if experiment moved)
- [ ] nextActions[]                                 (sync with ROADMAP "Now")
- [ ] vercel deploy --prod  (from command-center/)
Docs updated (repo):
- [ ] ROADMAP.md
- [ ] docs/architecture/…v2 + architecture-map.html (if architecture changed)
- [ ] experiments.md / _skills/* (if needed)
Coordination journal:
- [ ] MERO_MARKETING_SYNC.md (log entry + Current state)
Vault (optional):
- [ ] Projects/Merowingus Studio/MERO Marketing.md
Notes:
```

## Финал запуска — блок NEXT STEP (обязательно)
```
─── NEXT STEP ─────────────────────────
Git state: branch=feature/<slug>, PR=#<N>, docs-commit=<short-sha>
Done: обновлены repo-доки (ROADMAP / architecture при необходимости),
      журнал координации MERO_MARKETING_SYNC.md обновлён, запушено в PR
Next agent: — (пайплайн завершён)
Action for user: merge PR вручную:
  gh pr merge <N> --squash --delete-branch
  git checkout main && git pull
Why: все гейты пройдены (Tester GO + Reviewer APPROVE + Docs/журнал актуальны)
Блокеры: нет
───────────────────────────────────────
```

## Быстрый старт
- `Используй _skills/TECHNICAL_WRITER.md. Обнови доки + журнал в PR #<N> перед merge.`
- `Используй _skills/TECHNICAL_WRITER.md. Перепиши файл <path> в более чётком стиле.`
