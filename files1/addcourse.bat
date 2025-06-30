@echo off
title Add a Course
mode 100,35
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "file=students.txt"

cls
echo [38;2;255;255;220m╔Enter the name of the course to create (e.g. Legal Studies):
echo ║
set /p course=%BS%╚════^>

:addstudents
cls
echo [38;2;255;255;220m╔Adding students to course: "%course%"
echo ║
echo ╠═══Enter name of student in the form Firstname Lastinitial (e.g. Aaron X):
echo ║
set /p name=%BS%╚════^>

echo.
echo You are about to add:
echo Name  : %name%
echo Course: %course%
echo.
choice /m "Is this correct?"

if errorlevel 2 (
    echo Operation cancelled.
    pause
    goto addstudents
)

>>"%file%" echo %name%,%course%
echo.
echo Student added to %course% successfully.

choice /m "Add another student to %course%?"

if errorlevel 2 (
    echo Returning to menu...
    timeout /t 1 >nul
    exit
)

goto addstudents
