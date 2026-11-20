# J.A.R.V.I.S. · подготовка ноутбука с флешки, без интернета (запасной путь интенсива IKIGAI PROMOTION).
# Запуск: PODGOTOVKA.cmd правой кнопкой → «Запуск от имени администратора».
# Что делает: копирует пак в Документы\Cursor\JARVIS-PAK → флешку можно вынуть → создаёт папки
# Документы\Cursor и Документы\Claude\inbox → ставит Cursor → запускает install-windows.ps1
# (Git, Node.js, PowerShell 7, Python, FFmpeg, Claude Code, расширение в Cursor) → таблица из 8 строк.
# Сервера и ключей здесь нет. Уже установленное пропускается, ничего не удаляется.
$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'
function Say($t, $c = 'Gray') { Write-Host $t -ForegroundColor $c }
function Big($t, $c = 'Green') { Write-Host ''; Write-Host ('=' * 66) -ForegroundColor $c; Write-Host "  $t" -ForegroundColor $c; Write-Host ('=' * 66) -ForegroundColor $c; Write-Host '' }

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) { Big 'Запустите PODGOTOVKA.cmd правой кнопкой → «Запуск от имени администратора»' 'Red'; Read-Host 'Enter — закрыть'; exit 1 }

$SRC = $PSScriptRoot
$DOCS = [Environment]::GetFolderPath('MyDocuments')
if (-not $DOCS -or -not (Test-Path $DOCS)) { $DOCS = Join-Path $env:USERPROFILE 'Documents'; New-Item -ItemType Directory -Force -Path $DOCS | Out-Null }
$CURSORDIR = Join-Path $DOCS 'Cursor'
$PAK = Join-Path $CURSORDIR 'JARVIS-PAK'
New-Item -ItemType Directory -Force -Path $PAK, (Join-Path $DOCS 'Claude\inbox') | Out-Null
Big 'J.A.R.V.I.S. · подготовка ноутбука с флешки' 'Cyan'

# 1. Копия пака на диск — флешка свободна, а агент Cursor потом найдёт пак в обычном месте
Say "Копирую пак в $PAK (1–3 минуты)…" 'Yellow'
robocopy $SRC $PAK /E /XF PODGOTOVKA.cmd PODGOTOVKA.ps1 /NFL /NDL /NJH /NJS /NP | Out-Null
Big 'ФЛЕШКУ МОЖНО ВЫНУТЬ — идите к следующему ноутбуку. Здесь всё дальше идёт само (10–20 минут).' 'Green'

# 2. Cursor — тихо, в папку пользователя, как обычный установщик
$CUR = Join-Path $env:LOCALAPPDATA 'Programs\cursor\resources\app\bin\cursor.cmd'
if (-not (Test-Path $CUR)) {
  Say '· Cursor'
  $f = Get-ChildItem $PAK -Filter 'CursorUserSetup-x64-*.exe' | Select-Object -First 1 -ExpandProperty FullName
  if ($f) { Start-Process -FilePath $f -ArgumentList '/VERYSILENT /NORESTART /SUPPRESSMSGBOXES /MERGETASKS=!runcode' -Wait -WindowStyle Hidden }
  else { Say '    установщика Cursor нет в паке' 'Red' }
} else { Say 'Cursor уже стоит — пропускаю.' 'Green' }

# 3. Всё остальное — тем же скриптом, что у учеников (он же печатает итоговую таблицу)
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PAK 'install-windows.ps1') -Pak $PAK

Say ''
Say 'Дальше участник: открыть Cursor → войти в свой аккаунт Cursor → открыть папку Документы\Claude → волна 2 «Просыпайся» на странице jarvis.ikigaipromotion.kz/seriya-1.' 'Cyan'
Say "Журнал установки: $PAK\jarvis-ustanovka-log.txt" 'Gray'
Read-Host 'Enter — закрыть окно'
