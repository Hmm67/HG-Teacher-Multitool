@echo off
title View Students
mode 70,30
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

:begin
set "students=students.txt"


cls
echo [38;2;255;255;220m╔ Enter course name (e.g. ENC or Legal):
echo ║
set /p "course=%BS%╚════>"
if not defined course exit /b


cls
echo [38;2;255;255;220m╔═══════════════════════════════════════════════╗
echo ║          STUDENTS IN %course%                      
echo ╠═══════════════════════════════════════════════╣
echo ║ Student Name               Total Mark         ║
echo ╠═══════════════════════════════════════════════╣


set "found=0"
for /f "usebackq delims=" %%a in ("%students%") do (
    set "line=%%a"
    

    for /f "delims=," %%n in ("!line!") do set "fullname=%%n"
    

    set "record=!line:*%%n,=!"


    echo !record! | findstr /i /c:"%course%" >nul
    if !errorlevel! equ 0 (

        set "totalMark="
        set "markString=!record!"
        

        set "markString=!markString:*[Total: =!"
        for /f "delims=] " %%m in ("!markString!") do set "totalMark=%%m"
        
        if defined totalMark (
            set /a found+=1
            

            set "dispname=!fullname!                          "
            set "dispname=!dispname:~0,24!"
            

            set "markStr=   !totalMark!%"
            set "markStr=!markStr:~-5!"
            
            echo ║ !dispname!     !markStr!              
        )
    )
)


if !found! equ 0 (
    echo ║        No students found in this course       ║
    echo ║                                               ║
    echo ║                                               ║
)

echo ╚═══════════════════════════════════════════════╝
echo.

choice /m "View another course?"

if errorlevel 2 (
    echo Returning to menu...
    timeout /t 1 >nul
    exit
)

goto begin
