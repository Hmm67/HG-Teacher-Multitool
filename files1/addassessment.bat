@echo off
title Add New Assessment
mode 100,35
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "students=students.txt"
set "coursePath=courses"

:begin
cls
echo [38;2;255;255;220m╔Enter the name of the course to add the assessment to (e.g. Legal Studies):
echo ║
set /p course=%BS%╚════^>

if not exist "%coursePath%\%course%" (
    mkdir "%coursePath%\%course%"
)

cls
echo [38;2;255;255;220m╔Enter Assessment Name (e.g. Essay 1):
echo ║
set /p assess=%BS%╚════^>

cls
echo [38;2;255;255;220m╔Enter Assessment Weighting (e.g. 20 for 20%%):
echo ║
set /p weight=%BS%╚════^>

cls
echo [38;2;255;255;220m╔Enter Total Marks (e.g. 30):
echo ║
set /p outof=%BS%╚════^>

set "assessFile=%coursePath%\%course%\%assess%.txt"

(
    echo #weighting=%weight%,outof=%outof%
    echo Name,Mark
) > "%assessFile%"

echo.
echo Assessment "%assess%" created for course "%course%"
echo Weighting: %weight%%% out of: %outof% marks
echo.

choice /m "Add another?"

if errorlevel 2 (
    echo Returning to menu...
    timeout /t 1 >nul
    exit 
)

goto begin