; ============================================================================
;  场景助手 4.3.0 安装脚本 (NSIS)
; ----------------------------------------------------------------------------
;  与原版 场景助手4_1_1.exe 同款：Nullsoft 安装系统制作的向导式安装包
;  （非自解压）。安装逻辑：
;    1. 从注册表扫描本机所有已装的 3ds Max 版本（同时查 64/32 位视图）
;    2. 在安装向导中以勾选框列出，用户勾选要安装到哪些版本（默认全选）
;    3. 将插件复制到 <Max>\scripts\ScenePromoter4\，并将 SP4_startup.ms
;       复制到 <Max>\scripts\Startup\。3ds Max 启动时会自动加载 Startup
;       下的 SP4_startup.ms，再 filein 各主脚本。
;
;  构建：安装 NSIS (https://nsis.sourceforge.io) 后运行 build_nsis.bat
; ============================================================================

!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "StrFunc.nsh"
!include "nsDialogs.nsh"
${StrTok}    ; 初始化字符串分词函数

; ---- 基本信息 ----
Name "场景助手 4.3.0"
OutFile "dist\场景助手4_3_0.exe"
InstallDir "$LOCALAPPDATA\ScenePromoter4"
RequestExecutionLevel admin        ; 写 3ds Max 脚本目录(多在 Program Files)需要管理员
SetCompressor /SOLID lzma
CRCCheck on
XPStyle on

; ---- MUI 界面 ----
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TEXT "场景助手 4.3.0 安装向导$\r$\n$\r$\n本向导将把场景助手安装到你选择的 3ds Max 版本中。$\r$\n作者：山医命相卜   QQ群：756653752"
!insertmacro MUI_PAGE_WELCOME
Page custom PageSelectMax PageSelectMaxLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "SimpChinese"

; ---- 变量 ----
Var Dialog
Var count            ; 检测到的 Max 版本数
Var detectedNames    ; "|" 分隔的显示名
Var detectedPaths    ; "|" 分隔的安装目录(已规范化为结尾反斜杠)
Var hwndList         ; 空格分隔的复选框 HWND(整数)
Var selPaths         ; "|" 分隔的已选安装目录
Var manualHWND       ; 手动路径文本框句柄
Var manualPath       ; 手动路径文本

; ============================================================================
;  注册表枚举：找出本机所有 3ds Max 安装目录
; ============================================================================
Function EnumMax
  StrCpy $count 0
  StrCpy $detectedNames ""
  StrCpy $detectedPaths ""
  SetRegView 64
  Call EnumOneView
  SetRegView 32
  Call EnumOneView
  SetRegView 64
FunctionEnd

Function EnumOneView
  Push $4   ; 枚举索引
  Push $5   ; 版本子键名 (如 "24.0")
  Push $6   ; Installdir 值
  Push $7   ; 末字符(用于规范化)
  Push $9   ; 显示名
  Push $R2  ; 去重用：是否已存在
  Push $R3  ; 去重用：索引
  Push $R4  ; 去重用：已存路径

  StrCpy $4 0
  ${Do}
    EnumRegKey $5 HKLM "SOFTWARE\Autodesk\3dsMax" $4
    ${If} $5 == ""
      ${ExitDo}
    ${EndIf}
    ReadRegStr $6 HKLM "SOFTWARE\Autodesk\3dsMax\$5" "Installdir"
    ${If} $6 != ""
      ; 规范化：确保结尾反斜杠
      StrCpy $7 $6 "" -1
      ${If} $7 != "\"
        StrCpy $6 "$6\"
      ${EndIf}
      ; 去重（64/32 视图可能重复列出同一版本）
      StrCpy $R2 0
      StrCpy $R3 0
      ${Do}
        ${If} $R3 >= $count
          ${ExitDo}
        ${EndIf}
        IntOp $R4 $R3 + 1
        ${StrTok} $R4 $detectedPaths "|" $R4 "+"
        ${If} $R4 == $6
          StrCpy $R2 1
          ${ExitDo}
        ${EndIf}
        IntOp $R3 $R3 + 1
      ${Loop}
      ${If} $R2 == 1
        ; 已存在，跳过
      ${Else}
        StrCpy $9 "3ds Max v$5"
        StrCpy $detectedNames "$detectedNames$9|"
        StrCpy $detectedPaths "$detectedPaths$6|"
        IntOp $count $count + 1
      ${EndIf}
    ${EndIf}
    IntOp $4 $4 + 1
  ${Loop}

  Pop $R4
  Pop $R3
  Pop $R2
  Pop $9
  Pop $7
  Pop $6
  Pop $5
  Pop $4
FunctionEnd

; ============================================================================
;  自定义页面：勾选要安装的 3ds Max 版本 + 手动指定路径
; ============================================================================
Function PageSelectMax
  nsDialogs::Create 1018
  Pop $Dialog
  ${If} $Dialog == error
    Abort
  ${EndIf}

  ${If} $count == 0
    Call EnumMax
  ${EndIf}

  ${If} $count > 0
    ${NSD_CreateLabel} 0 0 100% 12u "检测到以下 3ds Max 版本，请勾选要安装到的版本（默认全选）："
  ${Else}
    ${NSD_CreateLabel} 0 0 100% 24u "未检测到已安装的 3ds Max（注册表中无 Autodesk\3dsMax 项）。$\r$\n如已安装，请用下方输入框手动指定其安装目录。"
  ${EndIf}
  Pop $0

  ; 生成复选框
  StrCpy $hwndList ""
  StrCpy $R1 0
  ${Do}
    ${If} $R1 >= $count
      ${ExitDo}
    ${EndIf}
    IntOp $R3 $R1 + 1
    ${StrTok} $R4 $detectedNames "|" $R3 "+"
    ${StrTok} $R5 $detectedPaths "|" $R3 "+"
    IntOp $R6 $R1 * 15
    IntOp $R6 $R6 + 16
    ${NSD_CreateCheckbox} 12u $R6 95% 14u $R4
    Pop $R7
    ${NSD_Check} $R7
    StrCpy $hwndList "$hwndList$R7 "
    IntOp $R1 $R1 + 1
  ${Loop}

  ; 手动指定路径
  IntOp $R6 $count * 15
  IntOp $R6 $R6 + 24
  ${NSD_CreateLabel} 0 $R6 100% 12u "未列出？手动指定 3ds Max 安装目录："
  Pop $0
  IntOp $R6 $R6 + 14
  ${NSD_CreateText} 0 $R6 80% 13u ""
  Pop $manualHWND
  ${NSD_CreateButton} 82% $R6 17% 13u "浏览..."
  Pop $0
  ${NSD_OnClick} $0 OnBrowse

  nsDialogs::Show
FunctionEnd

Function OnBrowse
  nsDialogs::SelectFolderDialog "选择 3ds Max 安装目录" ""
  Pop $0
  ${If} $0 != error
    ${NSD_SetText} $manualHWND $0
  ${EndIf}
FunctionEnd

Function PageSelectMaxLeave
  StrCpy $selPaths ""
  StrCpy $R1 0
  ${Do}
    ${If} $R1 >= $count
      ${ExitDo}
    ${EndIf}
    IntOp $R3 $R1 + 1
    ${StrTok} $R5 $detectedPaths "|" $R3 "+"
    ${StrTok} $R6 $hwndList " " $R3 "+"
    ${NSD_GetState} $R6 $R7
    ${If} $R7 == 1
      StrCpy $selPaths "$selPaths$R5|"
    ${EndIf}
    IntOp $R1 $R1 + 1
  ${Loop}

  ; 手动路径
  ${NSD_GetText} $manualHWND $manualPath
  ${If} $manualPath != ""
    StrCpy $R7 $manualPath "" -1
    ${If} $R7 != "\"
      StrCpy $manualPath "$manualPath\"
    ${EndIf}
    StrCpy $selPaths "$selPaths$manualPath|"
  ${EndIf}

  ${If} $selPaths == ""
    MessageBox MB_OK|MB_ICONEXCLAMATION "请至少勾选一个 3ds Max 版本，或在下方手动指定安装目录。"
    Abort
  ${EndIf}
FunctionEnd

; ============================================================================
;  安装逻辑
; ============================================================================
Function InstallToMax
  ; $R5 = 3ds Max 安装目录(结尾反斜杠)
  SetOutPath "$R5scripts\ScenePromoter4"
  File "ScenePromoter.ms"
  File "SPMainRollout.ms"
  File "ScenePromoter4.ini"
  File "ScenePromotermcr.ms"
  File "CGplusplusFunc.ms"
  File /r "Lib"
  File /r "Help"
  File /r "images"
  SetOutPath "$R5scripts\Startup"
  File "SP4_startup.ms"
FunctionEnd

Section "安装场景助手" SEC_INSTALL
  SetOutPath "$INSTDIR"
  WriteUninstaller "$INSTDIR\uninstall.exe"

  ; 控制面板卸载信息
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "DisplayName" "场景助手 4.3.0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "DisplayIcon" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "Publisher" "山医命相卜"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4" "DisplayVersion" "4.3.0"

  ; 记录已安装的 Max 目录(编号)，供卸载使用 —— 不用 StrTok，避免卸载段上下文问题
  StrCpy $R2 0
  StrCpy $R1 0
  ${Do}
    ${If} $R1 >= $count
      ${ExitDo}
    ${EndIf}
    IntOp $R3 $R1 + 1
    ${StrTok} $R5 $selPaths "|" $R3 "+"
    ${If} $R5 != ""
      WriteRegStr HKLM "Software\ScenePromoter4" "Path$R2" "$R5"
      IntOp $R2 $R2 + 1
      Call InstallToMax
    ${EndIf}
    IntOp $R1 $R1 + 1
  ${Loop}
  WriteRegStr HKLM "Software\ScenePromoter4" "Count" "$R2"
SectionEnd

; ============================================================================
;  卸载
; ============================================================================
Section "Uninstall"
  ReadRegStr $R2 HKLM "Software\ScenePromoter4" "Count"
  ${If} $R2 == ""
    StrCpy $R2 0
  ${EndIf}
  StrCpy $R1 0
  ${Do}
    ${If} $R1 >= $R2
      ${ExitDo}
    ${EndIf}
    ReadRegStr $R6 HKLM "Software\ScenePromoter4" "Path$R1"
    ${If} $R6 != ""
      RMDir /r "$R6scripts\ScenePromoter4"
      Delete "$R6scripts\Startup\SP4_startup.ms"
    ${EndIf}
    IntOp $R1 $R1 + 1
  ${Loop}

  DeleteRegKey HKLM "Software\ScenePromoter4"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\ScenePromoter4"
  Delete "$INSTDIR\uninstall.exe"
  RMDir "$INSTDIR"
SectionEnd
