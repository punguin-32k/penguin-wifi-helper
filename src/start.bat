@echo off
cd /d %~dp0

if exist "bin\build.vbs" (
    cscript //nologo "bin\build.vbs"

    del /f /q "bin\build.vbs"
)

start conhost bin\lua54.exe lua\start_helper.lua
exit
