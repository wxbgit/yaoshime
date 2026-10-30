@echo off
setlocal
rem Windows env vars are case-insensitive: having both http_proxy and HTTP_PROXY
rem makes MSBuild's ProcessStartInfo throw. Clear the upper-case variants.
set HTTP_PROXY=
set HTTPS_PROXY=
set ALL_PROXY=
set http_proxy=
set https_proxy=
set all_proxy=
set NO_PROXY=
set no_proxy=

call "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul 2>&1
cd /d C:\yaoshime
"C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\MSBuild\Current\Bin\MSBuild.exe" yaoshime.sln /t:Build /p:Configuration=Release /p:Platform=x64 /m /v:minimal /fl /flp:logfile=C:\yaoshime\build_x64.log;verbosity=normal
echo MSBUILD_EXIT=%errorlevel%
