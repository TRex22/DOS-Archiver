cls
@echo off

echo This is a converter script for batch conversion of old DOS files
echo Copyright Jason Chalom 2024 v0.2
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

rem Documents
echo Converting WRI Documents ...
%REL_PATH% /r /n %source_files_path% /w WRI > %base_save_path%\rel_WRI.txt
strings files=read %base_save_path%\rel_WRI.txt,1
for %%f in (%files%) do %CV_PATH% %%f.WRI %%f.RTF RTF
%MKD_PATH% -p %base_save_path%\WRI
for %%f in (%files%) do mv %%f.RTF %base_save_path%\WRI

echo Converting EPS Documents ...
%REL_PATH% /r /n %source_files_path% /w EPS > %base_save_path%\rel_EPS.txt
strings files=read %base_save_path%\rel_EPS.txt,1
for %%f in (%files%) do %CV_PATH% %%f.EPS %%f.RTF RTF
%MKD_PATH% -p %base_save_path%\EPS
for %%f in (%files%) do mv %%f.RTF %base_save_path%\EPS

echo Converting WPD Documents ...
%REL_PATH% /r /n %source_files_path% /w WPD > %base_save_path%\rel_WPD.txt
strings files=read %base_save_path%\rel_WPD.txt,1
for %%f in (%files%) do %CV_PATH% %%f.WPD %%f.RTF RTF
%MKD_PATH% -p %base_save_path%\WPD
for %%f in (%files%) do mv %%f.RTF %base_save_path%\WPD

echo Converting DOC Documents ...
%REL_PATH% /r /n %source_files_path% /w DOC > %base_save_path%\rel_DOC.txt
strings files=read %base_save_path%\rel_DOC.txt,1
for %%f in (%files%) do %CV_PATH% %%f.DOC %%f.RTF RTF
%MKD_PATH% -p %base_save_path%\DOC
for %%f in (%files%) do mv %%f.RTF %base_save_path%\DOC

echo Converting DOX Documents ...
%REL_PATH% /r /n %source_files_path% /w DOX > %base_save_path%\rel_DOX.txt
strings files=read %base_save_path%\rel_DOX.txt,1
for %%f in (%files%) do %CV_PATH% %%f.DOX %%f.RTF RTF
%MKD_PATH% -p %base_save_path%\DOX
for %%f in (%files%) do mv %%f.RTF %base_save_path%\DOX

echo Converting PAT Documents ...
%REL_PATH% /r /n %source_files_path% /w PAT > %base_save_path%\rel_PAT.txt
strings files=read %base_save_path%\rel_PAT.txt,1
for %%f in (%files%) do %CV_PATH% %%f.PAT %%f.RTF RTF
%MKD_PATH% -p %base_save_path%\PAT
for %%f in (%files%) do mv %%f.RTF %base_save_path%\PAT

rem echo Converting WS Documents ...
rem %REL_PATH% /r /n %source_files_path% /w WS > %base_save_path%\rel_WS.txt
rem strings files=read %base_save_path%\rel_WS.txt,1
rem for %%f in (%files%) do %CV_PATH% %%f.WS %%f.RTF RTF
rem %MKD_PATH% -p %base_save_path%\WS
rem for %%f in (%files%) do mv %%f.RTF %base_save_path%\WS

rem Images
echo Converting CGM Documents ...
%REL_PATH% /r /n %source_files_path% /w CGM > %base_save_path%\rel_CGM.txt
strings files=read %base_save_path%\rel_CGM.txt,1
for %%f in (%files%) do %CV_PATH% %%f.CGM %%f.BMP BMP
%MKD_PATH% -p %base_save_path%\CGM
for %%f in (%files%) do mv %%f.BMP %base_save_path%\CGM

echo Converting PICT Documents ...
%REL_PATH% /r /n %source_files_path% /w PICT > %base_save_path%\rel_PICT.txt
strings files=read %base_save_path%\rel_PICT.txt,1
for %%f in (%files%) do %CV_PATH% %%f.PICT %%f.BMP BMP
%MKD_PATH% -p %base_save_path%\PICT
for %%f in (%files%) do mv %%f.BMP %base_save_path%\PICT

echo Converting MGX Documents ...
%REL_PATH% /r /n %source_files_path% /w MGX > %base_save_path%\rel_MGX.txt
strings files=read %base_save_path%\rel_MGX.txt,1
for %%f in (%files%) do %CV_PATH% %%f.MGX %%f.BMP BMP
%MKD_PATH% -p %base_save_path%\MGX
for %%f in (%files%) do mv %%f.BMP %base_save_path%\MGX

echo Converting PCX Documents ...
%REL_PATH% /r /n %source_files_path% /w PCX > %base_save_path%\rel_PCX.txt
strings files=read %base_save_path%\rel_PCX.txt,1
for %%f in (%files%) do %CV_PATH% %%f.PCX %%f.BMP BMP
%MKD_PATH% -p %base_save_path%\PCX
for %%f in (%files%) do mv %%f.BMP %base_save_path%\PCX

echo Converting TGA Documents ...
%REL_PATH% /r /n %source_files_path% /w TGA > %base_save_path%\rel_TGA.txt
strings files=read %base_save_path%\rel_TGA.txt,1
for %%f in (%files%) do %CV_PATH% %%f.TGA %%f.BMP BMP
%MKD_PATH% -p %base_save_path%\TGA
for %%f in (%files%) do mv %%f.BMP %base_save_path%\TGA

echo Converting DXF Documents ...
%REL_PATH% /r /n %source_files_path% /w DXF > %base_save_path%\rel_DXF.txt
strings files=read %base_save_path%\rel_DXF.txt,1
for %%f in (%files%) do %CV_PATH% %%f.DXF %%f.BMP BMP
%MKD_PATH% -p %base_save_path%\DXF
for %%f in (%files%) do mv %%f.BMP %base_save_path%\DXF

rem Databases
echo Converting XLS Documents ...
%REL_PATH% /r /n %source_files_path% /w XLS > %base_save_path%\rel_XLS.txt
strings files=read %base_save_path%\rel_XLS.txt,1
for %%f in (%files%) do %CV_PATH% %%f.XLS %%f.EX40 EX40
%MKD_PATH% -p %base_save_path%\XLS
for %%f in (%files%) do mv %%f.EX40 %base_save_path%\XLS

echo Converting DAT Documents ...
%REL_PATH% /r /n %source_files_path% /w DAT > %base_save_path%\rel_DAT.txt
strings files=read %base_save_path%\rel_DAT.txt,1
for %%f in (%files%) do %CV_PATH% %%f.DAT %%f.EX40 EX40
%MKD_PATH% -p %base_save_path%\DAT
for %%f in (%files%) do mv %%f.EX40 %base_save_path%\DAT

echo Converting DBF Documents ...
%REL_PATH% /r /n %source_files_path% /w DBF > %base_save_path%\rel_DBF.txt
strings files=read %base_save_path%\rel_DBF.txt,1
for %%f in (%files%) do %CV_PATH% %%f.DBF %%f.EX40 EX40
%MKD_PATH% -p %base_save_path%\DBF
for %%f in (%files%) do mv %%f.EX40 %base_save_path%\DBF

rem TODO: DBF https://github.com/akadan47/dbf2csv

goto END

:USAGE
echo.
rem echo Usage: converter.bat SourceFilesPath BaseSavePath
echo Usage: converter.bat SourceFilesPath BaseSavePath
goto END

:END
echo Done!
