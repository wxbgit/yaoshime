@echo off
setlocal
set HTTP_PROXY=
set HTTPS_PROXY=
set http_proxy=
set https_proxy=
cd /d C:\yaoshime\output
"C:\yaoshime\deps\nsis\nsis-3.11\makensis.exe" /DWEASEL_VERSION=0.17.4 /DWEASEL_BUILD=1 /DPRODUCT_VERSION=0.17.4.1 install.nsi
echo MAKENSIS_EXIT=%errorlevel%
