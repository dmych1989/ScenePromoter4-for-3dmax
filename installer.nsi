; ============================================================================
;  场景助手 4.3.0 安装脚本 (NSIS)
; ----------------------------------------------------------------------------
;  与原版 场景助手4_1_1.exe 同款：Nullsoft 安装系统制作的向导式安装包
;  （非自解压）。安装逻辑还原为「原版式本地解包」：
;    1. 向导让用户选择安装目录（默认 = 本安装包所在目录 $EXEDIR）
;    2. 将插件解压到 <安装目录>\Scripts\ 下：
;         <安装目录>\Scripts\ScenePromoter4\   （主脚本 + Lib/Help/images）
;         <安装目录>\Scripts\Startup\SP4_startup.ms
;    3. 用户自行将该 Scripts 目录指给 3ds Max（或在 Max 中设置脚本路径）。
;
;  说明：原版 4.1.1 不扫描/不写入真实 3ds Max 目录，仅做本地解包；
;        本脚本保持这一行为，不做任何注册表扫描或自动复制。
;
;  构建：安装 NSIS (https://nsis.sourceforge.io) 后运行 build_nsis.bat
; ============================================================================

; ---- 强制 Unicode 编译（中文不乱码的关键）----
; 不加此指令时 NSIS 默认 ANSI，UTF-8 中文会被当 GBK 字节存储，运行时乱码。
; 本机 NSIS 自带 x86-unicode 的插件与 Stubs，加此指令可正确编译为 Unicode 安装包。
Unicode true

!include "MUI2.nsh"
!include "LogicLib.nsh"

; ---- 基本信息 ----
Name "场景助手 4.3.0"
OutFile "dist\场景助手4_3_0.exe"
; 默认安装目录 = 本安装包所在目录（还原原版：双击即解压到同目录 Scripts）
InstallDir "$EXEDIR"
Icon "images\logo.ico"
UninstallIcon "images\logo.ico"
RequestExecutionLevel user        ; 本地解包到用户目录，无需管理员/UAC
SetCompressor /SOLID lzma
CRCCheck on
XPStyle on

; ---- MUI 界面 ----
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TEXT "场景助手 4.3.0 安装向导$\r$\n$\r$\n本向导将把场景助手解压到你所选的目录下的 Scripts\ 文件夹中。$\r$\n解压后请将该 Scripts 目录加入到 3ds Max 的脚本路径，或在 Max 中手动加载。$\r$\n$\r$\n作者：山医命相卜   QQ群：756653752"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "SimpChinese"

; ============================================================================
;  安装逻辑：把插件树按原版结构解压到 <安装目录>\Scripts\
; ============================================================================
Section "安装场景助手" SEC_INSTALL
  SetOutPath "$INSTDIR\Scripts\ScenePromoter4"
  File "ScenePromoter.ms"
  File "SPMainRollout.ms"
  File "ScenePromoter4.ini"
  File "ScenePromotermcr.ms"
  File "CGplusplusFunc.ms"
  File /r "Lib"
  File /r "Help"
  File /r "images"

  SetOutPath "$INSTDIR\Scripts\Startup"
  File "SP4_startup.ms"

  ; 卸载入口（卸载器放在安装目录，便于整体清理）
  WriteUninstaller "$INSTDIR\uninstall.exe"

  ; 控制面板卸载信息
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "DisplayName" "场景助手 4.3.0"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "DisplayIcon" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "Publisher" "山医命相卜"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "DisplayVersion" "4.3.0"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "InstallLocation" "$INSTDIR"
SectionEnd

; ============================================================================
;  卸载
; ============================================================================
Section "Uninstall"
  RMDir /r "$INSTDIR\Scripts"
  Delete "$INSTDIR\uninstall.exe"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4"
  RMDir "$INSTDIR"
SectionEnd
