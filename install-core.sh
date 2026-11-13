#!/usr/bin/env bash
# J.A.R.V.I.S. — установка ядра на macOS / Linux (запасной путь, если Claude Code не ставит сам)
# Запуск в Терминале:
#   curl -fsSL https://raw.githubusercontent.com/ikigai-promotion-kz/jarvis/main/install-core.sh | bash
# Ничего не удаляет. Уже установленное пропускается.

say() { printf '\033[36m→ %s\033[0m\n' "$1"; }

command -v claude >/dev/null 2>&1 || { echo "Claude Code не найден. Сначала пройдите волну 1 (окружение) и перезапустите Терминал."; exit 1; }
command -v npx >/dev/null 2>&1 || { echo "Node.js (npx) не найден. Сначала пройдите волну 1 (окружение) и перезапустите Терминал."; exit 1; }

say "Маркетплейсы"
for m in anthropics/claude-plugins-official anthropics/skills ikigai-promotion-kz/jarvis; do
  claude plugin marketplace add "$m"
done

say "Плагины ядра"
for p in jarvis@jarvis \
         superpowers@claude-plugins-official \
         context7@claude-plugins-official \
         exa@claude-plugins-official \
         frontend-design@claude-plugins-official \
         skill-creator@claude-plugins-official \
         claude-md-management@claude-plugins-official \
         document-skills@anthropic-agent-skills; do
  claude plugin install "$p"
done

say "Совет директоров (ceo-council)"
npx -y skills add serejaris/personal-corp-os --skill ceo-council -g -a claude-code -y

say "Проверка"
claude plugin list
if [ -f "$HOME/.claude/skills/ceo-council/SKILL.md" ]; then echo "ceo-council: на месте"; else echo "ceo-council: НЕ встал — повторите последнюю команду"; fi

echo
echo "Готово. Запустите claude и наберите /jarvis:setup"
