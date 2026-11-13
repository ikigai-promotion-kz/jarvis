# Волна 2 · «Просыпайся, JARVIS» — ядро одним промптом

**Где:** терминал Cursor (Windows — `Ctrl` + клавиша Ё, Mac — `Control` + клавиша слева от единицы, или меню View → Terminal). Наберите `claude` и Enter. Если спросит «Доверяете этой папке?» — Yes. Затем вставьте промпт ниже.

**Сколько ждать:** 5–10 минут.
**Что делаете вы:** разрешаете команды, если Claude Code спросит. Пока он работает, слушаете ведущего.

---

```
Просыпайся, JARVIS. Я не программист — объясняй простыми словами, по-русски, коротко.

Ты собираешь себе ядро — одинаковое для всех. Отделы под мой бизнес будем нанимать позже, сейчас их не ставь.

Правила: ничего не удаляй и не переустанавливай; если что-то уже стоит — пропусти и отметь; не выдумывай результат — после каждой команды смотри на её вывод.

1. Где мы. Покажи текущую папку. Если это домашняя папка, Рабочий стол или корень диска — остановись и скажи мне открыть в Cursor отдельную рабочую папку.

2. Маркетплейсы. Выполни в терминале по очереди:
   claude plugin marketplace add anthropics/claude-plugins-official
   claude plugin marketplace add anthropics/skills
   claude plugin marketplace add ikigai-promotion-kz/jarvis

3. Ядро. Поставь плагины по очереди:
   claude plugin install jarvis@jarvis
   claude plugin install superpowers@claude-plugins-official
   claude plugin install context7@claude-plugins-official
   claude plugin install exa@claude-plugins-official
   claude plugin install frontend-design@claude-plugins-official
   claude plugin install skill-creator@claude-plugins-official
   claude plugin install claude-md-management@claude-plugins-official
   claude plugin install document-skills@anthropic-agent-skills
   И скилл совета директоров:
   npx -y skills add serejaris/personal-corp-os --skill ceo-council -g -a claude-code -y

4. Проверка. Выполни claude plugin list и проверь, что есть файл ~/.claude/skills/ceo-council/SKILL.md. Что не встало — повтори команду один раз. Покажи таблицу: сотрудник | что умеет (одной фразой) | на месте (да/нет).

5. Папка для материалов. Если в рабочей папке нет INBOX — создай её.

6. Итог одной строкой: сколько из 9 сотрудников ядра на месте. Затем скажи мне: перезапусти Claude Code — дважды Ctrl + C, затем claude, — и после перезапуска набери /jarvis:setup.
```

---

**Как понять, что получилось:** в таблице 9 строк «да». После перезапуска команда `/jarvis:setup` видна в списке при наборе `/jarvis`.

**Если отказал:**
- Claude Code может попросить подтверждение на установку кода из интернета. Это защита: прочитайте, что ставится (список выше), и разрешите.
- Если он отказывается запускать `claude plugin …` изнутри себя, откройте второй терминал. В Cursor это значок «+» над терминалом. Вставьте туда команды из пунктов 2–3 по одной строке, затем вернитесь к Claude Code и попросите: «Проверь ядро — пункт 4».
