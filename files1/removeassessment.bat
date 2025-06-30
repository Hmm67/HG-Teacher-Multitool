@echo off
title Remove Assessment
mode 120,40
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "students=students.txt"
set "coursePath=courses"
set "tempFile=students_temp.txt"

:retry
cls
echo [38;2;255;255;220m╔ Enter course name (e.g. Legal Studies):
echo ║
set /p "course=%BS%╚════>"
if not defined course goto retry

set "folder=%coursePath%\%course%"
if not exist "%folder%" (
    echo.
    echo [Error] Course not found!
    pause
    goto retry
)

:listAssessments
cls
echo [38;2;255;255;220m╔ Assessments for course "%course%":


set count=0
for %%f in ("%folder%\*.txt") do (
    set /a count+=1
    echo ║- %%~nf
)

if !count! equ 0 (
    echo ║
    echo ║ No assessments found in this course.
    echo ║
    echo ╚═══════════════════════════════════════════════
    pause
    goto retry
)


echo ╠═══════════════════════════════════════════════
echo ║
echo ╠══ Enter assessment name to remove:
echo ║
set /p "assess=%BS%╚════>"
if not defined assess goto listAssessments

set "assessFile=%folder%\%assess%.txt"
if not exist "%assessFile%" (
    echo.
    echo [Error] Assessment not found: "%assess%"
    pause
    goto listAssessments
)

echo.
echo ╔═══════════════════════════════════════════════╗
echo ║          CONFIRM ASSESSMENT REMOVAL           ║
echo ╠═══════════════════════════════════════════════╣
echo ║ Course:    %course%                           
echo ║ Assessment: %assess%                          
echo ║                                               ║
echo ║ This will:                                    ║
echo ║   - Permanently delete the assessment file    ║
echo ║   - Remove assessment from student records    ║
echo ║   - Recalculate course grades                 ║
echo ╚═══════════════════════════════════════════════╝
echo.
choice /m "Are you sure you want to delete it"

if errorlevel 2 (
    echo.
    echo Operation cancelled.
    pause
    goto listAssessments
)


del "%assessFile%"
echo.
echo Assessment file removed.


echo Removing assessment from student records...
copy NUL "%tempFile%" >nul


for /f "usebackq tokens=1* delims=," %%a in ("%students%") do (
    set "name=%%a"
    set "record=%%b"
    

    for /f "delims=[" %%c in ("!record!") do set "cleanRecord=%%c"
    

    echo !name!,!cleanRecord!>>"%tempFile%"
)


move /y "%tempFile%" "%students%" >nul
echo Student records cleaned.


echo Recalculating course grades...
call :UpdateCourseGrades "%course%"

echo.
echo Assessment "%assess%" completely removed from "%course%".
echo.

choice /m "Remove another assessment"

if errorlevel 2 (
    exit
)

goto retry

:UpdateCourseGrades
setlocal
set "course=%~1"

:: Create temporary file
set "ug_tempFile=%temp%\%random%.txt"
copy NUL "%ug_tempFile%" >nul

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
                
                :: Calculate weighted contribution
                set /a "scaled = (mark * weighting * 100) / outof"
                
                :: Add to totals
                set /a "totalScaled += scaled"
                set /a "totalWeight += weighting"
            )
        )
        
        :: Calculate overall percentage
        if !totalWeight! gtr 0 (
            set /a "courseAverage = totalScaled / totalWeight"
            set "record=!record! !assessmentDetails! [Total: !courseAverage!%%]"
        )
    )
    

    echo !name!,!record!>>"%ug_tempFile%"
)


move /y "%ug_tempFile%" "%students%" >nul

echo Grades recalculated for %course%.
endlocal
goto :eof