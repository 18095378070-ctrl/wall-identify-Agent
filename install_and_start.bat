@echo off
rem Launcher: use the bundled runtime if present, otherwise build a .venv.
rem ASCII-only launcher: all Chinese messages live in wall_agent\launch_demo.py
rem so that the cmd codepage cannot corrupt them.
cd /d "%~dp0"
set "WALLAGENT_ALLOW_CLIENT_KEY=1"

if exist "runtime\python\python.exe" (
    "runtime\python\python.exe" -X utf8 wall_agent\launch_demo.py %*
    goto stopped
)

if not exist ".venv\Scripts\python.exe" (
    echo Bundled runtime missing. Creating virtual environment .venv ...
    python -m venv .venv
)
if not exist ".venv\Scripts\python.exe" (
    echo [ERROR] Could not create .venv. Install Python 3.11 or 3.12 64-bit first.
    pause
    exit /b 1
)

echo Installing dependencies from requirements.txt ...
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] Dependency installation failed. Check your network and retry.
    pause
    exit /b 1
)

".venv\Scripts\python.exe" -X utf8 wall_agent\launch_demo.py %*

:stopped
echo.
echo (demo stopped)
pause
