# J.A.R.V.I.S. — установка ядра на Windows (запасной путь, если Claude Code не ставит сам)
# Запуск в PowerShell:
#   irm https://raw.githubusercontent.com/ikigai-promotion-kz/jarvis/main/install-core.ps1 | iex
# Ничего не удаляет. Уже установленное пропускается.

$ErrorActionPreference = 'Continue'
function Say($t) { Write-Host "→ $t" -ForegroundColor Cyan }

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Write-Host 'Claude Code не найден. Сначала пройдите волну 1 (окружение) и перезапустите терминал.' -ForegroundColor Red
  return
}
if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
  Write-Host 'Node.js (npx) не найден. Сначала пройдите волну 1 (окружение) и перезапустите терминал.' -ForegroundColor Red
  return
}

Say 'Маркетплейсы'
foreach ($m in 'anthropics/claude-plugins-official', 'anthropics/skills', 'ikigai-promotion-kz/jarvis') {
  claude plugin marketplace add $m
}

Say 'Плагины ядра'
$plugins = 'jarvis@jarvis',
  'superpowers@claude-plugins-official',
  'context7@claude-plugins-official',
  'exa@claude-plugins-official',
  'frontend-design@claude-plugins-official',
  'skill-creator@claude-plugins-official',
  'claude-md-management@claude-plugins-official',
  'document-skills@anthropic-agent-skills'
foreach ($p in $plugins) { claude plugin install $p }

Say 'Совет директоров (ceo-council)'
npx -y skills add serejaris/personal-corp-os --skill ceo-council -g -a claude-code -y

Say 'Проверка'
claude plugin list
$council = Join-Path $HOME '.claude\skills\ceo-council\SKILL.md'
if (Test-Path $council) { Write-Host 'ceo-council: на месте' -ForegroundColor Green }
else { Write-Host 'ceo-council: НЕ встал — повторите последнюю команду' -ForegroundColor Yellow }

Write-Host ''
Write-Host 'Готово. Запустите claude и наберите /jarvis:setup' -ForegroundColor Green
