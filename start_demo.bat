@echo off
rem ASCII-only launcher: all Chinese messages live in wall_agent\launch_demo.py
rem so that the cmd codepage cannot corrupt them.
cd /d "%~dp0"
rem Enable the local temporary-key channel by default; set 0 to disable.
set "WALLAGENT_ALLOW_CLIENT_KEY=1"
set "PYEXE=runtime\python\python.exe"
if not exist "%PYEXE%" set "PYEXE=.venv\Scripts\python.exe"
if not exist "%PYEXE%" set "PYEXE=python"
"%PYEXE%" -X utf8 wall_agent\launch_demo.py %*
echo.
echo (demo stopped)
pause
