@echo off
title Update Student Grades
mode 120,40
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "students=students.txt"
set "coursePath=courses"
set "tempFile=students_temp.txt"

:begin
cls
echo [38;2;255;255;220m╔═══════════════════════════════════════════════╗
echo ║          UPDATE STUDENT GRADE RECORDS           ║
echo ╚═══════════════════════════════════════════════╝
echo.

if not exist "%students%" (
    echo [Error] students.txt not found!
    pause
    exit /b
)

if not exist "%coursePath%" (
    echo [Error] courses folder not found!
    pause
    exit /b
)

:selectCourse
cls
echo [38;2;255;255;220m╔ Enter course to update grades for:
echo ║
set /p "course=%BS%╚════>"
if not defined course goto selectCourse

if not exist "%coursePath%\%course%" (
    echo.
    echo [Error] Course not found!
    pause
    goto selectCourse
)

echo Processing grades for %course%...
echo This may take a moment...
echo.

:: Create temporary file
copy NUL "%tempFile%" >nul

:: Process each student
for /f "usebackq tokens=1* delims=," %%a in ("%students%") do (
    set "name=%%a"
    set "record=%%b"
    set "totalScaled=0"
    set "totalWeight=0"
    set "courseAverage=0"
    set "assessmentDetails="
    
    :: Only process students in selected course
    echo !record! | findstr /i /c:"%course%" >nul
    if not errorlevel 1 (
        :: Process each assessment in the course
        for %%f in ("%coursePath%\%course%\*.txt") do (
            set "assessFile=%%f"
            set "assessName=%%~nf"
            
            :: Reset variables
            set "weighting="
            set "outof="
            set "mark="
            
            :: Read assessment file header
            <"!assessFile!" set /p "header="
            
            :: Parse weighting and total marks
            for /f "tokens=1-2 delims=," %%x in ("!header!") do (
                for /f "tokens=2 delims==" %%w in ("%%x") do set "weighting=%%w"
                for /f "tokens=2 delims==" %%o in ("%%y") do set "outof=%%o"
            )
            
            :: Find student's mark in the assessment
            for /f "usebackq skip=1 tokens=1* delims=," %%x in ("!assessFile!") do (
                if "%%x"=="!name!" (
                    set "mark=%%y"
                )
            )
            
            :: Calculate weighted mark if mark exists
            if defined mark (
                :: Calculate raw percentage
                set /a "rawPercent = (mark * 100) / outof"
                
                :: Build assessment details string
                set "assessmentDetails=!assessmentDetails! [!assessName!: !rawPercent!%%]"
                
                :: Calculate weighted contribution with scaling
                set /a "scaled = (mark * weighting * 100) / outof"
                
                :: Add to totals
                set /a "totalScaled += scaled"
                set /a "totalWeight += weighting"
            )
        )
        

        if !totalWeight! gtr 0 (
            set /a "courseAverage = totalScaled / totalWeight"
            set "record=!record! !assessmentDetails! [Total: !courseAverage!%%]"
        )
    )
    

    echo !name!,!record!>>"%tempFile%"
)


move /y "%tempFile%" "%students%" >nul

cls
echo ╔═══════════════════════════════════════════════╗
echo ║        STUDENT GRADES UPDATED SUCCESSFULLY    ║
echo ╚═══════════════════════════════════════════════╝
echo.
echo Course: %course%
echo Students processed:
echo.
type "%students%"
echo.
echo Press any key to return to menu...
pause >nul
exit 