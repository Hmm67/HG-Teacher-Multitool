@echo off
title Update Password
mode 80,25
chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

set "passwordFile=password.txt"


cls
echo [38;2;255;255;220m╔ Enter current password:
echo ║
set /p "oldpass=╚════>"
set /p stored=<"%passwordFile%"


if not "%oldpass%"=="%stored%" (
    echo.
    echo Incorrect password. Returning to menu.
    timeout /t 2 >nul
    exit /b
)


cls
echo ╔ Enter new password:
echo ║
set /p "newpass=╚════>"
if not defined newpass (
    echo Password not changed. Blank not allowed.
    timeout /t 2 >nul
    exit /b
)

> "%passwordFile%" set /p="!newpass!"
echo.
echo Password updated successfully.
timeout /t 2 >nul
exit
