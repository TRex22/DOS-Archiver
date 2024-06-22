@echo off
cls

echo This is an archiver script to archive floppy in batch
echo Copyright Jason Chalom 2024 v0.1
echo.

set "BaseSavePath=%1"
set "DriveLetter=%2"

if "%1%2" equ "" (
    echo Usage: archive.bat BaseSavePath DriveLetter
    goto END
)

if NOT defined %1 (
    echo Error: BaseSavePath is missing
    goto END
)

if NOT defined %2 (
    echo Error: DriveLetter is missing
    goto END
)

rem if NOT "!BaseSavePath:" == "%BaseSavePath!" (
rem     echo Error: BaseSavePath is invalid
rem     goto END
rem )

if NOT "%DriveLetter:~0,1" in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) (
    echo Error: DriveLetter is invalid
    goto END
)

rem set /p outer_archive_path="Enter Base Archive Path: "


rem This is the component which is looped

rem Use IMD via AUTOKEY to archive the given path


rem Use ls to generate file list
ls -lh

rem Use DD to try and generate an IMG from a given drive path

:END
echo Done!
rem exit /B 0
