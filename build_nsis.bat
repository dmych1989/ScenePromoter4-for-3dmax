@echo off
REM ===========================================================================
REM  编译 场景助手 安装包 (NSIS)
REM  使用前请先安装 NSIS: https://nsis.sourceforge.io  (安装时会加入 PATH)
REM  用法: 双击本文件，或命令行执行 build_nsis.bat
REM ===========================================================================
setlocal

set "MAKENSIS="
where makensis >nul 2>&1 && set "MAKENSIS=makensis"
if not defined MAKENSIS (
  if exist "%ProgramFiles(x86)%\NSIS\makensis.exe" set "MAKENSIS=%ProgramFiles(x86)%\NSIS\makensis.exe"
)
if not defined MAKENSIS (
  if exist "%ProgramFiles%\NSIS\makensis.exe" set "MAKENSIS=%ProgramFiles%\NSIS\makensis.exe"
)
if not defined MAKENSIS (
  echo [错误] 未找到 makensis.exe。请先安装 NSIS (https://nsis.sourceforge.io) 并确认其已加入 PATH。
  pause
  exit /b 1
)

if not exist dist mkdir dist

REM 自动生成图标（gif -> ico，NSIS Icon 只认 ico）
if not exist "images\logo.ico" (
  echo [信息] 正在从 images\logo.gif 生成 images\logo.ico...
  python "build_icon.py" 2>nul
  if errorlevel 1 (
    python3 "build_icon.py" 2>nul
    if errorlevel 1 (
      echo [错误] 无法生成 images\logo.ico。请确保已安装 Python 与 Pillow，或手动准备 images\logo.ico。
      pause
      exit /b 1
    )
  )
)

echo [信息] 正在编译安装包...
"%MAKENSIS%" installer.nsi
if errorlevel 1 (
  echo [错误] 编译失败。
  pause
  exit /b 1
)

echo [完成] 已生成 dist\场景助手4_3_0.exe
endlocal
