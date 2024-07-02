rem TODO: Check uniqueness of filename
rem TODO: Log of process
rem TODO: Make sure the required commands are present
rem TODO: Conversions
rem TODO: UNIX2DOS
rem TODO: DOCUMENT TYPE DETECTION


cls
@echo off

echo This is an archiver script for batch archiving and cataloguing of floppies
echo Copyright Jason Chalom 2024 v0.5
echo.

strings today=date
strings now=time
set timestamp=%today%, %now%
echo The date is %timestamp%
echo.

set base_path=%1
if "%1"=="" goto USAGE

pause

echo Static Paths

rem Settings for turning on and off functionality and paths
set ARCHIVER_PATH=C:\ARCHIVER

rem IMD
set IMD_PATH=C:\DISK_T~1\IMD120
set IMD_EXECUTABLE=%IMD_PATH%\IMD.COM

set MKD_PATH=%ARCHIVER_PATH%\MKD.EXE
set CP_PATH=%ARCHIVER_PATH%\CP.EXE
set LS_PATH=%ARCHIVER_PATH%\LS.EXE
set ANY2IMD_PATH=%IMD_PATH%\ANY2IMD.COM
set NAVDX_PATH=%ARCHIVER_PATH%\NAVDX.EXE
set MD5_PATH=%ARCHIVER_PATH%\MD5.EXE
set DSK_PATH=%ARCHIVER_PATH%\DSKIMAGE.COM
set REL_PATH=%ARCHIVER_PATH%\REL.EXE
set DSKIMAGE_RETRIES=10

echo ARCHIVER_PATH: %ARCHIVER_PATH%
echo IMD_PATH: %IMD_PATH%
echo IMD_EXECUTABLE: %IMD_EXECUTABLE%
echo MKD_PATH: %MKD_PATH%
echo CP_PATH: %CP_PATH%
echo LS_PATH: %LS_PATH%
echo ANY2IMD_PATH: %ANY2IMD_PATH%
echo NAVDX_PATH: %NAVDX_PATH%
echo MD5_PATH: %MD5_PATH%
echo DSK_PATH: %DSK_PATH%
echo DSKIMAGE_RETRIES: %DSKIMAGE_RETRIES%
echo REL_PATH: %REL_PATH%
echo.

pause

rem Add in parameters
echo Base Path: %base_path%

rem Archive Logic
rem ------------------------------------------------------------------- rem
rem Ask for disk name
strings drive_letter=ask Enter Drive Letter to Archive (e.g. A or B): 
set source_path=%drive_letter%:\
set drive_path=%drive_letter%:

if "%drive_letter%"=="A" set drive_number=0
if "%drive_letter%"=="a" set drive_number=0
if "%drive_letter%"=="B" set drive_number=1
if "%drive_letter%"=="b" set drive_number=2

strings diskname=ask Enter Disk Name: 
strings comment=ask Enter Disk Comments: 
strings disk_size=ask Enter Disk Size (360 720 1.2 1.44): 

rem tracks - 80 for everything except 360k
set tracks=80
if "%disk_size%"=="360" set tracks=40

rem Heads - All disks Im working with have 2 heads
set heads=2

rem Sectors
set sectors=""
if "%disk_size%"=="360" set sectors=9
if "%disk_size%"=="720" set sectors=9
if "%disk_size%"=="1.2" set sectors=15
if "%disk_size%"=="1.44" set sectors=18

if %sectors%=="" goto WRONG_DISK_TYPE

set bios_drive=%drive_number%:%tracks%:%heads%:%sectors%

rem Calculate Archive Path (Enter in folder \)
set archive_path=%base_path%%diskname%

rem Print out computed paths
echo Settings
echo source_path: %source_path%
echo drive_path: %drive_path%
echo drive_letter: %drive_letter%
echo archive_path: %archive_path%
echo diskname: %diskname%
echo comment: %comment%
echo disk_size: %disk_size%
echo bios_drive: %bios_drive%
echo.
pause

%MKD_PATH% -p %archive_path%

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

rem Image disk using another tool
echo RE=%DSK_PATH% %bios_drive% %archive_path%\%diskname%.img > %archive_path%\%diskname%d.ini
echo RS=~EN~WA5000;~EN >> %archive_path%\%diskname%d.ini
echo FD=0,24 >> %archive_path%\%diskname%d.ini
echo WE=type >> %archive_path%\%diskname%d.ini

copy %archive_path%\%diskname%d.ini %ARCHIVER_PATH%
copy %archive_path%\%diskname%d.ini %IMD_PATH%
%ANY2IMD_PATH% %archive_path%\%diskname%d.ini /P /I%diskname%d

echo Virus Scan Disk
rem Check Boot sector for viruses + all files
%NAVDX_PATH% %source_path% /A /B+ /M+ /ZIPS /DOALLFILES > %archive_path%\nav_virus_scan.txt

rem Calculate File List (DIR)
DIR %source_path% > %archive_path%\dir_list.txt
DIR %source_path% /s /b /a > %archive_path%\dir_list_full.txt
ATTRIB /S > %archive_path%\attrib_list.txt

rem Calculate File List (LS)
%LS_PATH% -a -R -l %drive_path% > %archive_path%\ls_list.txt

rem Calculate MD5 of all files
echo MD5 Source Listing Path: %source_path%
echo md5_files: %archive_path%\rel.txt

rem md5 can take in inf parameters
%REL_PATH% /r %source_path% > %archive_path%\rel.txt
strings md5_files=read %archive_path%\rel.txt,1
for %%f in (%md5_files%) do %MD5_PATH% %%f >> %archive_path%\md5_orig.txt

rem Copy Files
%MKD_PATH% -p %archive_path%\files
%CP_PATH% -prvf %source_path%* %archive_path%\files

rem Recalculate MD5 from archive path
%REL_PATH% /r %archive_path%\files\ > %archive_path%\rel_cp.txt
strings md5_copy=read %archive_path%\rel_cp.txt,1
for %%f in (%md5_copy%) do %MD5_PATH% %%f >> %archive_path%\md5_copy.txt

%MKD_PATH% -p %archive_path%\conv
CONV.BAT %archive_path%\files\ %archive_path%\conv\

goto END

:WRONG_DISK_TYPE
echo.
echo Valid Disk Types: 360, 720, 1.2, 1.44 ... stopping.
goto END

:USAGE
echo.
rem echo Usage: archive.bat BaseSavePath DriveLetter
echo Usage: archive.bat BaseSavePath
goto END

:END
echo Done!
