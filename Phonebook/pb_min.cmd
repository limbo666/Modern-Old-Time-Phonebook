@echo off
if not defined MINIMIZED (
    set MINIMIZED=1
    start "" /min cmd /c "%~dpnx0" %*
    exit
)

set "BASE_DIR=%~dp0"
start "" conhost.exe powershell -NoProfile -ExecutionPolicy Bypass -File "%BASE_DIR%pb.ps1" -m %*
exit