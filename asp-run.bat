@echo off
set pathf=.\wwwroot\index.html

for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a
Rem echo Network IP: %NetworkIP%

IF %1.==ipad GOTO ipadsettings
ELSE GOTO localsettings
@echo on

:ipadsettings
dotnet watch run --urls https://%NetworkIP%:443 --launch-profile ipad

:localsettings
dotnet watch run --urls https://%NetworkIP%:443 