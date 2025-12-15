@echo off
chcp 65001 >nul
color 0E
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║          DATA VAULT - HAFTA 2 TEST (WSL)                     ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo ⏱️  Test başlatılıyor...
echo.
pause

wsl -d Ubuntu -- bash ~/test-hafta2.sh

pause
