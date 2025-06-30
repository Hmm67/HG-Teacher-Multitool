@echo off
title Remove a Course
mode 100,35
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

:retry
cls
set "file=students.txt"
set "temp=students_tmp.txt"

echo [38;2;255;255;220m╔Enter the name of the course to remove (e.g. Legal):
echo ║
set /p "course=╚════> "

echo.
echo You are about to remove the entire course:
echo Course: %course%
echo This will delete ALL students enrolled in this course.
echo.
choice /m "Are you sure?"

if errorlevel 2 (
    echo Operation cancelled.
    pause
    goto retry
)

:: Filter all lines that do NOT contain the course (case-insensitive)
> "%temp%" (
    for /f "usebackq delims=" %%l in ("%file%") do (
        echo %%l | findstr /i "%course%" >nul
        if errorlevel 1 echo %%l
    )
)

move /y "%temp%" "%file%" >nul
echo.
echo Course "%course%" and all associated students removed.

choice /m "Remove another course?"
if errorlevel 2 (
    echo Returning to menu...
    timeout /t 1 >nul
    exit
)

goto retry
