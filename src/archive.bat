@echo off
cls

echo This is an archiver script for batch archiving and cataloguing of floppies
echo Copyright Jason Chalom 2024 v0.1
echo.

strings today=date
strings now=time
set timestamp=%today%, %now%
echo The date is %timestamp%

rem Settings for turning on and off functionality and paths
set ARCHIVER_PATH=C:\ARCHIVER

rem CLAMAV + SigTool
rem FULL_VIRUS_SCAN

rem IMD
set IMD_PATH=C:\DOS\IMD120\

rem GNU
rem Setup Paths

rem Add in parameters
set base_path=%1
if "%1"=="" goto USAGE

goto loop

:loop
goto ARCHIVE_DISK
strings CONTINUE=ask Do You Want To Archive Another Disk?
IF "%CONTINUE%" NEQ "Y" GOTO END
IF "%CONTINUE%" NEQ "y" GOTO END
rem goto loop
GOTO END

:ARCHIVE_DISK
rem Ask for disk name
strings drive_letter=ask Enter Drive Letter to Archive (e.g. A or B): '
set source_path=%drive_letter%:

strings diskname=ask Enter Disk Name: '
strings comment=ask Enter Disk Comments: '
strings disk_size=ask Enter Disk Size (360 720 1.2 1.44): '

rem TODO: Check uniqueness of filename
rem TODO: Log of process
rem TODO: Make sure the required commands are present
rem TODO: Recurse directories

rem Calculate Archive Path (Enter in folder \)
set archive_path=%base_path%%diskname%
MKD -p %archive_path%

rem IMD clone
echo %timestamp% > %archive_path%\%diskname%.txt
echo %disk_size% >> %archive_path%\%diskname%.txt
echo %comment% >> %archive_path%\%diskname%.txt

rem Generate INI file for ANY2IMD
echo RE=%IMD_PATH%\IMD.COM /K /H /%drive_letter% D=%archive_path%\ CP=4 > %archive_path%\%diskname%.ini
echo RS=R%diskname%~EN%comment%~ES~EN >> %archive_path%\%diskname%.ini
echo FD=0,24 >> %archive_path%\%diskname%.ini
echo WE=type >> %archive_path%\%diskname%.ini

copy  %archive_path%\%diskname%.ini %ARCHIVER_PATH%
copy  %archive_path%\%diskname%.ini %IMD_PATH%
%IMD_PATH%\ANY2IMD.COM %archive_path%\%diskname%.txt /P /I%diskname%

rem Virus scanning
rem Check files for viruses
rem clamscan --tempdir=C:\Freedos\temp* --database=FILE or DIR** --recursive --move=c:\virus*** c:\
rem clamscan --tempdir=C:\Freedos\temp --database=c:\util\clamav\main.cvd --recursive --move =c:\virus c:\
rem clamscan --tempdir=C:\temp --database=c:\clamav\main.cvd --recursive a:\

rem Check Boot sector for viruses + all files
%ARCHIVER_PATH%\NAVDX.EXE %source_path% /A /B+ /M+ /ZIPS /DOALLFILES > %archive_path%\nav_virus_scan.txt

rem DD Clone
rem "DD if=%source_path% of=%archive_path%\%diskname%.img conv=noerror,sync"
%ARCHIVER_PATH%\DI.exe

rem Calculate File List (DIR)
DIR %source_path% > %archive_path%\dir_list.txt
DIR %source_path% /s /b /a > %archive_path%\dir_list_full.txt
ATTRIB /S > %archive_path%\attrib_list.txt

rem Calculate File List (LS)
%ARCHIVER_PATH%\ls -a -R -l %source_path% > %archive_path%\ls_list.txt

rem Calculate MD5 of all files
echo Source Listing Path: %source_path%*.*

rem md5 can take in inf parameters
rem md5 %source_path%*.* > %archive_path%\md5.txt"

rem ls -a -R %source_path%
for %%f in (%source_path%*.*) do %ARCHIVER_PATH%\MD5.EXE %%f > %archive_path%\md5_orig.txt

rem ClamAV Tooling
rem set filelist=ls %source_path%\*.*
rem sigtool --md5 %filelist%  %archive_path%\md5_sigtool.txt"

rem Copy Files
%ARCHIVER_PATH%\MKD -p %archive_path%\files
%ARCHIVER_PATH%\CP -rvf %source_path%* %archive_path%\files

rem Recalculate MD5 from archive path
for %%f in (%archive_path%\files\*.*) do %ARCHIVER_PATH%\MD5.EXE %%f > %archive_path%\md5_copy.txt

goto END

:USAGE
rem echo Usage: archive.bat BaseSavePath DriveLetter
echo Usage: archive.bat BaseSavePath
goto END

:END
echo Done!
rem exit /B 0
