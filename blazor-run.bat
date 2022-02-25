@echo off
set arg1=%1
set pathf=.\wwwroot\index.html

for /f tokens^=2delims^="/" %%a in ('FIND "<base" %pathf%') do set "substr=%%a"
Rem echo %substr%

for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a
Rem echo Network IP: %NetworkIP%

:parse
IF "%~1"=="" GOTO localsettings
IF "%~1"=="ipad" GOTO ipadsettings
REM IF %arg1%==ipad GOTO ipadsettings
GOTO parse
@echo on

:ipadsettings
dotnet watch run --urls https://%NetworkIP%:80 --pathbase=/%substr% --launch-profile ipad

:localsettings
dotnet watch run --pathbase=/%substr%