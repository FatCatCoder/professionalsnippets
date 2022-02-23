@echo off
set pathf=.\wwwroot\index.html
for /f tokens^=2delims^="/" %%a in ('FIND "<base" %pathf%') do set "substr=%%a"
echo %substr%

for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a
echo Network IP: %NetworkIP%

IF %1.==ipad GOTO ipadsettings
ELSE GOTO localsettings
@echo on

ipadsettings:
dotnet watch run --urls https://%NetworkIP%:80 --pathbase=/%substr% --launch-profile ipad

localsettings:
dotnet watch run --pathbase=/%substr%