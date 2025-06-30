@echo off
title HG Teacher MultiTool - Instructions
mode 120,40
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo [38;2;255;255;220mThe password is "ADMIN" (This can be updated in the "Settings" section)
echo.
echo This multitool can be used to mark a roll, view and edit a schedule, add students to a course, add assessments for a course, grade assessments for a course, and calculate the total weighted grade for that student which is displayed in a table from highest to lowest.
echo.
echo ---------------------------------------------------------------------------------------------------------------------------------
echo To Use:
echo First add students to a course by navigating to the "Edit students" section. (Students --> Edit students --> Add a course)
echo Provide the course name (e.g. ENC), and list all students in that course in the format required.
echo You can remove students, remove courses, and add students to a course from this same section.
echo.
echo To add an assessment navigate to the assessments section. (Assessments --> Add Assessment)
echo Provide the course name (Must be the same as entered before), the name of the assessment, the weighting, and the marks it is out of.
echo.
echo To grade the assessment go to "Grade Assessment" in the same section. Enter the course name, the assessment, and then the marks each student achieved, inputting "DNP" to skip any student that didn't partake in the task.
echo If any of the information is incorrect or needs to be changed, remove the assessment or grade it again. Marks are only final once you update the grades.
echo.
echo To update the grades go to the "Update Grades" section. Enter the course name and the assessment name that has been marked. This will update the student information with the results. If this information is incorrect, removing the assessment will remove it from the calculation so you can mark it again.
echo.
echo To view a list of students and their grades, navigate back to the "View students" section (Students --> View Students). Enter the course name and a list of students in that course with their total calculated grade will appear in descending order from highest to lowest grade.
echo.
echo To view the individual results for each assessment task, this can be seen in the "Update Grades" section, or navigate to the "Courses" directory in the files, where the results will be shown in a text document.
echo.
echo ---------------------------------------------------------------------------------------------------------------------------------
echo Additional Features:
echo.
echo Mark Roll: Enter the course name and enter Y or N for whether each student is present. Past rolls can be viewed from the "Settings" section (Settings --> View Previous Rolls)
echo.
echo Schedule: Enter the periods you have for each day and then view them with "View Schedule". Can be updated at any time.
echo.
echo SEQTA: A shortcut that will open up SEQTA in your default browser so you can quickly check information.
echo.
echo Feedback: Submit a feedback form if you encounter any bugs, have any criticisms, or general improvements or additional features.
echo.
echo ---------------------------------------------------------------------------------------------------------------------------------
echo.
echo Created by Ben FB


echo.
pause
exit
