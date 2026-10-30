@echo off
setlocal
set HTTP_PROXY=
set HTTPS_PROXY=
set http_proxy=
set https_proxy=
cd /d C:\yaoshime\output
"C:\yaoshime\deps\nsis\nsis-3.11\makensis.exe" /DWEASEL_VERSION=1.0.1 /DWEASEL_BUILD=0 /DPRODUCT_VERSION=1.0.1.0 install.nsi
echo MAKENSIS_EXIT=%errorlevel%
