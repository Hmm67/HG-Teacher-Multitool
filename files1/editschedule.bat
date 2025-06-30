@echo off
title Edit Schedule
mode 80,25
chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion
:begin
set "schedulefile=schedule.txt"

:editDay
cls
echo [38;2;255;255;220m╔ Enter the day to edit schedule for (e.g. Monday):
echo ║
set /p "day=╚════> "
if not defined day exit

echo.
set /p "periods=How many periods on %day%? ══> "
if not defined periods exit

set "tempfile=schedule_tmp.txt"
if exist "%tempfile%" del "%tempfile%"

if exist "%schedulefile%" (
    for /f "usebackq delims=" %%a in ("%schedulefile%") do (
        echo %%a | findstr /i /b /c:"%day%," >nul
        if errorlevel 1 echo %%a >> "%tempfile%"
    )
)

for /l %%i in (1,1,%periods%) do (
    echo.
    set /p "course=Enter course for Period %%i: "
    echo %day%, %%i, !course! >> "%tempfile%"
)

move /y "%tempfile%" "%schedulefile%" >nul

echo.
echo Schedule for %day% saved.
choice /m "Edit another Day?"

if errorlevel 2 (
    echo Returning to menu...
    timeout /t 1 >nul
    exit
)

goto begin
