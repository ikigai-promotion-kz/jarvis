# J.A.R.V.I.S. · подготовка Windows к Claude Code одной командой (волна 1 интенсива IKIGAI PROMOTION).
#
# Что делает: находит пак JARVIS-PAK (папка или .zip с Google Диска), ставит из него
# Git, Node.js, PowerShell 7, Python, FFmpeg, Claude Code и расширение Claude Code для Cursor.
# Чего нет в паке — берёт из интернета официальными командами. Уже установленное пропускает.
# Ничего не удаляет. Права администратора просит один раз (окно Windows «Разрешить?» — «Да»).
#
# Запуск (это делает агент Cursor по заданию 01-okruzhenie-windows.txt):
#   powershell -NoProfile -ExecutionPolicy Bypass -File install-windows.ps1
#   ... -Proverka   — только показать таблицу, ничего не ставить
#   ... -Pak <путь> — указать пак вручную

param(
  [string]$Pak = '',
  [switch]$Proverka,
  [string]$Rezhim = ''
)
$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'

function Say($t, $c = 'Gray') { Write-Host $t -ForegroundColor $c }
function Big($t, $c = 'Green') { Write-Host ''; Write-Host ('=' * 66) -ForegroundColor $c; Write-Host "  $t" -ForegroundColor $c; Write-Host ('=' * 66) -ForegroundColor $c }
function RefreshPath { $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User') }
function Has($cmd) { RefreshPath; [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
function F($pattern) { if ($Pak -and (Test-Path $Pak)) { Get-ChildItem -Path $Pak -Recurse -Filter $pattern -ErrorAction SilentlyContinue | Sort-Object Name -Descending | Select-Object -First 1 -ExpandProperty FullName } }
function Run($file, $a) { $p = Start-Process -FilePath $file -ArgumentList $a -Wait -PassThru -WindowStyle Hidden; return $p.ExitCode }
function AddMachinePath($p) {
  $cur = [Environment]::GetEnvironmentVariable('Path', 'Machine')
  if (($cur -split ';') -notcontains $p) { [Environment]::SetEnvironmentVariable('Path', ($cur.TrimEnd(';') + ';' + $p), 'Machine') }
}
function AddUserPath($p) {
  $cur = [Environment]::GetEnvironmentVariable('Path', 'User'); if (-not $cur) { $cur = '' }
  if (($cur -split ';') -notcontains $p) { [Environment]::SetEnvironmentVariable('Path', ($cur.TrimEnd(';') + ';' + $p).TrimStart(';'), 'User') }
}
function Winget($id) {
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Say "    в паке нет — ставлю из интернета: winget $id" 'Yellow'
    winget install --id $id -e --silent --accept-source-agreements --accept-package-agreements --scope machine 2>&1 | Out-Null
  } else { Say "    в паке нет, и winget нет — эту программу не поставить. Скажите агенту Cursor." 'Red' }
}
function PythonOk { RefreshPath; $o = (& cmd /c 'python --version 2>&1'); return ($o -match 'Python 3') }

# ---------- 1. Где пак
function FindPak {
  if ($Pak -and (Test-Path $Pak)) { return (Resolve-Path $Pak).Path }
  $docs = [Environment]::GetFolderPath('MyDocuments'); $dl = Join-Path $env:USERPROFILE 'Downloads'
  $places = @((Get-Location).Path, (Join-Path $docs 'Cursor'), $docs, $dl, (Join-Path $env:USERPROFILE 'Desktop')) | Select-Object -Unique
  foreach ($pl in $places) {
    if (-not (Test-Path $pl)) { continue }
    $d = Get-ChildItem -Path $pl -Directory -Filter 'JARVIS-PAK*' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($d) { return $d.FullName }
  }
  foreach ($pl in $places) {
    if (-not (Test-Path $pl)) { continue }
    $z = Get-ChildItem -Path $pl -File -Filter 'JARVIS-PAK*.zip' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($z) {
      $dst = Join-Path $pl 'JARVIS-PAK'
      Say "Распаковываю $($z.Name) в $dst (1–3 минуты)…" 'Yellow'
      Expand-Archive -Path $z.FullName -DestinationPath $dst -Force
      return $dst
    }
  }
  return ''
}

# ---------- 2. Таблица проверки
function Check {
  RefreshPath
  function V($c) { try { $o = & cmd /c "$c 2>&1"; if ($LASTEXITCODE -eq 0) { ($o | Select-Object -First 1) } else { '' } } catch { '' } }
  $t = [ordered]@{}
  $t['Git'] = V 'git --version'
  $t['Node.js'] = V 'node --version'
  $t['npm'] = V 'npm --version'
  $pw = if (Test-Path 'C:\Program Files\PowerShell\7\pwsh.exe') { 'C:\Program Files\PowerShell\7\pwsh.exe' } else { 'pwsh' }
  $t['PowerShell 7'] = V "`"$pw`" --version"
  $t['Python'] = if (PythonOk) { V 'python --version' } else { '' }
  $t['FFmpeg'] = ((V 'ffmpeg -version') -replace ' Copyright.*', '')
  $t['Claude Code'] = V 'claude --version'
  $cur = Join-Path $env:LOCALAPPDATA 'Programs\cursor\resources\app\bin\cursor.cmd'
  $ext = if (Test-Path $cur) { (& $cur --list-extensions 2>$null) -match 'anthropic.claude-code' } else { $false }
  $t['Расширение Claude Code в Cursor'] = if ($ext) { 'да' } else { '' }
  $ok = 0; Write-Host ''; Say ('{0,-32} {1}' -f 'Программа', 'Стоит?') 'Cyan'
  foreach ($k in $t.Keys) { if ($t[$k]) { $ok++; Say ('{0,-32} да   {1}' -f $k, $t[$k]) 'Green' } else { Say ('{0,-32} НЕТ' -f $k) 'Red' } }
  return @($ok, $t.Count)
}

# ---------- 3. Часть с правами администратора (запускается вторым окном)
if ($Rezhim -eq 'admin') {
  RefreshPath
  if (-not (Has 'git')) {
    Say '· Git — история правок и Git Bash для Claude Code'
    $f = F 'Git-*-64-bit.exe'; if ($f) { Run $f '/VERYSILENT /NORESTART /NOCANCEL /SP- /SUPPRESSMSGBOXES' | Out-Null } else { Winget 'Git.Git' }
  }
  if (-not (Has 'node')) {
    Say '· Node.js и npm — на них работают помощники JARVIS'
    $f = F 'node-v*-x64.msi'; if ($f) { Run 'msiexec.exe' ('/i "' + $f + '" /qn /norestart') | Out-Null } else { Winget 'OpenJS.NodeJS.LTS' }
  }
  if (-not (Test-Path 'C:\Program Files\PowerShell\7\pwsh.exe') -and -not (Has 'pwsh')) {
    Say '· PowerShell 7 — современный терминал'
    $f = F 'PowerShell-*-win-x64.zip'
    if ($f) {
      New-Item -ItemType Directory -Force -Path 'C:\Program Files\PowerShell\7' | Out-Null
      Expand-Archive -Path $f -DestinationPath 'C:\Program Files\PowerShell\7' -Force
      AddMachinePath 'C:\Program Files\PowerShell\7'
    } else { Winget 'Microsoft.PowerShell' }
  }
  if (-not (PythonOk)) {
    Say '· Python — Word, Excel, PDF для отдела документов'
    $f = F 'python-*-amd64.exe'; if ($f) { Run $f '/quiet InstallAllUsers=1 PrependPath=1 Include_test=0' | Out-Null } else { Winget 'Python.Python.3.13' }
  }
  if (-not (Has 'ffmpeg')) {
    Say '· FFmpeg — видео и звук'
    $f = F 'ffmpeg-*.zip'
    if ($f) {
      $tmp = Join-Path $env:TEMP 'jarvis-ffmpeg'; Expand-Archive -Path $f -DestinationPath $tmp -Force
      $bin = Get-ChildItem $tmp -Recurse -Filter 'ffmpeg.exe' | Select-Object -First 1
      New-Item -ItemType Directory -Force -Path 'C:\Program Files\ffmpeg' | Out-Null
      Copy-Item -Path (Join-Path $bin.Directory.Parent.FullName '*') -Destination 'C:\Program Files\ffmpeg' -Recurse -Force
      Remove-Item $tmp -Recurse -Force; AddMachinePath 'C:\Program Files\ffmpeg\bin'
    } else { Winget 'Gyan.FFmpeg' }
  }
  exit 0
}

# ---------- 4. Основной ход
$Pak = FindPak
if ($Proverka) { $r = Check; exit 0 }

Big 'J.A.R.V.I.S. · подготовка компьютера' 'Cyan'
if ($Pak) { Say "Пак найден: $Pak" 'Green' } else { Say 'Пак JARVIS-PAK не найден — ставлю всё из интернета (дольше).' 'Yellow' }
$log = Join-Path $(if ($Pak) { $Pak } else { $env:TEMP }) 'jarvis-ustanovka-log.txt'
Start-Transcript -Path $log -Append | Out-Null

# 4.1 Программы для всего компьютера — одним окном с правами администратора
$needAdmin = (-not (Has 'git')) -or (-not (Has 'node')) -or (-not (PythonOk)) -or (-not (Has 'ffmpeg')) -or
  (-not (Test-Path 'C:\Program Files\PowerShell\7\pwsh.exe') -and -not (Has 'pwsh'))
if ($needAdmin) {
  Say ''
  Say 'Сейчас Windows спросит «Разрешить этому приложению вносить изменения?» — нажмите «Да».' 'Yellow'
  Say 'Откроется второе окно: в нём тихо ставятся Git, Node.js, PowerShell 7, Python, FFmpeg (5–15 минут).' 'Yellow'
  $self = $PSCommandPath
  $a = "-NoProfile -ExecutionPolicy Bypass -File `"$self`" -Rezhim admin" + $(if ($Pak) { " -Pak `"$Pak`"" } else { '' })
  try { Start-Process powershell.exe -ArgumentList $a -Verb RunAs -Wait } catch { Say 'Разрешение не дали — программы для всего компьютера не поставлены. Запустите ещё раз и нажмите «Да».' 'Red' }
} else { Say 'Git, Node.js, PowerShell 7, Python, FFmpeg уже стоят — пропускаю.' 'Green' }
RefreshPath

