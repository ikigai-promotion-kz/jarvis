# Каталог отделов JARVIS

Проверено 14.11.2026: имена плагинов и скиллов сверены с репозиториями. Команды ядра и отделов «Стратегия», «Маркетинг», «Документы» прогнаны в чистой песочнице.

**Как пользоваться каталогом.** Ставь отдел целиком только если человеку нужны все его сотрудники. Иначе — выбранные позиции. Описание каждого скилла попадает в контекст каждой сессии, поэтому лишний сотрудник замедляет и путает. Потолок на старте — 4 отдела сверх ядра и не больше 30 скиллов от сторонних авторов.

**Две команды установки** (обе выполняются в терминале, не слэш-командой):
- плагин: `claude plugin install <имя>@<маркетплейс>`
- отдельные скиллы: `npx -y skills add <репозиторий> --skill <имя1> --skill <имя2> -g -a claude-code -y`

Если система не даёт тебе выполнить команду самому — передай её человеку с «!» в начале, ПО ОДНОЙ: одна команда — одно сообщение, «Команда 2 из 4», и жди его «готово». Сначала одной фразой: «скопируйте команду целиком, вставьте в поле ввода, перед „!“ без пробела, Enter».

После каждой установки проверь, что результат появился: `claude plugin list` или папка `~/.claude/skills/<имя>/SKILL.md`. Не появился — повтори команду один раз. Снова нет — запиши в отчёт как «не встало», дальше не импровизируй.

---

## Волна 1 — окружение (делает Cursor до запуска Claude Code)
Git, Node.js + npm, PowerShell 7 (Windows), Python, FFmpeg, сам Claude Code и расширение для Cursor. Windows — скрипт `install-windows.ps1` (ставит из пака JARVIS-PAK или из интернета) по заданию `prompts/01-okruzhenie-windows.txt`; Mac — `prompts/01-okruzhenie-mac.txt`.

## Волна 2 — ядро (ставится всем, без вопросов)

| Сотрудник | Что делает | Команда |
|---|---|---|
| superpowers | методики: план, брейншторм, отладка, проверка перед «готово» | `claude plugin install superpowers@claude-plugins-official` |
| context7 | свежая документация любых библиотек и сервисов (MCP, без ключа) | `claude plugin install context7@claude-plugins-official` |
| exa | поиск в интернете и ресёрч (MCP, без ключа) | `claude plugin install exa@claude-plugins-official` |
| frontend-design | красивые страницы и интерфейсы вместо шаблонных | `claude plugin install frontend-design@claude-plugins-official` |
| skill-creator | помогает собрать свой скилл под свою задачу | `claude plugin install skill-creator@claude-plugins-official` |
| claude-md-management | следит, чтобы правила CLAUDE.md были в порядке | `claude plugin install claude-md-management@claude-plugins-official` |
| document-skills | Word, Excel, PowerPoint, PDF: читать и создавать | `claude plugin marketplace add anthropics/skills` → `claude plugin install document-skills@anthropic-agent-skills` |
| ceo-council | совет из пяти AI-директоров для решений | `npx -y skills add serejaris/personal-corp-os --skill ceo-council -g -a claude-code -y` |

## Волна 2 — отделы по выбору (2–4 под запрос человека)

### Стратегия и офис руководителя
Кому: собственник, руководитель, тот, кто принимает решения и планирует.
Сотрудники (CodeAlive-AI/ceo-ai-os): `decision-playbook` (разбор решения по шагам), `strategic-review` (стратегический обзор), `ceo-weekly-review` (недельный обзор руководителя), `problem-definition` (сформулировать настоящую проблему), `idea-generator` (идеи под задачу), `meeting-prep` (подготовка к встрече).
Команда: `npx -y skills add CodeAlive-AI/ceo-ai-os --skill decision-playbook --skill strategic-review --skill problem-definition -g -a claude-code -y` (выбери нужные).
Ключей не требует.

### Маркетинг
Кому: продвигает продукт, услугу, курс, магазин.
Сотрудники (coreyhaines31/marketingskills): `product-marketing` (**ставится первым — на него ссылаются остальные**: контекст продукта), `marketing-plan`, `marketing-ideas`, `offers` (упаковка оффера), `pricing`, `customer-research`, `marketing-psychology`, `launch`.
Команда: `npx -y skills add coreyhaines31/marketingskills --skill product-marketing --skill offers --skill marketing-ideas -g -a claude-code -y`.
Уклон авторов — SaaS и англоязычный рынок: попроси JARVIS адаптировать под Казахстан и СНГ.

### Тексты и контент
Кому: пишет посты, рассылки, тексты сайта, рекламу.
Сотрудники (marketingskills): `copywriting`, `copy-editing`, `social`, `content-strategy`, `emails`, `ad-creative`. Плюс `humanizer` из ceo-ai-os — убирает «нейросетевой» стиль.
Команда: `npx -y skills add coreyhaines31/marketingskills --skill copywriting --skill social --skill content-strategy -g -a claude-code -y`.

### Продажи
Кому: ведёт клиентов, переговоры, холодные контакты.
Сотрудники: из marketingskills — `sales-enablement`, `cold-email`, `prospecting`, `lead-magnets`; из ceo-ai-os — `founder-sales`, `sales-qualification`, `meeting-prep`.
Команда: `npx -y skills add coreyhaines31/marketingskills --skill sales-enablement --skill lead-magnets -g -a claude-code -y` и/или `npx -y skills add CodeAlive-AI/ceo-ai-os --skill founder-sales --skill sales-qualification -g -a claude-code -y`.

