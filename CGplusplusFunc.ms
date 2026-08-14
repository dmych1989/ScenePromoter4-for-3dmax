--场景助手4.1.00

--作者：飞浪
--Author:Feilang
--www.cgplusplus.com
--------------------------------------------------
--欢迎使用场景助手4.0 

----开源奉献----

---------------------------------------------------
--场景助手4.1 	2012-02-01
--场景助手4.0		2011-04-01
--场景助手3.0		2009-08-01
--场景助手2.6		2009-03-30
--场景助手2.0		2008-08-06
--场景助手1.0		2008-05-27

global defaultMtltype=true,CGppImportMatStr,CGppImportMat,CGppFuncStruct,CGplusplusFunc,sptoolbar, \
SPmanageScripts,ScenePromoter4Rol,SPLinkHint,SPtoolbarBtn,SPlinkmanage,SPdataSync,SPabtRol, \
SPsettingMenu,SPsettingMenuTB,SPmngAddto,SPmainRolSet,SPmyPersTitle,SPmtoolbarRolSet

--配置文件
global spRootPath=getdir #scripts +"\\ScenePromoter4"
global spLibPath=spRootPath+"\\Lib"
global spInifilepath=spRootPath+"\\ScenePromoter4.ini"
global spIniCategory=spLibPath+"\\category.ini"
global spRolHeight=execute (getinisetting spInifilepath "Main" "Height")
global spRolWidth=execute (getinisetting spInifilepath "Main" "Width")
global spToolbarType=execute (getinisetting spInifilepath "Main" "Type")
global spShowtoolbar=execute (getinisetting spInifilepath "Main" "Toolbar")
global spDockState=execute (getinisetting spInifilepath "Main" "DockState")
global SPtxtcolor=(colorMan.getColor #background)*255
SPtxtcolor[2]+=100;SPtxtcolor[3]+=100

global SPToolBarHeightOffset = execute( getinisetting spInifilepath "Main" "ToolBarHeightoffset")
global SPToolBarWidthOffset = execute( getinisetting spInifilepath "Main" "ToolBarWidthoffset")

struct CGppImportMatStr 
(	--store the data of importing mat  记录导入材质数据
	allMatCt=0,
	selMatCt=0,
	missMatCt=0,
	matLibCt=0,
	sameMatCt=0
)
CGppImportMat=CGppImportMatStr()

--The functions of this scripts
--场景助手函数集
struct CGppFuncStruct
(
--minus the first array from the second
--从数组一减去数组二
fn minusArr arrAll arrExclude  =
(	local a=arrAll.count
 	local b=arrExclude.count
	for i=1 to b do
	(	
		for j=arrAll.count to 1 by -1 do
		(		
			if arrAll[j]==arrExclude[i] do deleteItem arrAll j
		)
	) 
	arrAll
),
--calculate the same items
fn sameItemNum arr =
(	
	local c,i=1,j,k
	local newArr=#(),newSameArr=#()
	sort arr					--sort the array
	while i<=arr.count do
	(	
		k=0
		j=i+1
		while j<=arr.count do
		(	
			if arr[j]==arr[i] do 
			(	
				if (findItem newSameArr arr[i])==0	do 
				(	
					append newSameArr arr[i]
						--collect the same value
				)
				append newArr j		--collect the same item
				k=k+1	
			)
			j=j+1
		) 
		i=i+k+1
	)
	--return the same item numbers and the same value
	#(newArr.count,newSameArr)	
),
fn CommaNumbers numberstring divstring:"," = 
(	numCount=numberstring.count 
	 	for i = (numCount- 3) to 1 by -3 do
	 	(	numberstring = replace numberstring i 1 (numberstring[i]+divstring)
		 )
	  	numberstring
),
fn UpperToLower str =
(	upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ" 
	lower="abcdefghijklmnopqrstuvwxyz"
	for s in 1 to str.count \
		where (idx=findstring upper str[s]) != undefined do str[s]=lower[idx]
	str
),
--convert "\" to "/"
fn slashConvert str =
(	test = true
	while test do
	(	test01=true;test02=true;test03=true;test04=true;test05=true;test06=true
		idx = findstring str "\\"
		if idx != undefined then str=substring str 1 (idx-1)+"/" +substring str (idx+1) -1 else test01=false
		idx = findstring str "\n"
		if idx != undefined then str=substring str 1 (idx-1)+"/n"+substring str (idx+1) -1 else test02=false
		idx = findstring str "\r"
		if idx != undefined then str=substring str 1 (idx-1)+"/r"+substring str (idx+1) -1 else test03=false
		idx = findstring str "\t"
		if idx != undefined then str=substring str 1 (idx-1)+"/t"+substring str (idx+1) -1 else test04=false
		idx = findstring str "\%"
		if idx != undefined then str=substring str 1 (idx-1)+"/%"+substring str (idx+1) -1 else test05=false
		test=test and (test01 or test02 or test03 or test04 or test05)
	)
	str
),
--Judge if it is VRay renderer
fn ifVRayRenderer =
(	local r=renderers.current as string
	if matchPattern r pattern:"V_ray*" then true
	else false
),
--Set default import mat
fn setdefaultMat mtlslot =
(	if defaultMtltype then
	(	if CGplusplusFunc.ifVRayRenderer() then
			meditMaterials[mtlslot] = VRayMtl name:("VRayMtl_"+mtlslot as string)
		else meditMaterials[mtlslot] = Standard name:("Standard_"+mtlslot as string)
	)
	else meditMaterials[mtlslot] = Standard name:("Standard_"+mtlslot as string)
	if defaultMatColor!=undefiend then
		meditmaterials[mtlslot].Diffuse = defaultMatColor
),
--import materials
fn importMtls mtlLibarary clicktimesV =
(			
			local tempLibNew = mtlLibarary
			local n=tempLibNew.count
			local m=24,mtlNames = #(),mtlItems=#(),tempNames=#()
			for o in 1 to n do
			(
				append mtlNames #(tempLibNew[o].name,o)
			)
			tempNames = for p in mtlNames collect (p as string)
			sort tempNames
			tempNames = for q in tempNames collect (execute q)
			tempLib = for r in tempNames collect (tempLibNew[r[2]])
			if n<m then 
			(
				for i=1 to n do meditMaterials[i]=tempLib[i]
				for i=n+1 to m do 
					setdefaultMat i
			) 
			else if n==m then
			(
				for i=1 to m do meditMaterials[i]=tempLib[i]
			)
			--if there is not enough mat slots,then the next screen
			else if n>m then
			(	timesMtl=n/m
				leaveMtl=mod n m as Integer
				if clicktimesV<timesMtl then
				(	for i=1 to m do
					meditMaterials[i]=tempLib[m*clicktimesV+i]
				)
				--import the last screen
				else if clicktimesV==timesMtl then
				(
					if leaveMtl!=0 do
					(
						for i=1 to leaveMtl do
							meditMaterials[i]=tempLib[m*clicktimesV+i]
						for i=leaveMtl+1  to m do 
							setdefaultMat i
					)
					if leaveMtl==0 do 
					(	importMtls mtlLibarary 0
					--	for i=1 to m do meditMaterials[i]=tempLib[m*clicktimesV+i]
						clicktimesV=0
					)
								
				)
				clicktimesV+=1
				--turn the mouse click listen to 0
				if clicktimesV>timesMtl do clicktimesV=0
			)
			clicktimesV 
),
--clean editor
fn cleanMedit mat =
(	MatEditor.Open()
	CGplusplusFunc.saveEptScene()
	if classof mat == material then
	(	CGppImportMat=CGppImportMatStr()
		for i in 1 to meditmaterials.count do meditmaterials[i]=mat name:(mat as string +"_"+i as string)
	)
),
--get random color
fn getRandomcolor  =
(	
	local randomcolor = random black white
	randomcolor
),
--get missing map materials
fn getMissingmapMats =
(	fn get_names name a = append a name
	local missingmapMats=#()
	for i in scenematerials do
	(	tempFN=#()	
		enumerateFiles i get_names tempFN #missing
		if tempFN.count!=0 then
			append missingmapMats i
	)
	missingmapMats
),
fn getSceneMats =
(	
	--get scene materials
	cls=#()
	cnt=#()
	for i in scenematerials do
	(
		tempCls=(classof i) as string
		idx=finditem cls tempCls
		if idx == 0 then (
			append cls tempCls
			cnt[cls.count]=1
		)
		else (
			if cnt[idx]==undefined then cnt[idx]=1
			else cnt[idx]+=1
		)
	)
	for c in 1 to cls.count do cls[c]+=":"+cnt[c] as string
	sort cls
	cls
),
--Divide Icons by rows
fn divideIcon bm tn =
(	--divide Icons, tn,total number
	obmp = openbitmap bm
	Icons=#()
	h=obmp.height
	w=obmp.width
	sw=w/tn
	for i in 1 to tn do
	(	tempbm = bitmap sw h
		p1=(i-1)*sw
		for j in 0 to h-1 do	(
			pxl = getPixels obmp [p1,j] sw --get a row of pixels
			setPixels tempbm [0,j] pxl
		)
		Icons[i]=tempbm
	)
	close obmp
	Icons
),
--Divide Icons by rows
fn divideIconBM obmp tn =
(	--divide Icons, tn,total number
	Icons=#()
	h=obmp.height
	w=obmp.width
	sw=w/tn
	for i in 1 to tn do
	(	tempbm = bitmap sw h
		p1=(i-1)*sw
		for j in 0 to h-1 do	(
			pxl = getPixels obmp [p1,j] sw --get a row of pixels
			setPixels tempbm [0,j] pxl
		)
		Icons[i]=tempbm
	)
	close obmp
	Icons
),
--Judge if the node was hidden or frozen
fn notHiddenOrFrozen obj = not (obj.isHidden or obj.isFrozen),
fn saveEptScene =
(	--refesh the materials 这是MAX的一个BUG，有时候场景中材质不会刷新，可以用这个搞定
	theFile = (GetDir #Scene + "\\feilangtool_temp.max") --define the file name
	saveNodes #() theFile --save no objects in the file
	deleteFile theFile --delete it again
),
fn msgbox str = messagebox str title:"场景助手提示" beep:off,
fn matAndObjOps idx =
(		case idx of 
			(	1: (	--选择没有材质的物体
					noMtlObjs=#()
					for i in objects where notHiddenOrFrozen i do
					(	if i.material==undefined then
							(	
								if (isKindof i geometryclass and (iskindof i targetobject)==false) then append noMtlObjs i
								else try if (isKindof i shape) then ( if i.render_renderable then  append noMtlObjs i) catch()
							)
					)
					if noMtlObjs.count != 0 then
					(	select noMtlObjs
					)
					else msgbox "没有找到符合条件的物体 ！"
				)
				2: --导入所有材质
				(	if sceneMaterials.count!=0 then (
					MatEditor.Open()
					CGppImportMat.allMatCt=CGplusplusFunc.importMtls sceneMaterials CGppImportMat.allMatCt
					)
					else msgbox "场景中没有材质！"
				)
				3: --导入选择材质
				(	selectedMtls=#()
					for i in selection do
						if i.material!=undefined then
							if  (findItem selectedMtls i.material)==0 then
								append selectedMtls i.material	--collect mat of seleted objects
					if selectedMtls.count==0 then msgbox "没有选择物体或选择物体没有材质！"
					else	
					(	MatEditor.Open()
						CGppImportMat.selMatCt=CGplusplusFunc.importMtls selectedMtls CGppImportMat.selMatCt
					)
				)
				4:  --导入同名材质
				(
					allMtls=for i in sceneMaterials  collect i.name	
					theSameMtls=(CGplusplusFunc.sameItemNum allMtls)[2]
					m=theSameMtls.count
					if m==0 then msgbox "没有同名材质！"
					else
					(	MatEditor.Open()
						tempMtlLib=#()
						for i=1 to m do
							for j in sceneMaterials do
								if j.name==theSameMtls[i] then
										append tempMtlLib j
					CGppImportMat.sameMatCt=CGplusplusFunc.importMtls tempMtlLib  CGppImportMat.sameMatCt
					)
				)
				5: --导入材质库材质
				(	if currentMaterialLibrary.count!= 0 then 
					(	MatEditor.Open()	
						CGppImportMat.matLibCt=CGplusplusFunc.importMtls currentMaterialLibrary CGppImportMat.matLibCt
					)
					else 
					(	fileOpenMatLib()
						if currentMaterialLibrary.count != 0 then 
						(	MatEditor.Open()
							CGppImportMat.matLibCt=CGplusplusFunc.importMtls currentMaterialLibrary CGppImportMat.matLibCt
						)
					)
				)
				6: (	--导入丢失材质
					CGplusplusFunc.saveEptScene()
					missmapmats=CGplusplusFunc.getMissingmapMats()
					if missmapmats.count==0 then
						msgbox "场景中没有丢失贴图的材质！"
					else 
					(	MatEditor.Open()
						CGppImportMat.missMatCt=CGplusplusFunc.importMtls missmapmats CGppImportMat.missMatCt
					)
				)
				default : OK
			)
),
--生成快捷方式
fn createLink file =
(	tempfile=CGplusplusFunc.SlashConvert file
	txt=getfilenamefile tempfile
	tempstr="SP_"+bit.intasHex (genclassID returnValue:true)[1]
	str="macroScript "+tempstr+" category:\"FeilangTools\" "
	str+="tooltip:\""+txt+"\" buttontext:\""+txt+"\"\n"
	str+="(\ntry filein \""+tempfile+"\"\n catch messagebox \"打开 "+tempfile+" 出错!\\n请确定原脚本是否存在,或者原脚本是否能正常运行!\" title:\"场景助手提示\"\n)"
	
	thefile=getdir #ui+"\\macroscripts\\FeilangTools-"+tempstr+".mcr"
	ff=createfile thefile
	format "--场景助手自动创建快捷方式\n--%\n%\n" localtime str to:ff
	close ff
	filein thefile
)
,
--更改标题栏图标,for 3dmax 2008 and higher
-- fn changeTitleIcon rol file =
-- (	--rol为rollout变量，file为图标的完整路径，图标为ico格式图片
-- 	d = (windows.getChildHWND 0 rol.title)[1]
-- 	WM_SETICON = 0x0080
-- 	ICON_SMALL = 0
-- 	icon = dotnetobject "System.Drawing.Icon" file
-- 	windows.SendMessage d WM_SETICON ICON_SMALL icon.handle
-- ),
--界面操作
fn refeshUIs =
(	--刷新所有 UI
	if ScenePromoter4Rol.open  then ScenePromoter4Rol.resetUI ScenePromoter4Rol.listId
	if sptoolbar.open then CGplusplusFunc.createToolbar thetype:spToolbarType
	if SPmanageScripts.open then SPmanageScripts.refeshList SPmanageScripts.num
),
--UI操作 4.1更新

--图标背景色
fn changeBackColor sourceBmp col =
(
	tempBmp = bitmap sourceBmp.width sourceBmp.height
	copy sourceBmp tempBmp
	for y in 0 to tempBmp.height-1 do
	(
		pxls = getPixels tempBmp [0,y] tempBmp.width
		tempCol =  (col - 60.0 * (y)/(tempBmp.height-1))
		for p in 1 to pxls.count do
		(	
			tempCol01 = pxls[p]*pxls[p].alpha/255. + tempCol * (255-pxls[p].alpha)/255.
			setPixels tempBmp [p-1,y] #(tempCol01)
		)
	)
	tempBmp
),
--导航栏背景色
fn changeNavBG col =
(
	bgBmp = bitmap 200 20 color:col
	for y in 0 to 19 do
	(
		clrs = for i in 1 to 200 collect (col - 60.0 * (19-y)/20)
		setPixels bgBmp [0,19-y] clrs
	)
	bgBmp
),
--获取配色方案
fn getUIcol = 
(
	spUIColors=#()
	idx = getinisetting spInifilepath "Color" "Index"
	if idx == "0" then
	(
		--链接字
		spUIColors[1] = color 155 200 122
		--背景色
		spUIColors[2] = color 32 32 45
		--文本颜色
		spUIColors[3] = color 200 192 122
		--导航底色
		spUIColors[4] = color 67 67 78
	)
	else 
	(
		colstr = getinisetting spInifilepath "Color" ("Color"+idx)
		cols = filterString colstr "|"
		if cols.count == 12 then
			for i in 1 to 4 do 
			(	
				j = 1 + 3 * ( i - 1 )
				spUIcolors[i] = color (cols[j] as float) (cols[j+1] as float) (cols[j+2] as float)
			)
		else 
		(	
			setinisetting spInifilepath "Color" "Index" "0"
			CGplusplusFunc.getUIcol()
		)
	)
	spUIColors
)
,
--创建主界面
fn createMainRlt =
(	spRolHeight=execute (getinisetting spInifilepath "Main" "Height")
	spRolWidth=execute (getinisetting spInifilepath "Main" "Width")
	if ScenePromoter4Rol!=undefined and ScenePromoter4Rol.open then (
		thepos=getinisetting spInifilepath "Main" "Pos"
		try cui.UnRegisterDialogBar  ScenePromoter4Rol catch ()
		try cui.UnRegisterDialogBar  ScenePromoter4Rol catch ()
		destroydialog ScenePromoter4Rol
		setinisetting spInifilepath "Main" "Pos" thepos
	) 
	else	(
		thepos=execute (getinisetting spInifilepath "Main" "Pos")
		cols = CGplusplusFunc.getUIcol()
		createDialog ScenePromoter4Rol pos:thepos width:spRolWidth height:spRolHeight \
		style:#(#style_titlebar, #style_border, #style_sysmenu,#style_resizing)  \
		bitmap:(CGplusplusFunc.changeNavBG cols[4]) \
		bmpstyle:#bmp_tile
		--iconfile = spRootPath+ "\\images\\cgpp.ico"
		--if doesfileexist iconfile then CGplusplusFunc.changeTitleIcon ScenePromoter4Rol iconfile
	)
),
--重启主界面
fn restartMainRlt =
(	spRolHeight=execute (getinisetting spInifilepath "Main" "Height")
	spRolWidth=execute (getinisetting spInifilepath "Main" "Width")
	if ScenePromoter4Rol!=undefined and ScenePromoter4Rol.open then (
		thepos=getinisetting spInifilepath "Main" "Pos"
		try cui.UnRegisterDialogBar  ScenePromoter4Rol catch ( )	
		try cui.UnRegisterDialogBar  ScenePromoter4Rol catch ()
		destroydialog ScenePromoter4Rol
		setinisetting spInifilepath "Main" "Pos" thepos
	) 
	else ()
		filein (getdir #scripts+"\\ScenePromoter4\\SPMainRollout.ms")
		thepos=execute (getinisetting spInifilepath "Main" "Pos")
		cols = CGplusplusFunc.getUIcol()
		createDialog ScenePromoter4Rol pos:thepos width:spRolWidth height:spRolHeight \
		style:#(#style_titlebar, #style_border, #style_sysmenu,#style_resizing)  \
		bitmap:(CGplusplusFunc.changeNavBG cols[4]) \
		bmpstyle:#bmp_tile
		--iconfile = spRootPath+ "\\images\\cgpp.ico"
		--if doesfileexist iconfile then CGplusplusFunc.changeTitleIcon ScenePromoter4Rol iconfile

),
fn getDockHeight type:undefined =
(	--获取停靠左边或者右边的高度
	global GetTollbarHeight
	r=rolloutCreator "GetTollbarHeight" "正在创建主界面..."
	r.begin()
	createdialog (r.end()) style:#(#style_titlebar, #style_border, #style_sysmenu,#style_toolwindow)
	cui.RegisterDialogBar GetTollbarHeight maxSize:[200,sysInfo.desktopSize[2]] style:#(#cui_dock_vert, #cui_floatable, #cui_handles)
	case type of
	(	#left : cui.DockDialogBar GetTollbarHeight #cui_dock_left
		default : cui.DockDialogBar GetTollbarHeight #cui_dock_right
	)
	h=GetTollbarHeight.height
	cui.UnRegisterDialogBar  GetTollbarHeight
	destroydialog GetTollbarHeight
	h
),
fn getDockWidth type:#top =
(	--获取停靠上边或者下边的宽度
	global GetTollbarWidth
	r=rolloutCreator "GetTollbarWidth" "正在创建工具栏..."
	r.begin()
	createdialog (r.end()) style:#(#style_titlebar, #style_border, #style_sysmenu,#style_toolwindow)
	cui.RegisterDialogBar GetTollbarWidth style:#(#cui_dock_horz, #cui_floatable, #cui_handles,#cui_max_sized)
	case type of
	(	#top : cui.DockDialogBar GetTollbarWidth #cui_dock_top
		default : cui.DockDialogBar GetTollbarWidth #cui_dock_bottom
	)		
	w=GetTollbarWidth.width
	cui.UnRegisterDialogBar  GetTollbarWidth
	destroydialog GetTollbarWidth
	w
),
--主界面停靠
fn dockMainRlt thetype:undefined =
(	
	thepos=getinisetting spInifilepath "Main" "Pos"
	try (
		cui.UnRegisterDialogBar ScenePromoter4Rol 
		)
	catch ()
	try (cui.UnRegisterDialogBar ScenePromoter4Rol)
	catch ( )

	destroydialog ScenePromoter4Rol
	dockSt=case thetype of
	(	#left: #cui_dock_left	--左
		#right: #cui_dock_right	--右
		default : undefined
	)
	setinisetting spInifilepath "Main" "DockState" ("#"+thetype as string)
	if dockSt!=undefined then (
	--	filein (getdir #scripts+"\\ScenePromoter4\\SPMainRollout.ms")
		spRolHeight=CGplusplusFunc.getDockHeight type:thetype
	--	print spRolHeight
		createDialog ScenePromoter4Rol pos:[3,80] width:spRolWidth height:spRolHeight \
		style:#(#style_titlebar, #style_border, #style_sysmenu,#style_toolwindow)  \
		bitmap:(openbitmap (spRootPath+"\\images\\cjzsbg.jpg")) \
		bmpstyle:#bmp_tile
		ScenePromoter4Rol.height+=8
		cui.RegisterDialogBar ScenePromoter4Rol style:#(dockSt, #cui_floatable, #cui_handles,#cui_max_sized)
		cui.DockDialogBar ScenePromoter4Rol dockSt
		setinisetting spInifilepath "Main" "Pos" thepos
	)
	else (
		setinisetting spInifilepath "Main" "Pos" thepos
		CGplusplusFunc.createMainRlt()
	)
),
--获取子面板相对位置,设置面板update2012-03-09
fn createChild rol width:0 =
(	mypos=[5,100]
	--s1=getinisetting spInifilepath "Main" "ChildUIPos"
	s1 = "1"
	if s1 != "0" then (
		if ScenePromoter4Rol.open then (
			global spRolWidth=execute (getinisetting spInifilepath "Main" "Width")
			thepos=execute (getinisetting spInifilepath "Main" "Pos")
			testx=thepos.x+spRolWidth+width
			if testx<sysInfo.DesktopSize.x then thepos.x+=spRolWidth+6
			else thepos.x-=width+6
			mypos=thepos
		)
	)
	createdialog rol pos:mypos fgcolor:SPtxtcolor --style:#(#style_titlebar, #style_border, #style_sysmenu,#style_toolwindow)
),
--获取脚本库中脚本的位置
fn createChildLib rol =
(
	pos0 = execute (getinisetting spInifilepath "Main" "childLibPos")
	if classof pos0 != Point2 then pos0 = [80,100]
	createdialog rol pos:pos0 fgcolor:SPtxtcolor
),
fn addBtn s files:#() =
(	--添加脚本给第s屏
	if files[1]!=undefined then case s of
	(	2: (
			olditems=getinisetting spIniCategory "S2"
			num=olditems.count
			for f in files do 
			(	num+=1
				tempf=spLibPath+"\\"+getfilenamefile f + getfilenametype f
				if not doesfileexist tempf then copyfile f tempf
				setinisetting spIniCategory "S2" ("b"+num as string) (getfilenamefile f + getfilenametype f)
			)
		)
		3: (
			olditems=getinisetting spIniCategory "S3"
			num=olditems.count
			for f in files do 
			(	num+=1
				tempf=spLibPath+"\\"+getfilenamefile f + getfilenametype f
				if not doesfileexist tempf then copyfile f tempf
				setinisetting spIniCategory "S3" ("b"+num as string) (getfilenamefile f + getfilenametype f)
			)
		)
		4: (
			olditems=getinisetting spIniCategory "S4"
			num=olditems.count
			for f in files do 
			(	num+=1
				tempf=spLibPath+"\\"+getfilenamefile f + getfilenametype f
				if not doesfileexist tempf then copyfile f tempf
				setinisetting spIniCategory "S4" ("b"+num as string) (getfilenamefile f + getfilenametype f)
			)
		)
		5: (
			olditems=getinisetting spIniCategory "S5"
			num=olditems.count
			for f in files do 
			(	num+=1
				tempf=spLibPath+"\\"+getfilenamefile f + getfilenametype f
				if not doesfileexist tempf then copyfile f tempf
				setinisetting spIniCategory "S5" ("b"+num as string) (getfilenamefile f + getfilenametype f)
			)
		)
		6: (
			olditems=getinisetting spIniCategory "S6"
			num=olditems.count
			for f in files do 
			(	num+=1
				tempf=spLibPath+"\\"+getfilenamefile f + getfilenametype f
				if not doesfileexist tempf then copyfile f tempf
				setinisetting spIniCategory "S6" ("b"+num as string) (getfilenamefile f + getfilenametype f)
			)
		)
		default : OK
	)--end case and if
	else case s of
	(	2: (
			olditems=getinisetting spIniCategory "S2"
			num=olditems.count+1
			setinisetting spIniCategory "S2" ("b"+num as string) "undefined"
		)
		3: (
			olditems=getinisetting spIniCategory "S3"
			num=olditems.count+1
			setinisetting spIniCategory "S3" ("b"+num as string) "undefined"
		)
		4: (
			olditems=getinisetting spIniCategory "S4"
			num=olditems.count+1
			setinisetting spIniCategory "S4" ("b"+num as string) "undefined"
		)
		5: (
			olditems=getinisetting spIniCategory "S5"
			num=olditems.count+1
			setinisetting spIniCategory "S5" ("b"+num as string) "undefined"
		)
		default : OK
	)
	ScenePromoter4Rol.listId=s
	CGplusplusFunc.refeshUIs()
),
fn addExe s file =
(	--添加执行文件给第s屏
	ff=CGplusplusFunc.slashConvert file
	keystr=case s of
	(	2: "S2"
		3: "S3"
		4: "S4"
		5: "S5"
		6: "S6"
		default : undefined
	)--end case
	if keystr!=undefined then
	(	filename=getfilenamefile ff 
		thestr="shellLaunch \""+ff+"\" \"\""
		thescript=spLibPath+"\\"+filename+".ms"
		spt=createFile thescript
		format "%\n" thestr to:spt
		close spt
		olditems=getinisetting spIniCategory keystr
		setinisetting spIniCategory keystr ("b"+(olditems.count+1) as string) (filename+".ms")
	)
	CGplusplusFunc.refeshUIs()
),
fn addEpt s defaulCode:false =
(	--新建脚本添加到第s屏,defaulCode如果为true,则新建的脚本会内置脚本代码,见下面代码
	i=1
	while doesfileexist (spLibPath+"\\新建脚本"+i as string +".ms") do i+=1
	iStr=i as string
	filename="新建脚本"+iStr +".ms"
	spt=createFile (spLibPath+"\\"+filename)

	if defaulCode then (
		--新建脚本内容
		theCodes="--场景助手自动创建\n--"+localtime
		theCodes+="\ntry destroydialog SPnewScript"+iStr+" catch()\n"
		theCodes+="rollout SPnewScript"+iStr+" \"新建脚本"+iStr+"\" width:150 height:50\n"
		theCodes+="(\n\tbutton btn1 \"Button\" pos:[25,11] width:100 height:26\n)\n"
		theCodes+="createdialog SPnewScript"+iStr
		format "%" theCodes to:spt
	)
	close spt
	keystr=case s of
	(	2: "S2"
		3: "S3"
		4: "S4"
		5: "S5"
		6: "S6"
		default : undefined
	)--end case
	if keystr!=undefined then (
		olditems=getinisetting spIniCategory keystr
		setinisetting spIniCategory keystr ("b"+(olditems.count+1) as string) filename
		CGplusplusFunc.refeshUIs()
	)
	else SPmanageScripts.getnohome()
),
fn delBtn s idx =
(	--删除第s屏第idx个按钮
	if s<7 then (
	keystr="S"+s as string
	oldItems=getinisetting spIniCategory keystr
	oldFiles=for i in oldItems collect (getinisetting spIniCategory keystr i)
	if idx<=oldFiles.count then (
		deleteitem oldFiles idx
		delIniSetting spIniCategory keystr
		for i in 1 to oldFiles.count do setinisetting spIniCategory keystr ("b"+i as string) oldFiles[i]
		)
	)--end if
	OK
),
fn renamebtn s idx =
(	--重命名第S屏第idx个按钮
	local renamerol
	keystr="S"+s as string
	oldItems=getinisetting spIniCategory keystr
	oldFiles=for i in oldItems collect (getinisetting spIniCategory keystr i)
	--其他屏同时修改
	items02=getinisetting spIniCategory "S2"
	files02=for i in items02 collect (getinisetting spIniCategory "S2" i)
	items03=getinisetting spIniCategory "S3"
	files03=for i in items03 collect (getinisetting spIniCategory "S3" i)
	items04=getinisetting spIniCategory "S4"
	files04=for i in items04 collect (getinisetting spIniCategory "S4" i)
	items05=getinisetting spIniCategory "S5"
	files05=for i in items05 collect (getinisetting spIniCategory "S5" i)
	items06=getinisetting spIniCategory "S6"
	files06=for i in items06 collect (getinisetting spIniCategory "S6" i)
	if idx<=oldFiles.count then (
		r=rolloutCreator "renamerol" (getfilenamefile oldFiles[idx])
		r.begin()
		r.addControl #edittext #newname "请输入新名称:"  paramStr:"width:150 height:18 pos:[3,3] labelontop:true"
		r.addControl #button #b1 "确定" paramStr:"width:50 height:18 pos:[30,44]"
		r.addControl #button #b2 "取消" paramStr:"width:50 height:18 pos:[83,44]"
		str01="test = renamefile (spLibPath+@\\\\"+oldFiles[idx]+"@)"+" (spLibPath+@\\\\@+newname.text+@"+getfilenametype oldFiles[idx]+"@)\n"
		str01+="if test then (\n"
		if (id=finditem files02 oldFiles[idx]) !=0 then
		str01+="setinisetting spIniCategory @"+"S2"+"@ @b" + id as string+"@ (newname.text+@"+getfilenametype oldFiles[idx]+"@)\n"
		if (id=finditem files03 oldFiles[idx]) !=0 then
		str01+="setinisetting spIniCategory @"+"S3"+"@ @b" + id as string+"@ (newname.text+@"+getfilenametype oldFiles[idx]+"@)\n"
		if (id=finditem files04 oldFiles[idx]) !=0 then
		str01+="setinisetting spIniCategory @"+"S4"+"@ @b" + id as string+"@ (newname.text+@"+getfilenametype oldFiles[idx]+"@)\n"
		if (id=finditem files05 oldFiles[idx]) !=0 then
		str01+="setinisetting spIniCategory @"+"S5"+"@ @b" + id as string+"@ (newname.text+@"+getfilenametype oldFiles[idx]+"@)\n"
		if (id=finditem files06 oldFiles[idx]) !=0 then
		str01+="setinisetting spIniCategory @"+"S6"+"@ @b" + id as string+"@ (newname.text+@"+getfilenametype oldFiles[idx]+"@)\n"
		str01+="CGplusplusFunc.refeshUIs()\ndestroydialog renamerol \n)--end if\nelse CGplusplusFunc.msgbox @重命名失败,何不换个名字试试?@"
		str02="destroydialog renamerol"
		r.addHandler #b1 #pressed codeStr:str01
		r.addHandler #b2 #pressed codeStr:str02
		createdialog (r.end()) style:#(#style_titlebar, #style_border, #style_sysmenu,#style_toolwindow)
	)
	OK
),
fn renamescript oldFile =
(	--重命名脚本,脚本管理-->无家可归下面 按钮使用
	local renamerol
	if doesfileexist (spLibPath+"\\"+oldFile) then (
		r=rolloutCreator "renamerol" (getfilenamefile oldFile)
		r.begin()
		r.addControl #edittext #newname "请输入新名称:"  paramStr:"width:150 height:18 pos:[3,3] labelontop:true"
		r.addControl #button #b1 "确定" paramStr:"width:50 height:18 pos:[30,44]"
		r.addControl #button #b2 "取消" paramStr:"width:50 height:18 pos:[83,44]"
		str01="test = renamefile (spLibPath+@\\\\"+oldFile+"@)"+" (spLibPath+@\\\\@+newname.text+@"+getfilenametype oldFile+"@)\n"
		str01+="if test then (\n"
		str01+="CGplusplusFunc.refeshUIs()\ndestroydialog renamerol \n)--end if\nelse CGplusplusFunc.msgbox @输入名称与现有名称重复,请重新输入!@"
		str02="destroydialog renamerol"
		r.addHandler #b1 #pressed codeStr:str01
		r.addHandler #b2 #pressed codeStr:str02
		createdialog (r.end()) style:#(#style_titlebar, #style_border, #style_sysmenu,#style_toolwindow)
	)
	OK
),
fn moveBtn s idx state:#up =
(	--脚本管理,上移,下移
	if s<7 then (
	keystr="S"+s as string
	oldItems=getinisetting spIniCategory keystr
	oldFiles=for i in oldItems collect (getinisetting spIniCategory keystr i)
	if idx<=oldFiles.count then (
		case state of
		(	#up : 
			(	if idx > 1 then (
					tempstr=oldFiles[idx]
					oldFiles[idx]=oldFiles[idx-1] --交换位置
					oldFiles[idx-1]=tempstr
					delIniSetting spIniCategory keystr
					for i in 1 to oldFiles.count do setinisetting spIniCategory keystr ("b"+i as string) oldFiles[i]
					CGplusplusFunc.refeshUIs()
				)--end if
			)--end #up
			#down : 
			(	if idx < oldFiles.count then (
					tempstr=oldFiles[idx]
					oldFiles[idx]=oldFiles[idx+1]
					oldFiles[idx+1]=tempstr
					delIniSetting spIniCategory keystr
					for i in 1 to oldFiles.count do setinisetting spIniCategory keystr ("b"+i as string) oldFiles[i]
					CGplusplusFunc.refeshUIs()
				)--end if
			)--end #down
		)--end case
		)--end if
	)--end if
	OK
),
--助手工具栏
fn closeToolbar =	try (
	cui.UnRegisterDialogBar  sptoolbar
	destroydialog sptoolbar
)
catch(),
fn createLinkHint =
(	spCreateLinkHint=try execute (getinisetting spInifilepath "Main" "Linkhint") catch true
	if spCreateLinkHint then (try destroydialog SPLinkHint catch() ; createdialog SPLinkHint)
),
--创建助手工具栏
fn createToolbar thetype:spToolbarType=
(	
	spToolbarType=thetype
	setinisetting spInifilepath "Main" "Type" ("#"+thetype as string)
 
	CGplusplusFunc.closeToolbar()
	
	
	SPToolBarHeightOffset = execute( getinisetting spInifilepath "Main" "ToolBarHeightoffset")
	SPToolBarWidthOffset = execute( getinisetting spInifilepath "Main" "ToolBarWidthoffset")

	--读取脚本文件路径
	itemsTxt=#();SPtoolbarBtn=#()
	itemsTxtArr=getinisetting spIniCategory "S6"
	for s in itemsTxtArr do (
	temp=getinisetting spIniCategory "S6" s
	append itemsTxt (getFilenameFile temp)
	append SPtoolbarBtn temp
	)--end for

	rci=rolloutCreator "sptoolbar" "助手工具栏"
	rci.begin()
	px=0;py=2
	maxxpos=CGplusplusFunc.getDockWidth type:thetype
	len01=(GetTextExtent "选项")[1]+10 + SPToolBarWidthOffset
	pstr01=("pos:["+px as string+","+py as string+"] width:"+len01 as string+" height:" + (18+ SPToolBarHeightOffset) as string)
	code01="spShowtoolbar=execute (getinisetting spInifilepath \"Main\" \"Toolbar\")\n"
	code01+="PopupMenu SPsettingMenuTB"
	rci.addControl #button #setting "选项" paramStr:pstr01
	rci.addHandler #setting #pressed codeStr:code01
	px+=len01+3
	len02=(GetTextExtent "主界面")[1]+10 + SPToolBarWidthOffset
	pstr02=("pos:["+px as string+","+py as string+"] width:"+len02 as string+" height:"+ (18+ SPToolBarHeightOffset) as string)
	rci.addControl #button #mainui "主界面" paramStr:pstr02
	rci.addHandler #mainui #pressed codeStr:"CGplusplusFunc.createMainRlt()"
	px+=len02+3

	for i in 1 to itemsTxt.count do
	(
		thename=itemsTxt[i]
		bn=execute ("#btn"+i as string)
		len=(GetTextExtent thename)[1]+10 + SPToolBarWidthOffset	--按钮宽度
		if (px+len)>maxxpos	--如果超过屏幕宽度，则换行
	    then	(	px=0;py+=20 + SPToolBarHeightOffset)
		pstr=(" pos:["+px as string+","+py as string+"] width:"+len as string+" height:"+ (18+ SPToolBarHeightOffset) as string)
		px+=len+3
		--添加按钮
		thestr="try filein (spRootPath+@\\\\Lib\\\\@+SPtoolbarBtn[" + i as string +"]) catch OK"
		rcmenustr="rcmenu tempmenu (\nmenuitem m1 @编辑代码@\nmenuitem rename @重命名@ \nmenuitem m2 @删除按钮@\nmenuitem m3 @生成快捷方式@\n"
		rcmenustr+="on tempmenu open do (if getfilenametype SPtoolbarBtn["+ i as string +"]==@.mse@ then m1.enabled=false)\n"
		rcmenustr+="on m1 picked do (edit "+"(spRootPath+@\\\\Lib\\\\@+SPtoolbarBtn[" + i as string +"]))\n"
		rcmenustr+="on m2 picked do (CGplusplusFunc.delBtn 6 "+i as string+";CGplusplusFunc.refeshUIs())\n"
		rcmenustr+="on rename picked do (CGplusplusFunc.renamebtn 6 "+ i as string+")\n"
		rcmenustr+="on m3 picked do (\nCGplusplusFunc.createLink (getdir #scripts+@\\\\ScenePromoter4\\\\Lib\\\\@+@"+SPtoolbarBtn[i]+"@)\n"
		rcmenustr+="CGplusplusFunc.createLinkHint())"
		rcmenustr+=")\npopupmenu tempmenu"
		rci.addControl #button bn thename paramStr:pstr
		rci.addHandler bn #pressed codeStr:thestr filter:on
		rci.addHandler bn #rightclick codeStr:rcmenustr filter:on
	)
	-- rci.addControl #ActiveXControl #ax "http://www.cgplusplus.com/mini/sptb4001.html" [disabled: dead domain causes script error] paramStr:"pos:[0,0] width:0 height:0"
	rci.end()
	dockSt=if thetype==#top then #cui_dock_top else #cui_dock_bottom
	createdialog sptoolbar
	cui.RegisterDialogBar sptoolbar style:#(dockSt, #cui_floatable, #cui_handles,#cui_max_sized)
	cui.DockDialogBar sptoolbar dockSt
),
--重启MAX
fn restartMax =
(	--if queryBox "请确定已保存当前文件，重启MAX后，当前文件将自动加载！\n是否重启MAX？" title:"重启MAX提示"
	if checkForSave()
	then (
		shellLaunch (getdir #maxroot+"\\3dsmax.exe") (maxfilepath+maxfilename)
		quitmax #noPrompt
	)
	else ()
),
--数据同步
fn dataSync =
(	curPath=CGplusplusFunc.slashConvert (getdir #maxroot)
	curPath=substring curPath 1 (curPath.count-1) --去掉最后面那个反斜杠\
	items01=getinisetting spInifilepath "Path"
	items02=for i in items01 collect (getinisetting spInifilepath "Path" i)
	idx=finditem items02 curPath
	if idx!=0 then deleteitem items02 idx
	--开始同步
	files01=getFiles (getdir #maxroot +"/scripts/ScenePromoter4/*")
	files02=getDir #maxroot +"/scripts/Startup/SP4_startup.ms"
	files03=getFiles (getdir #maxroot +"/scripts/ScenePromoter4/Lib/*")
	files04=getFiles (getdir #maxroot +"/scripts/ScenePromoter4/images/*")
	files05=getFiles (getdir #maxroot +"/ui/Icons/FeilangSP_*")
	files06=getFiles (getdir #maxroot +"/ui/macroscripts/FeilangTools-SP_*.mcr")
	for f in items02 where doesfileexist (f+"/3dsmax.exe") do
	(	path01=f+"/scripts/ScenePromoter4/"
		path02=f+"/scripts/Startup/"
		path03=path01+"/Lib/"
		path04=path01+"/images/"
		path05=f+"/ui/Icons/"
		path06=f+"/ui/macroscripts/"
		-----
		makeDir path01
		for r in files01 do (
			newfile=path01+getFilenameFile r + getFilenameType r
			if not (copyFile r newfile) then
			(deleteFile newfile;copyFile r newfile)
		)
		-----
		newfile02=path02+getFilenameFile files02 + getFilenameType files02
		if not (copyFile files02 newfile02) then (deleteFile newfile02;copyFile files02 newfile02)
		-----
		makeDir path03
		for r in files03 do (
			newfile=path03+getFilenameFile r + getFilenameType r
			if not (copyFile r newfile) then
			(deleteFile newfile;copyFile r newfile)
		)
		-----
		makeDir path04
		for r in files04 do (
			newfile=path04+getFilenameFile r + getFilenameType r
			if not (copyFile r newfile) then
			(deleteFile newfile;copyFile r newfile)
		)
		-----
		for r in files05 do (
			newfile=path05+getFilenameFile r + getFilenameType r
			if not (copyFile r newfile) then
			(deleteFile newfile;copyFile r newfile)
		)
		-----
		for r in files06 do (
			newfile=path06+getFilenameFile r + getFilenameType r
			if not (copyFile r newfile) then
			(deleteFile newfile;copyFile r newfile)
		)
	)
)
,
--卸载
fn unInstall =
(
	--场景助手4完全卸载
	--本程序可以卸载你电脑里面的场景助手4，包括你用数据同步过的助手4
	--场景助手卸载后，会残留场景助手文件夹ScenePromoter4，不是不想删，MAX脚本没有提供删除文件夹功能
	curPath=CGplusplusFunc.slashConvert (getdir #maxroot)
	curPath=substring curPath 1 (curPath.count-1) --去掉最后面那个反斜杠\
	items01=getinisetting spInifilepath "Path"
	items02=for i in items01 collect (getinisetting spInifilepath "Path" i)
	idx=finditem items02 curPath
	if idx==0 then append items02 curPath
	str = "此程序将卸载您电脑上下列路径中的场景助手4:\n\n" 
	for f in items02 do str += f + "\n"
		str += "\n继续卸载请单击“是”，取消卸载请单击“否”！"
	if queryBox str title:"卸载场景助手2012" then
	(
		--开始卸载
		for f in items02 where doesfileexist (f+"/3dsmax.exe") do
		(        
				deletefile (f+"/scripts/Startup/SP4_startup.ms")
				deletefile (getdir #usermacros + "/FeilangTools-ScenePromoter4.mcr")
				
				thepath=f+"/scripts/ScenePromoter4"
				files=getfiles (thepath+"/*")
				for p in files do deletefile p
				
				files=getfiles (thepath+"/Lib/*")
				for p in files do deletefile p
				
				files=getfiles (thepath+"/images/*")
				for p in files do deletefile p

				files=getfiles (f+"/ui/Icons/FeilangSP_*.bmp")
				for p in files do deletefile p

				files=getfiles (f+"/ui/macroscripts/FeilangTools-SP_*.mcr")
				for p in files do deletefile p
		
				files=getfiles (getdir #usermacros+"/FeilangTools-SP_*.mcr")
				for p in files do deletefile p
		)
		if queryBox "场景助手2012已经卸载完毕，重启MAX后生效。\n是否现在重启MAX？" title:"卸载场景助手2012" then CGplusplusFunc.restartMax()
	)
	else format "取消卸载场景助手！"
)
)--end struct
CGplusplusFunc=CGppFuncStruct()
