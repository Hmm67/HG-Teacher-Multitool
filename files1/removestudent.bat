@echo off
title Remove a Student
mode 100,35
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

:retry
cls
set "file=students.txt"
set "temp=students_tmp.txt"

echo [38;2;255;255;220m╔Enter name of student in the form Firstname Lastinitial (e.g. Aaron X): 
echo ║
set /p name=%BS%╠══^>
echo ║
echo ╠═══Enter the course:
echo ║
set /p course=%BS%╚════^>

echo.
echo You are about to remove:
echo Name  : %name%
echo Course: %course%
echo.
choice /m "Is this correct?"

if errorlevel 2 (
    echo Operation cancelled.
    pause
    goto retry
)


> "%temp%" (
    for /f "usebackq tokens=1,* delims=," %%a in ("%file%") do (
        if /i not "%%a,%%b"=="%name%,%course%" echo %%a,%%b
    )
)

move /y "%temp%" "%file%" >nul
echo.
echo Student removed successfully.

choice /m "Remove another?"

if errorlevel 2 (
    echo Returning to menu...
    timeout /t 1 >nul
    exit
)

goto retry
