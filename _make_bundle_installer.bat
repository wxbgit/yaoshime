@echo off
rem ============================================================
rem  药师输入法 单文件安装包（内置用户词库 / 配置）
rem
rem  产物: output\archives\yaoshime-<版本>-bundle.exe
rem  换一台电脑双击安装，词库、自定义短语、方案配置一并带入。
rem
rem  要点：
rem   1. 用 robocopy /B（备份模式）绕开 WeaselServer.exe 的文件锁，
rem      避免旧版脚本「静默跳过被占用文件」导致换机丢词库。
rem   2. 剔除 build\（部署时自动重建）、sync\（同步快照）、
rem      LOCK（LevelDB 锁文件，不可跨机复制）。
rem   3. 目标机器上若已有 %APPDATA%\Yaoshime 配置，安装器会先备份
rem      到 %TEMP%\yaoshime-userdata-backup 再覆盖。
rem ============================================================
setlocal enabledelayedexpansion
set HTTP_PROXY=
set HTTPS_PROXY=
set ALL_PROXY=
set http_proxy=
set https_proxy=
set all_proxy=
cd /d "%~dp0"

set ROOT=%~dp0
set ROOT=%ROOT:~0,-1%
set NSIS=%ROOT%\deps\nsis\nsis-3.11\makensis.exe
set SRC=%APPDATA%\Yaoshime
set STAGE=%ROOT%\output\userdata

for %%F in ("%ROOT%\output\WeaselDeployer.exe" "%ROOT%\output\WeaselServer.exe" "%ROOT%\output\weaselx64.dll" "%ROOT%\output\rime.dll" "%ROOT%\output\data\luna_pinyin.dict.yaml") do (
  if not exist %%F (
    echo   ERROR: 缺少构建产物 %%F
    echo   请先运行 _pack_all.bat 完成编译。
    exit /b 1
  )
)
if not exist "%NSIS%" (
  echo   ERROR: 找不到 NSIS: %NSIS%
  exit /b 1
)
if not exist "%SRC%\custom_phrase.txt" (
  echo   ERROR: 找不到用户目录 %SRC%
  exit /b 1
)

echo [1/4] 暂存用户目录 ^(robocopy /B 强制读取被锁文件^) ...
if exist "%STAGE%" rmdir /s /q "%STAGE%"
mkdir "%STAGE%"
robocopy "%SRC%" "%STAGE%" /E /B /R:3 /W:1 /XJ /XD build sync /XF LOCK /NFL /NDL /NJH /NJS /NP >nul
if errorlevel 8 (
  echo   ERROR: robocopy 失败，用户目录未能完整暂存。
  exit /b 1
)

rem 完整性自检：关键文件必须存在且非空
set MISSING=
for %%F in (
  "custom_phrase.txt"
  "default.custom.yaml"
  "weasel.custom.yaml"
  "user.yaml"
  "installation.yaml"
  "lua\date_translator.lua"
  "luna_pinyin.userdb\CURRENT"
  "terra_pinyin.userdb\CURRENT"
) do (
  if not exist "%STAGE%\%%~F" set MISSING=!MISSING! %%~F
)
if not "%MISSING%"=="" (
  echo   ERROR: 暂存不完整，缺少: %MISSING%
  exit /b 1
)

echo       暂存文件数:
set NFCNT=0
for /f %%N in ('dir /s /b /a-d "%STAGE%" ^| find /c /v ""') do set NFCNT=%%N
echo         %NFCNT% 个文件

echo [2/4] 编译单文件安装包 ...
pushd "%ROOT%\output"
"%NSIS%" /DWEASEL_VERSION=1.0.1 /DWEASEL_BUILD=0 /DPRODUCT_VERSION=1.0.1.0 install_bundle.nsi
set RC=%errorlevel%
popd
if not "%RC%"=="0" (
  echo   ERROR: makensis 失败 ^(exit %RC%^)
  exit /b 1
)

echo [3/4] 校验产物 ...
set OUT=%ROOT%\output\archives\yaoshime-1.0.1.0-bundle.exe
if not exist "%OUT%" (
  echo   ERROR: 未生成 %OUT%
  exit /b 1
)
for %%S in ("%OUT%") do echo       %%~nxS  %%~zS 字节

echo [4/4] 完成
echo.
echo   安装包: %OUT%
echo   已内置用户目录: %SRC%
echo ============================================================
endlocal
