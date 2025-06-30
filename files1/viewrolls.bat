@echo off
title View Past Roll
mode 80,30
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

:viewagain
cls
echo [38;2;255;255;220m╔ Enter course name (e.g. ENC or Legal):
echo ║
set /p "course=%BS%╚════> "
if not defined course exit 

cls
echo [38;2;255;255;220m╔ Enter date of roll (e.g. 2025-06-24):
echo ║
set /p "rolldate=%BS%╚════> "
if not defined rolldate exit 

set "rollfile="


for /f "delims=" %%a in ('dir /b /a:-d "Past Rolls\%course%_roll_%rolldate%_*.txt" 2^>nul') do (
    set "rollfile=Past Rolls\%%a"
)

if not defined rollfile (
    echo.
    echo [38;2;255;100;100mNo roll found for %course% on %rolldate%.
    echo.
    pause
    goto viewagain
)

cls
echo [38;2;255;255;220m╔════════════════════════════════════════════════════════════╗
echo ║                 ROLL FOR %course% ON %rolldate%                 ║
echo ╠════════════════════════════════════════════════════════════╣
echo ║ Student Name                     Attendance Status         ║
echo ╠════════════════════════════════════════════════════════════╣

set "printing=0"
for /f "usebackq delims=" %%a in ("%rollfile%") do (
    set "line=%%a"
    
    :: Remove trailing spaces and CR characters
    set "line=!line: =!"
    set "line=!line: =!"
    set "line=!line: =!"
    set "line=!line: =!"
    
    if /i "!line!"=="Attendance:" (
        set "printing=1"
    ) else if !printing! equ 1 (
        if not "!line!"=="" (
            set "output=!line!                                         "
            set "output=!output:~0,56!"
            echo ║ !output! 
        )
    )
)

echo ╚════════════════════════════════════════════════════════════╝
echo.

choice /m "View another roll?"
if errorlevel 2 (
    echo Returning to menu...
    timeout /t 1 >nul
    exit
)

set "rollfile="
goto viewagain