### Исследования и конкуренты
Кому: изучает рынок, конкурентов, клиентов.
Сотрудники: из marketingskills — `competitors`, `competitor-profiling`, `customer-research`; из ceo-ai-os — `competitive-analysis`, `company-intel`. Поиск даёт exa из ядра. Firecrawl (снимает сайты целиком) — в волне 3, нужен ключ.
Команда: `npx -y skills add coreyhaines31/marketingskills --skill competitor-profiling --skill customer-research -g -a claude-code -y` и `npx -y skills add CodeAlive-AI/ceo-ai-os --skill competitive-analysis -g -a claude-code -y`.

### Дизайн и сайты
Кому: делает лендинги, страницы, презентации, визуальный стиль.
Сотрудники: `frontend-design` уже в ядре. Плюс `example-skills@anthropic-agent-skills` — внутри theme-factory (темы оформления), brand-guidelines, canvas-design, web-artifacts-builder.
Команда: `claude plugin install example-skills@anthropic-agent-skills`.
Стили брендов из VoltAgent/awesome-design-md — это не скилл, а файл `DESIGN.md`: скачай один стиль в папку проекта, когда человек выберет. Пример: `curl -fsSL https://raw.githubusercontent.com/VoltAgent/awesome-design-md/main/design-md/stripe/DESIGN.md -o DESIGN.md` (папки: apple, airbnb, stripe, notion, linear.app, vercel, tesla, spotify, nike, revolut и ещё около 70).

### Документы и отчёты
Кому: работает с Word, Excel, PowerPoint, PDF, договорами, отчётами.
Уже в ядре (`document-skills`). Отдельно ставить ничего не нужно — просто отметь отдел подключённым.

### Аналитика и цифры
Кому: считает деньги, метрики, читает выгрузки и таблицы.
Сотрудники (ceo-ai-os): `metrics-briefing`, `writing-north-star-metrics`, `measuring-product-market-fit`. Таблицы Excel — через `document-skills` (xlsx) из ядра.
Команда: `npx -y skills add CodeAlive-AI/ceo-ai-os --skill metrics-briefing --skill writing-north-star-metrics -g -a claude-code -y`.

### Личная продуктивность руководителя
Кому: хочет утренний бриф, итоги дня, фокус.
Сотрудники (ceo-ai-os): `morning-brief`, `daily-recap`, `focus-keeper`; из serejaris/personal-corp-os — `weekly-planning`, `weekly-retro`.
Команды: `npx -y skills add CodeAlive-AI/ceo-ai-os --skill morning-brief --skill daily-recap -g -a claude-code -y`, `npx -y skills add serejaris/personal-corp-os --skill weekly-planning -g -a claude-code -y`.

### Разработка (для тех, кто строит свой продукт)
Кому: делает приложение, сервис, бота.
Сотрудники: `superpowers` уже в ядре; `code-review@claude-plugins-official` (проверка кода несколькими агентами); `playwright@claude-plugins-official` (браузер для тестов — **тяжёлый, ~700 МБ, ставить только по прямой просьбе**).
Команда: `claude plugin install code-review@claude-plugins-official`.

### Отдел, которого нет в каталоге (HR, юристы, обучение, своя ниша)
Не ищи наугад в интернете. Собери отдел сам: один скилл через `skill-creator` под настоящую задачу человека (его шаги, его образцы, его критерии «хорошо»). Это и есть «свой сотрудник».

---

## Волна 3 — по запросу и с ключами (не в утро первого дня)

| Отдел | Что даёт | Что нужно от человека | Как подключить |
|---|---|---|---|
| Firecrawl | снимает сайты целиком, для ресёрча конкурентов | ключ `fc-…` с firecrawl.dev | `claude mcp add --transport http firecrawl https://mcp.firecrawl.dev/v2/mcp --header "Authorization: Bearer <ключ>"` — ключ человек вставляет сам |
| Gmail, Календарь, Диск | почта, встречи, файлы Google | вход в Google | claude.ai → Настройки → Коннекторы; Claude Code подхватывает сам |
| Higgsfield | картинки и видео | вход в Higgsfield, кредиты | MCP `https://mcp.higgsfield.ai/mcp` или CLI: `npm i -g @higgsfield/cli` → `higgsfield auth login` → `npx skills add higgsfield-ai/skills` |
| GitHub | хранение проектов | аккаунт, `gh auth login` | GitHub CLI |
| Vercel | публикация сайта в интернет | аккаунт, `vercel login` | `npm i -g vercel` |
| Canva | дизайны в Canva | вход в Canva | `claude plugin install canva@claude-plugins-official` |
| Notion | база знаний в Notion | вход в Notion | `claude plugin install notion@claude-plugins-official` |
| Telegram-бот | свой бот | токен от @BotFather | по гайду интенсива |
| Сервер 24/7, OpenClaw, Hermes | агент, который работает ночью | сервер, оплата, ChatGPT | server.ikigaipromotion.kz, agenty.ikigaipromotion.kz |
| WhatsApp-бот | заявки из WhatsApp | верификация Meta | whatsapp.ikigaipromotion.kz |

## Чего не ставим

- **Everything Claude Code (affaan-m/ECC) целиком** — 314 скиллов и около 28 тыс. токенов описаний в каждой сессии. Отдельные позиции — только по прямой просьбе человека, через `npx -y skills add affaan-m/ECC --skill <имя> -g -a claude-code -y`.
- **Каталог субагентов VoltAgent целиком** — в основном для программистов.
- **Оба больших пака целиком** (marketingskills + ceo-ai-os = больше 130 «сотрудников») — агент начинает путаться, кому поручить задачу.
