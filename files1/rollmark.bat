@echo off
title Mark the Roll
mode 100,30
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

:markagain
cls
echo [38;2;255;255;220m╔ Enter the course to mark roll for (e.g. ENC or Legal):
echo ║
set /p "course=╚════> "
if not defined course exit

if not exist "Past Rolls" mkdir "Past Rolls"

for /f %%a in ('powershell -nologo -command "Get-Date -Format yyyy-MM-dd_HH-mm"') do set "datetime=%%a"
set "outfile=Past Rolls\%course%_roll_%datetime%.txt"

echo Course: %course% > "%outfile%"
echo Date:   %datetime% >> "%outfile%"
echo. >> "%outfile%"
echo Attendance: >> "%outfile%"

set /a count=0
for /f "usebackq delims=" %%a in ("students.txt") do (
    set "line=%%a"
    for /f "tokens=1 delims=," %%n in ("!line!") do set "fullname=%%n"
    echo !line! | findstr /i ",%course%" >nul
    if !errorlevel! equ 0 (
        call :MarkStudent "!fullname!"
        set /a count+=1
    )
)

if !count! equ 0 (
    echo.
    echo [38;2;255;255;220mNo students found for course "%course%".
    del "%outfile%" >nul 2>&1
    pause
    exit /b
)

echo.
echo [38;2;255;255;220mRoll marked. File saved as: %outfile%
echo.
choice /m "Mark roll for another course?"

if errorlevel 2 (
    echo Returning to menu...
    timeout /t 1 >nul
    exit
)

goto markagain

:MarkStudent
setlocal
set "name=%~1"
choice /m "Is %name% here"
if errorlevel 2 (
    endlocal & echo %name% - Away >> "%outfile%"
    goto :eof
)
endlocal & echo %name% - Here >> "%outfile%"
goto :eof
