@echo off
REM Build a single-file installer that bundles current output\ artifacts
REM plus the user's configuration (%APPDATA%\Yaoshime).
setlocal
set HTTP_PROXY=
set HTTPS_PROXY=
set http_proxy=
set https_proxy=
cd /d "%~dp0"

echo [1/3] Staging user config ...
set STAGE=output\userdata
if exist "%STAGE%" rmdir /s /q "%STAGE%"
mkdir "%STAGE%"
robocopy "%APPDATA%\Yaoshime" "%STAGE%" /E /XD build /NFL /NDL /NJH /NJS /NP >nul
if errorlevel 8 (
  echo robocopy failed.
  pause
  exit /b 1
)

echo [2/3] Compiling installer ...
cd output
"C:\yaoshime\deps\nsis\nsis-3.11\makensis.exe" /DWEASEL_VERSION=1.0.0 /DWEASEL_BUILD=0 /DPRODUCT_VERSION=1.0.0.0 install_bundle.nsi
set RC=%errorlevel%
cd ..
echo MAKENSIS_EXIT=%RC%

echo [3/3] Output: output\archives\yaoshime-bundle.exe
pause
