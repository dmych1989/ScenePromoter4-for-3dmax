--场景助手4.1.00
--场景助手初始化

--字符乱码，by SITT
(DotNetClass "System.Windows.Forms.Application").CurrentCulture = dotnetObject "System.Globalization.CultureInfo" "zh-cn"

filein (getdir #scripts+"\\ScenePromoter4\\CGplusplusFunc.ms")
filein (getdir #scripts+"\\ScenePromoter4\\SPMainRollout.ms")
filein (getdir #scripts+"\\ScenePromoter4\\ScenePromoter.ms")
filein (getdir #scripts+"\\ScenePromoter4\\ScenePromotermcr.ms")
if ScenePromoter4Rol!=undefined and ScenePromoter4Rol.open then (
		try cui.UnRegisterDialogBar  ScenePromoter4Rol catch ( )	
		destroydialog ScenePromoter4Rol 
	)
else()
CGplusplusFunc.closeToolbar()
--工具栏自动启动
spShowtoolbar=execute (getinisetting spInifilepath "Main" "Toolbar")
spDockState=execute (getinisetting spInifilepath "Main" "DockState")
if spShowtoolbar then CGplusplusFunc.createToolbar() else ()
--主界面自动启动
spMainUIauto=getinisetting spInifilepath "Main" "Mainuiauto"
if spMainUIauto=="1" then CGplusplusFunc.dockMainRlt thetype:spDockState else ()
--标题栏自动启用
autoPerTitile=getinisetting spInifilepath "Main" "PerTitOpen"
if autoPerTitile=="1" then SPmyPersTitle.switchTitle state:true else ()