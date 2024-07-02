cls
@echo off

echo This is a converter script for batch conversion of old DOS files
echo Copyright Jason Chalom 2024 v0.1
echo.

strings today=date
strings now=time
set timestamp=%today%, %now%
echo The date is %timestamp%
echo.

set source_files_path=%1
if "%1"=="" goto USAGE

set base_save_path=%2
if "%2"=="" goto USAGE

pause

echo Static Paths
set MKD_PATH=%ARCHIVER_PATH%\MKD.EXE
set CV_PATH=C:\CV20\CV.EXE
set REL_PATH=%ARCHIVER_PATH%\REL.EXE

%MKD_PATH% -p %base_save_path%

%REL_PATH% /r %source_files_path% > %source_files_path%\rel_cp.txt
strings files=read %source_files_path%\rel_cp.txt,1
for %%f in (%files%) do %CV_PATH% %%f %%f.RTF RTF

:USAGE
echo.
rem echo Usage: converter.bat SourceFilesPath BaseSavePath
echo Usage: converter.bat SourceFilesPath BaseSavePath
goto END

:END
echo Done!
