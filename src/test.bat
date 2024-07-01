@echo off

rem set current_path=%cd%
rem strings current_path=cd
rem echo BOB: %current_path%

pause

rem set files_list=rel.exe d:\*.*
rel.exe d:\ > test.tmp
strings files_list=read test.tmp,1
for %%f in (%files_list%) do c:\md5.exe %source_path%%%f
