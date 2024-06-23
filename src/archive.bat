@echo off
cls

echo This is an archiver script for batch archiving and cataloguing of floppies
echo Copyright Jason Chalom 2024 v0.1
echo.

rem Add in parameters
set base_path=%1
set drive_letter=%2

echo "TEST: %*"
echo %*
echo [%]

if "%1"=="" goto USAGE
if "%2"=="" goto USAGE

rem :loop
rem goto loop
rem :end

:ARCHIVE_DISK
rem Ask for disk name

rem TODO: Check uniqueness of filename

rem Calculate Archive Path
set archive_path="%base_path%"

rem Calculate File List (DIR)
rem Calculate File List (LS)
rem Calculate MD5

rem TODO: Check Boot sector for viruses

:USAGE
echo Usage: archive.bat BaseSavePath DriveLetter
rem exit /B 1

:END
echo Done!
rem exit /B 0
