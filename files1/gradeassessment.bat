@echo off
title Grade Assessment
mode 120,40
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "students=students.txt"
set "coursePath=courses"

:begin
cls
echo [38;2;255;255;220m╔ Enter the course name (e.g. Legal Studies):
echo ║
set /p "course=%BS%╚════>"
if not defined course goto begin

if not exist "%coursePath%\%course%" (
    echo.
    echo [Error] Course not found!
    pause
    goto begin
)

cls
echo [38;2;255;255;220mAvailable assessments in "%course%":
echo.

set "found=0"
for %%f in ("%coursePath%\%course%\*.txt") do (
    echo   - %%~nf
    set "found=1"
)

if "!found!"=="0" (
    echo.
    echo [Error] No assessments found.
    pause
    goto begin
)

echo.
echo [38;2;255;255;220m╔ Enter assessment name (without extension):
echo ║
set /p "assess=%BS%╚════>"
if not defined assess goto begin

set "assessFile=%coursePath%\%course%\%assess%.txt"
if not exist "%assessFile%" (
    echo.
    echo [Error] Assessment file not found!
    pause
    goto begin
)


set "header="
<"%assessFile%" set /p "header="


set "tempAssess=%temp%\%random%.txt"
> "%tempAssess%" echo !header!


set "tempStudentList=%temp%\%random%.txt"
> "%tempStudentList%" break


for /f "tokens=1* delims=," %%a in ('type "%students%"') do (
    if /i "%%b"=="%course%" (
        >> "%tempStudentList%" echo %%a
    )
)


for /f "usebackq delims=" %%s in ("%tempStudentList%") do (
    set "studentName=%%s"
    set "currentMark="
    

    for /f "usebackq skip=1 tokens=1* delims=," %%x in ("%assessFile%") do (
        if "%%x"=="!studentName!" set "currentMark=%%y"
    )
    
    :enterMark
    cls
    echo [38;2;255;255;220m╔ Student: !studentName!
    if defined currentMark (
        echo [38;2;255;255;220m╠═══ Current mark: !currentMark!
        echo [38;2;255;255;220m╠═══ Enter new mark or DNP to skip:
    ) else (
        echo [38;2;255;255;220m╠═══ Enter mark or DNP to skip:
    )
    echo ║
    set /p "mark=%BS%╚════>"
    
    if "!mark!"=="" goto enterMark
    
    if /i "!mark!"=="DNP" (
        echo Skipping !studentName!...
    ) else (
        >> "%tempAssess%" echo !studentName!,!mark!
    )
    set "mark="
)


move /y "%tempAssess%" "%assessFile%" >nul


del "%tempStudentList%" >nul

echo.
echo Grading complete for "%assess%"
echo.
choice /m "Grade another?"

if errorlevel 2 (
    echo Returning to menu...
    timeout /t 1 >nul
    exit 
)

goto begin
echo Press any key to return to menu...
pause >nul
exit 