@echo off
rem ============================================================
rem  Yaoshime one-click build + package script
rem  All external dependencies live under %~dp0deps\
rem  No network access required.
rem ============================================================
setlocal enabledelayedexpansion
set HTTP_PROXY=
set HTTPS_PROXY=
set ALL_PROXY=
set http_proxy=
set https_proxy=
set all_proxy=
set NO_PROXY=
set no_proxy=

cd /d "%~dp0"
set ROOT=%~dp0
set ROOT=%ROOT:~0,-1%
set DEPS=%ROOT%\deps
set PY=C:\Users\Administrator\.workbuddy\binaries\python\envs\default\Scripts\python.exe
set MSBUILD="C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
set NSIS=%DEPS%\nsis\nsis-3.11\makensis.exe
set VERSION_MAJOR_=0
set VERSION_MINOR_=17
set VERSION_PATCH_=4
set BUILD_=1

echo [1/6] Checking dependencies ...
for %%D in ("%DEPS%\boost-1.86.0" "%DEPS%\rime_x64\lib\rime.lib" "%DEPS%\rime_x86\lib\rime.lib" "%DEPS%\data-snapshot" ) do (
  if not exist %%D (
    echo   ERROR: missing %%D
    exit /b 1
  )
)
if not exist "%NSIS%" (
  echo   WARN: NSIS not found at %NSIS% - will build binaries only
)

echo [2/6] Restoring data files if missing ...
if not exist "%ROOT%\output\data\default.yaml" (
  xcopy /E /I /Y /Q "%DEPS%\data-snapshot" "%ROOT%\output\data" >nul
  echo   restored output\data from deps\data-snapshot
)
if not exist "%ROOT%\output\data\opencc\t2s.json" (
  xcopy /E /I /Y /Q "%DEPS%\data-snapshot\opencc" "%ROOT%\output\data\opencc" >nul
  echo   restored opencc data
)

echo [3/6] Placing rime runtime and headers ...
copy /Y "%DEPS%\rime_x64\lib\rime.dll" "%ROOT%\output\" >nul
copy /Y "%DEPS%\rime_x64\lib\rime.lib" "%ROOT%\lib64\" >nul
if not exist "%ROOT%\output\Win32" mkdir "%ROOT%\output\Win32"
copy /Y "%DEPS%\rime_x86\lib\rime.dll" "%ROOT%\output\Win32\" >nul
copy /Y "%DEPS%\rime_x86\lib\rime.lib" "%ROOT%\lib\" >nul
for %%H in (rime_api.h rime_api_deprecated.h rime_api_stdbool.h rime_levers_api.h) do (
  if not exist "%ROOT%\librime\include\%%H" copy /Y "%DEPS%\rime_x64\include\%%H" "%ROOT%\librime\include\" >nul
)

echo [4/6] Rendering weasel.props ...
if not exist "%ROOT%\weasel.props" (
  if exist "%PY%" (
    "%PY%" "%ROOT%\_render_props.py"
  ) else (
    echo   ERROR: python not found, cannot render weasel.props
    exit /b 1
  )
)

echo [5/6] Building x64 and Win32 ...
call "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul 2>&1
%MSBUILD% yaoshime.sln /t:Build /p:Configuration=Release /p:Platform=x64 /m /v:minimal
if errorlevel 1 (echo   ERROR: x64 build failed & exit /b 1)
call "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars32.bat" >nul 2>&1
%MSBUILD% yaoshime.sln /t:Build /p:Configuration=Release /p:Platform=Win32 /m /v:minimal
if errorlevel 1 (echo   ERROR: Win32 build failed & exit /b 1)

echo [6/6] Packaging with NSIS ...
copy /Y "%ROOT%\LICENSE.txt" "%ROOT%\output\" >nul
copy /Y "%ROOT%\README.md" "%ROOT%\output\README.txt" >nul
copy /Y "%ROOT%\plum\rime-install.bat" "%ROOT%\output\" >nul
if not exist "%NSIS%" (
  echo   SKIP: NSIS missing, installer not generated
  goto done
)
pushd "%ROOT%\output"
"%NSIS%" /DWEASEL_VERSION=1.0.0 /DWEASEL_BUILD=0 /DPRODUCT_VERSION=1.0.0.0 install.nsi
set RC=%errorlevel%
popd
if not "%RC%"=="0" (echo   ERROR: makensis failed & exit /b 1)

:done
echo.
echo ============================================================
echo  DONE
dir /b "%ROOT%\output\archives\*.exe" 2>nul
echo ============================================================
