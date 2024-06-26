rem TODO: Check uniqueness of filename
rem TODO: Log of process
rem TODO: Make sure the required commands are present
rem TODO: Recurse directories

cls
@echo off

echo This is an archiver script for batch archiving and cataloguing of floppies
echo Copyright Jason Chalom 2024 v0.1
echo.

strings today=date
strings now=time
set timestamp=%today%, %now%
echo The date is %timestamp%
echo.

echo Static Paths

rem Settings for turning on and off functionality and paths
set ARCHIVER_PATH=C:\ARCHIVER\

rem IMD
set IMD_PATH=C:\DISK_T~1\IMD120
set IMD_EXECUTABLE=%IMD_PATH%\IMD.COM

set MKD_PATH=%ARCHIVER_PATH%\MKD.EXE
set CP_PATH=%ARCHIVER_PATH%\CP.EXE
set LS_PATH=%ARCHIVER_PATH%\LS.EXE
set ANY2IMD_PATH=%IMD_PATH%\ANY2IMD.COM
set NAVDX_PATH=%ARCHIVER_PATH%\NAVDX.EXE
set DI_PATH=%ARCHIVER_PATH%\DI.exe
set MD5_PATH=%ARCHIVER_PATH%\MD5.EXE

echo ARCHIVER_PATH: %ARCHIVER_PATH%
echo IMD_PATH: %IMD_PATH%
echo IMD_EXECUTABLE: %IMD_EXECUTABLE%
echo MKD_PATH: %MKD_PATH%
echo CP_PATH: %CP_PATH%
echo LS_PATH: %LS_PATH%
echo ANY2IMD_PATH: %ANY2IMD_PATH%
echo NAVDX_PATH: %NAVDX_PATH%
echo DI_PATH: %DI_PATH%
echo MD5_PATH: %MD5_PATH%
echo.

pause

rem Add in parameters
set base_path=%1
if "%1"=="" goto USAGE
echo Base Path: %base_path%

rem Archive Logic
rem ------------------------------------------------------------------- rem
rem Ask for disk name
strings drive_letter=ask Enter Drive Letter to Archive (e.g. A or B): '
set source_path=%drive_letter%:\
set drive_path=%drive_letter%:

strings diskname=ask Enter Disk Name: '
strings comment=ask Enter Disk Comments: '
strings disk_size=ask Enter Disk Size (360 720 1.2 1.44): '

rem Calculate Archive Path (Enter in folder \)
set archive_path=%base_path%%diskname%

rem Print out computed paths
echo Computed Paths
echo source_path: %source_path%
echo diskname: %diskname%
echo comment: %comment%
echo disk_size: %disk_size%
echo.

rem IMD clone
echo %timestamp% > %archive_path%\%diskname%.txt
echo %disk_size% >> %archive_path%\%diskname%.txt
echo %comment% >> %archive_path%\%diskname%.txt

rem Generate INI file for ANY2IMD
echo RE=%IMD_EXECUTABLE% /K /H /%drive_letter% D=%archive_path%\ CP=4 > %archive_path%\%diskname%.ini
echo RS=R%diskname%~EN%comment%~ES~EN >> %archive_path%\%diskname%.ini
echo FD=0,24 >> %archive_path%\%diskname%.ini
echo WE=type >> %archive_path%\%diskname%.ini

copy %archive_path%\%diskname%.ini %ARCHIVER_PATH%
copy %archive_path%\%diskname%.ini %IMD_PATH%
%ANY2IMD_PATH% %archive_path%\%diskname%.txt /P /I%diskname%

rem Check Boot sector for viruses + all files
%NAVDX_PATH% %source_path% /A /B+ /M+ /ZIPS /DOALLFILES > %archive_path%\nav_virus_scan.txt

rem Image disk using another tool
%DI_PATH% %drive_path% %archive_path%\%diskname%.img

rem Calculate File List (DIR)
DIR %source_path% > %archive_path%\dir_list.txt
DIR %source_path% /s /b /a > %archive_path%\dir_list_full.txt
ATTRIB /S > %archive_path%\attrib_list.txt

rem Calculate File List (LS)
%LS_PATH% -a -R -l %source_path% > %archive_path%\ls_list.txt

rem Calculate MD5 of all files
echo Source Listing Path: %source_path%*.*

rem md5 can take in inf parameters
rem md5 %source_path%*.* > %archive_path%\md5.txt"
rem ls -a -R %source_path%
for %%f in (%source_path%*.*) do %MD5_PATH% %%f > %archive_path%\md5_orig.txt

rem Copy Files
%MKD_PATH% -p %archive_path%\files
%CP_PATH% -rvf %source_path%* %archive_path%\files

rem Recalculate MD5 from archive path
for %%f in (%archive_path%\files\*.*) do %MD5_PATH% %%f > %archive_path%\md5_copy.txt

goto END

:USAGE
rem echo Usage: archive.bat BaseSavePath DriveLetter
echo Usage: archive.bat BaseSavePath
goto END

:END
echo Done!
