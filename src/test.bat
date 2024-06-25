@echo off

rem set current_path=%cd%
strings current_path=cd
echo BOB: %current_path%

pause

rem for %%f in (c:\dos\autokey\*.*) do md5 %%f > %archive_path%\md5.txt


rem for /f "delims=" %%a in ('md5.exe %source_path%\*.*') do echo %%a > %archive_path%\md5.txt
rem for /r %i in (*) do echo %i
rem for %%f in ('%source_path%\*.*') do md5 %%f > %archive_path%\md5.txt

rem set filelist=c:\dos\autokey\*.*
rem set filelistnew=%filelist:ls=%
rem set filelistnested=dir /b /a

rem echo list: %filelist%
rem echo test: %filelistnew%
rem echo nested: %filelistnested%

rem for %%f in (%filelistnested%) do echo %%f > c:\tmp\text.txt
rem for %%f in (%filelistnested%) do md5 %%f > c:\tmp\md5_text.txt

rem for %%f in (dir /b /a c:\dos\autokey) do md5 %%f > c:\tmp\md5_text.txt


rem set FileList=

rem for /f "delims=" %%f in ('dir c:\dos\autokey\*.* /s 2^>nul') do (
rem   set FileList=%FileList% %%f
rem )

rem for %%f in (c:\dos\autokey\*.*)

rem FOR /F "tokens=* USEBACKQ" %%F IN (`dir c:\dos\autokey\*.* /s /b /a`) DO (
rem SET var=%%F
rem )


rem for %%f in (dir c:\dos\autokey\*.* /s /b /a') do echo %%f
rem echo VAR: %var%

rem for %%f in (c:\dos\autokey\*.* /s /b /a') do dir %%f


rem rem echo %FileList%
rem for %%f in (%FileList%) do md5 %%f > c:\tmp\md5_text.txt


rem TYPE "C:\tmp\autotest\dir_list_full.txt" | echo &1

rem for %%f in ('c:\dos\autokey\*.*') do (
rem   rem set FileList=%FileList% %%f
rem   echo %%f
rem )

rem @echo on
rem dir c:\dos\autokey\*.* /s /b /a | md5
rem dir c:\dos\autokey\*.* /s /b /a

rem ls -a -R c:\dos\autokey\

rem for /f "tokens=*" %%F in ('dir /b *.* /s 2^>nul') do @echo %%F