# 4.2 Разрешить запуск скриптов npm для своего пользователя (иначе «выполнение сценариев отключено»)
try { Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop } catch { }

# 4.3 Claude Code — готовый claude.exe туда же, куда кладёт официальный установщик
$CBIN = Join-Path $env:USERPROFILE '.local\bin'
if (-not (Has 'claude')) {
  Say '· Claude Code'
  $f = F '*claude-code-win32-x64-*.tgz'
  if ($f) {
    New-Item -ItemType Directory -Force -Path $CBIN | Out-Null
    $tmp = Join-Path $env:TEMP 'jarvis-claude'; New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    tar -xzf $f -C $tmp
    Copy-Item (Join-Path $tmp 'package\claude.exe') (Join-Path $CBIN 'claude.exe') -Force
    Remove-Item $tmp -Recurse -Force
  } else {
    Say '    в паке нет — ставлю официальной командой Anthropic (irm https://claude.ai/install.ps1 | iex)' 'Yellow'
    try { Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression } catch { Say "    не вышло: $_" 'Red' }
  }
}
AddUserPath $CBIN; RefreshPath
if (Test-Path 'C:\Program Files\Git\bin\bash.exe') { [Environment]::SetEnvironmentVariable('CLAUDE_CODE_GIT_BASH_PATH', 'C:\Program Files\Git\bin\bash.exe', 'User') }

# 4.4 Расширение Claude Code в Cursor — запуск из меню, а не командой
$CUR = Join-Path $env:LOCALAPPDATA 'Programs\cursor\resources\app\bin\cursor.cmd'
if (Test-Path $CUR) {
  if (-not ((& $CUR --list-extensions 2>$null) -match 'anthropic.claude-code')) {
    Say '· расширение Claude Code для Cursor'
    $f = F 'Anthropic.claude-code-*.vsix'
    if ($f) { & $CUR --install-extension $f --force 2>&1 | Out-Null } else { & $CUR --install-extension anthropic.claude-code --force 2>&1 | Out-Null }
  }
} else { Say 'Cursor не найден в обычной папке — расширение поставьте сами: Ctrl + Shift + X → «Claude Code» → Anthropic → Install.' 'Yellow' }

# 4.5 Итог
$r = Check; $ok = $r[0]; $total = $r[1]
if ($ok -eq $total) { Big "ГОТОВО: $ok из $total. Закройте Cursor полностью (все окна) и откройте снова." 'Green' }
else { Big "НЕ ВСЁ: $ok из $total. Агент Cursor, почини строки «НЕТ». Журнал: $log" 'Red' }
Stop-Transcript | Out-Null
