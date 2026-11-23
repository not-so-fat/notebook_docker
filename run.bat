@echo off
setlocal
if "%~1"=="" (
    echo Usage: %~nx0 PORT 1>&2
    exit /b 1
)

set "PORT=%~1"
docker run --rm -p "127.0.0.1:%PORT%:8888" -v "%CD%:/home/neo/notebook_workspace" my_notebook:0.0
