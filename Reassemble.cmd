@echo off
setlocal
title Reassemble TorchUMM
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Reassemble.ps1"
set "torchumm_result=%ERRORLEVEL%"
echo.
pause
exit /b %torchumm_result%
