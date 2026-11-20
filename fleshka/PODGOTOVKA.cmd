@echo off
chcp 65001 >nul
title JARVIS - podgotovka noutbuka
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo.
  echo  Zapustite PODGOTOVKA.cmd pravoy knopkoy - "Zapusk ot imeni administratora".
  echo.
  pause
  exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0PODGOTOVKA.ps1"
