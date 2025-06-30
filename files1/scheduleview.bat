@echo off
title View Schedule
mode 80,25
chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

set "schedulefile=schedule.txt"

:viewagain
cls
echo [38;2;255;255;220m╔ Enter day to view (e.g. Monday):
echo ║
set /p "day=╚════> "
if not defined day exit

set "found=0"

cls
echo ╔════════════════════════════════════════════╗
echo ║         SCHEDULE FOR %day%                
echo ╠════════════════════════════════════════════╣
echo ║ Period           Course                    ║
echo ╠════════════════════════════════════════════╣

for /f "usebackq tokens=1,2,3 delims=," %%a in ("%schedulefile%") do (
    set "entryDay=%%a"
    set "entryPeriod=%%b"
    set "entryCourse=%%c"
    set "entryDay=!entryDay: =!"
    if /i "!entryDay!"=="%day%" (
        set /a found+=1
        set "p=%%b               "
        set "c=%%c                          "
        set "p=!p:~0,15!"
        set "c=!c:~0,25!"
        echo ║ !p!!c!
    )
)

if !found! equ 0 (
    echo ║        No schedule found for this day        ║
)

echo ╚════════════════════════════════════════════╝
echo.
choice /m "View another day?"
if errorlevel 2 (
    echo Returning to menu...
    timeout /t 1 >nul
    exit
)
goto viewagain
