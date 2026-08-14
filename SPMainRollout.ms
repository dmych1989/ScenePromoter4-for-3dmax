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

global spRolHeight=execute (getinisetting spInifilepath "Main" "Height")
global spRolWidth=execute (getinisetting spInifilepath "Main" "Width")

--main ui
rollout ScenePromoter4Rol "场景助手" width:160 height:500
(
	local bmpPath = spRootPath+"\\images"
	local tit="场景助手提示",sepStrs=""
	local listID = (getinisetting spInifilepath "Main" "listid") as integer
	--材质分类存储
	local sepcMatCt=#(),sepcMat=#()
	--Treeview datas
	local theColors = CGplusplusFunc.getUIcol()
	local textNodes=#() 
	--script files
	local itemsFile=#(undefined)
	dotNetControl tv "System.Windows.Forms.TreeView" pos:[0,20] width:160 height:480
	local btnmap = openbitmap (bmpPath+"\\setimg1.png")
	local btnmap2 = openbitmap (bmpPath+"\\setimg2.png")	
	local circleBmpF = openbitmap (bmpPath+"\\circle.png")
	local btnmapsNM = CGplusplusFunc.divideIconBM (CGplusplusFunc.changeBackColor btnmap theColors[4]) 4
	local btnmapsHL = CGplusplusFunc.divideIconBM (CGplusplusFunc.changeBackColor btnmap2 theColors[4]) 4
	local circleBmp = CGplusplusFunc.divideIconBM (CGplusplusFunc.changeBackColor circleBmpF theColors[4]) 3
	local minMaxBmp = #(btnmapsNM[3],btnmapsNM[3])
	
	ImgTag setbtn "" pos:[120,0] width:20 height:20 bitmap:(btnmapsNM[1]) tooltip:"选项"
	ImgTag linkbbs "" pos:[100,0] width:20 height:20 bitmap:(btnmapsNM[2]) tooltip:"公众号：山医命象卜"
	ImgTag minMax "" pos:[140,0] width:20 height:20 bitmap:(minMaxBmp[1]) tooltip:"收缩面板"
	ImgTag hl1 "" pos:[0,0] width:20 height:20 bitmap:circleBmp[1] tooltip:"第一屏"
	ImgTag hl2 "" pos:[20,0] width:20 height:20 bitmap:circleBmp[3] tooltip:"第二屏"
	ImgTag hl3 "" pos:[40,0] width:20 height:20 bitmap:circleBmp[1] tooltip:"第三屏"
	ImgTag hl4 "" pos:[60,0] width:20 height:20 bitmap:circleBmp[1] tooltip:"第四屏"
	ImgTag hl5 "" pos:[80,0] width:20 height:20 bitmap:circleBmp[1] tooltip:"第五屏"
	-- ActiveXControl lk "http://www.cgplusplus.com/mini/sp4001.html" [disabled: dead domain causes script error] pos:[0,0] width:0 height:0

	local hls=#(hl1,hl2,hl3,hl4,hl5)
	--颜色转换
	fn getColFromArgb clr =
	(
		(DotnetClass "System.Drawing.Color").FromArgb 255 clr.r clr.g clr.b
	)
	fn setMinMaxBmp state =
	(
		if state == "0" then
		(
			minMaxBmp[1] = btnmapsNM[3]
			minMaxBmp[2] = btnmapsNM[4]
			minMax.bitmap = minMaxBmp[1] 
		)
		else
		(
			minMaxBmp[1] = btnmapsHL[3]
			minMaxBmp[2] = btnmapsHL[4]
			minMax.bitmap = minMaxBmp[1]
		)
	)
	
	--初始化列表
	fn initTreeView =
	(
		--是否显示左边的层级线
		tv.ShowLines = false
		--链接字的颜色
		tv.ForeColor = getColFromArgb theColors[1]	
		--背景色
		tv.BackColor = getColFromArgb theColors[2]	
		
		tv.Height = ScenePromoter4Rol.height - 20
		tv.Width = ScenePromoter4Rol.width
		--按钮文本高度
		tv.ItemHeight = 16 
		--左边缩进
		tv.Indent=12 
		--边框形式，可以把 None 改成 Fixed3D 或者 FixedSingle
		tv.BorderStyle=(dotNetClass "System.Windows.Forms.BorderStyle").None 
	)
	--设置文本颜色
	fn refeshColor = if textNodes.count!=0 then for t in textNodes do t.ForeColor =getColFromArgb theColors[3]
	--用于主界面设置－－颜色设置项
	fn refeshUIColor =
	(
		--链接字的颜色
		tv.ForeColor = getColFromArgb theColors[1]
		tv.BackColor = getColFromArgb theColors[2]
		refeshColor()
	)
	fn refeshInfo =
	(	--刷新场景信息
		timestart=timestamp()
		tv.Nodes.Clear()
		tv.BeginUpdate()
		tv.Nodes.add ""
		tv.Nodes.add "刷新场景信息"
		tv.Nodes.add sepStrs
		textNodes=#()
		--物体信息
		objs_num=objects.count;s_num=selection.count
		all_poly=0;s_poly=0
			for i=1 to objs_num do
			(
				tempNum=(getPolygonCount objects[i])[1]
				all_poly+=tempNum
			)
		newNode = tv.Nodes.add ("总面数:"+CGplusplusFunc.commaNumbers (all_poly as string))
		append textNodes newNode
		for j=1 to s_num do
		(
			tempNum=(getPolygonCount selection[j])[1]
			s_poly+=tempNum
		)
		newNode = tv.Nodes.add ("选择面数:"+CGplusplusFunc.commaNumbers (s_poly as string))
		append textNodes newNode
		newNode = tv.Nodes.add ("所有物体:"+CGplusplusFunc.commaNumbers (objs_num as string))
		append textNodes newNode
		newNode = tv.Nodes.add ("选择物体:"+CGplusplusFunc.commaNumbers (s_num as string))
		append textNodes newNode
		noMtlObjsNum=0
		for i in objects do -- collect no materail objects
		(	if i.material==undefined then
			(	
				if (isKindof i geometryclass and (iskindof i targetobject)==false) then noMtlObjsNum+=1
				else try if (isKindof i shape)  then ( if i.render_renderable then noMtlObjsNum+=1) catch()
			)
		)
		tv.Nodes.add ("没材质物体:"+CGplusplusFunc.commaNumbers (noMtlObjsNum as string))
		--材质信息
		allMtls = for i in sceneMaterials collect i.name	--collect all the name of scene mat
		allMtlsNum = allMtls.count
		sameMtls=(CGplusplusFunc.sameItemNum allMtls)[1]
		tv.Nodes.add sepStrs--空行
		tv.Nodes.add ("所有材质:"+CGplusplusFunc.commaNumbers (allMtlsNum as string))
		selectedMtls=#()--选择物体材质
		for i in selection do
			if i.material!=undefined then
				if  (findItem selectedMtls i.material)==0 then
					append selectedMtls i.material	--collect mat of seleted objects
		tv.Nodes.add ("选择物体材质:"+CGplusplusFunc.commaNumbers (selectedMtls.count as string))
		tv.Nodes.add ("同名材质:"+CGplusplusFunc.commaNumbers (sameMtls as string))
		tv.Nodes.add ("材质库:"+CGplusplusFunc.commaNumbers (currentMaterialLibrary.count as string))
		missmapmats = (CGplusplusFunc.getMissingmapMats()).count
		tv.Nodes.add ("丢失贴图:"+CGplusplusFunc.commaNumbers (missmapmats as string))
		--具体材质类型
		if allMtlsNum!=0 then (
			tv.Nodes.add sepStrs  --空行
			matTypes=CGplusplusFunc.getSceneMats()
			for s in matTypes do
			(
				append sepcMat s
				append sepcMatCt 0
				tv.Nodes.add s
			)
		)
		timeend=timestamp()
		tv.Nodes.add sepStrs --空行
		newNode = tv.Nodes.add ("用时"+((timeend-timestart)/1000.0) as string+"秒")
		append textNodes newNode
		refeshColor()
		tv.EndUpdate()
	)
	fn setUIbutton s type =
	(
		if s != listID then
		case type of
		(
			#over : hls[s].bitmap = circleBmp[2]
			#out : hls[s].bitmap = circleBmp[1]
		)
	)
	fn resetUI s =
	(	--重新布置UI,S为第几屏
		secStr="";itemsFile=#(undefined)
		for i in hls do i.bitmap = circleBmp[1]
		hls[s].bitmap = circleBmp[3]
		listID = s
		case s of
		(	1: (refeshInfo();setinisetting spInifilepath "Main" "listid" "1"
			)
			2:(	secStr="S2";setinisetting spInifilepath "Main" "listid" "2"
			)
			3:(secStr="S3";setinisetting spInifilepath "Main" "listid" "3"
			)
			4:(secStr="S4";setinisetting spInifilepath "Main" "listid" "4"
			)
			5:(secStr="S5";setinisetting spInifilepath "Main" "listid" "5"
			)
			default:()
		)--end case
		--reset list	
		if secStr!="" then
		(	tv.Nodes.Clear()
			tv.Nodes.Add ""
			--读取脚本文件路径
			itemsTxt=#()
			itemsTxtArr=getinisetting spIniCategory secStr
			for s in itemsTxtArr do (
				temp=getinisetting spIniCategory secStr s
				if temp!="undefined" then (	--如果是undefined即生成间隔线‘--------’
					append itemsTxt (getFilenameFile temp)
					append itemsFile temp
				)
				else (append itemsTxt sepStrs;append itemsFile undefined)
			)--end for
			tv.BeginUpdate()
			for i in 1 to itemsTxt.count do (
				tv.Nodes.Add itemsTxt[i]
			) --end for
			if itemsTxt.count == 0 then
			(
				strArr = #("你可以在此添加其他","ms或者mse格式脚本","","或者添加一个exe文件", \
					"的快捷方式。","","单击右上角的扳手","--添加即可。")
				textNodes=#()
				for s in 1 to strArr.count do
				(
					nd = tv.Nodes.Add(strArr[s])
					append textNodes nd
				)
				refeshColor()
			)
			tv.EndUpdate()
		)
		str = getinisetting spInifilepath "Main" "minMax" 
		if str != "0" then 
		(	hh = getinisetting spInifilepath "Main" "height"
			ScenePromoter4Rol.height = hh as integer
			setinisetting spInifilepath "Main" "minMax" "0"
			minMax.bitmap = btnmapsNM[3]
		)
	)--end resetUI
	--用于主界面设置－－导航背景色修改
	fn refreshNav =
	(
		btnmapsNM = CGplusplusFunc.divideIconBM (CGplusplusFunc.changeBackColor btnmap theColors[4]) 4
		btnmapsHL = CGplusplusFunc.divideIconBM (CGplusplusFunc.changeBackColor btnmap2 theColors[4]) 4
		circleBmp = CGplusplusFunc.divideIconBM (CGplusplusFunc.changeBackColor circleBmpF theColors[4]) 3
		for i in hls do i.bitmap = circleBmp[1]
		hls[listID].bitmap = circleBmp[3]
		setbtn.bitmap = btnmapsNM[1]
		linkbbs.bitmap = btnmapsNM[2]
		str = getinisetting spInifilepath "Main" "minMax"
		setMinMaxBmp str
		SetDialogBitmap ScenePromoter4Rol (CGplusplusFunc.changeNavBG theColors[4])
	)
	fn pressLink s nd =
	(	--单击第S屏第idx个链接
		idx=nd.index+1
		case s of
		(	1: 
			(	case idx of 
				(	1: ()
					2: refeshInfo()
					8: CGplusplusFunc.matAndObjOps 1 --选择没有材质的物体
					10: CGplusplusFunc.matAndObjOps 2 --导入所有材质
					11: CGplusplusFunc.matAndObjOps 3 --导入选择材质
					12: CGplusplusFunc.matAndObjOps 4 --导入同名材质
					13: CGplusplusFunc.matAndObjOps 5 --导入材质库材质
					14: CGplusplusFunc.matAndObjOps 6 --导入丢失材质
					default: --导入特定材质
					(	totalId=tv.nodes.count
						if idx >=16 and idx <= totalId-2 then
						(	str=nd.text
							str1=filterString str ":"
							cls=execute str1[1]
							matNum=execute str1[2]
							mats=for i in scenematerials where classof i == cls collect i
							if mats.count!=0 and mats.count==matNum then 
							(	MatEditor.Open()
								tempidx=finditem sepcMat str
								sepcMatCt[tempidx]=CGplusplusFunc.importMtls mats sepcMatCt[tempidx]
							)
							else refeshInfo()
						) --end if
					)--end default
				)--end case
			)
			2: 
			(	if itemsFile.count>1 and itemsFile[idx]!=undefined then
				(	thetype=CGplusplusFunc.UpperToLower (getFileNameType itemsFile[idx])
					if thetype==".ms" or thetype==".mse" then try filein (spRootPath+"\\Lib\\"+itemsFile[idx]) catch resetUI 2
					else OK
				)
			)
			3: 
			(
				if itemsFile.count>1 and itemsFile[idx]!=undefined then
				(	thetype=CGplusplusFunc.UpperToLower (getFileNameType itemsFile[idx])
					if thetype==".ms" or thetype==".mse" then try filein (spRootPath+"\\Lib\\"+itemsFile[idx]) catch resetUI 3
					else OK
				)
			)
			4:
			(
				if itemsFile.count>1 and itemsFile[idx]!=undefined then
				(	thetype=CGplusplusFunc.UpperToLower (getFileNameType itemsFile[idx])
					if thetype==".ms" or thetype==".mse" then try filein (spRootPath+"\\Lib\\"+itemsFile[idx]) catch resetUI 4
					else OK
				)
			)
			5:
			(
				if itemsFile.count>1 and itemsFile[idx]!=undefined then
				(	thetype=CGplusplusFunc.UpperToLower (getFileNameType itemsFile[idx])
					if thetype==".ms" or thetype==".mse" then try filein (spRootPath+"\\Lib\\"+itemsFile[idx]) catch resetUI 5
					else OK
				)
			)
			default: ()
		)
	)
	on ScenePromoter4Rol open do
	(
		initTreeView()
		resetUI listID
	)
	on ScenePromoter4Rol resized p do
	(
		--检测是否停靠，如果停靠则关闭缩放
		spDockState=execute (getinisetting spInifilepath "Main" "DockState")
		if spDockState == #float then
		(
			hh = getinisetting spInifilepath "Main" "height"
			if p.x < 160 then ScenePromoter4Rol.width = 160
			if p.y > 20 then 
			(
				hh = ScenePromoter4Rol.height as string
				setinisetting spInifilepath "Main" "minMax" "0"
				minMax.bitmap = btnmapsNM[3]
			)
			else (
				ScenePromoter4Rol.height = 20
				setinisetting spInifilepath "Main" "minMax" "1"
				minMax.bitmap = btnmapsHL[3]
			)
			tv.Height = ScenePromoter4Rol.height - 20
			tv.Width = ScenePromoter4Rol.width
			setinisetting spInifilepath "Main" "Height" hh
			setinisetting spInifilepath "Main" "Width" (ScenePromoter4Rol.width as string)
		)
		else ()
	)
	on ScenePromoter4Rol moved arg do (
		setinisetting spInifilepath "Main" "Pos" (arg as string)
	)
	on ScenePromoter4Rol close do
	(
		if SPmainRolSet.open then destroydialog SPmainRolSet
	)
	on tv NodeMouseClick arg do
	(
		pressLink listID arg.Node
	)
	on hl1 mouseover do setUIbutton 1 #over
	on hl1 mouseout do setUIbutton 1 #out
	on hl1 click do resetUI 1

	on hl2 mouseover do setUIbutton 2 #over
	on hl2 mouseout do setUIbutton 2 #out
	on hl2 click do resetUI 2

	on hl3 mouseover do setUIbutton 3 #over
	on hl3 mouseout do setUIbutton 3 #out
	on hl3 click do resetUI 3

	on hl4 mouseover do setUIbutton 4 #over
	on hl4 mouseout do setUIbutton 4 #out
	on hl4 click do resetUI 4

	on hl5 mouseover do setUIbutton 5 #over
	on hl5 mouseout do setUIbutton 5 #out
	on hl5 click do resetUI 5
	
	on linkbbs mouseover do	linkbbs.bitmap = btnmapsHL[2]
	on linkbbs mouseout do	linkbbs.bitmap = btnmapsNM[2]
	on linkbbs click do shellLaunch "http://mp.weixin.qq.com/mp/homepage?__biz=MzA4NjQ2MDYzMA==&hid=1&sn=bb2531d86a7d41ca361cca9081151faa&scene=18#wechat_redirect" ""
	
	on setbtn mouseover do	setbtn.bitmap = btnmapsHL[1]
	on setbtn mouseout do	setbtn.bitmap = btnmapsNM[1]
	on setbtn click do PopupMenu SPsettingMenu align:#align_bottomright
		
	on minMax mouseover do minMax.bitmap = minMaxBmp[2]
	on minMax mouseout do minMax.bitmap = minMaxBmp[1]
	on minMax click do 
	(
		--检测是否停靠，如果停靠则关闭缩放
		spDockState=execute (getinisetting spInifilepath "Main" "DockState")
		if spDockState == #float then
		(
			str = getinisetting spInifilepath "Main" "minMax" 
			if str != "0" then 
			(	
				hh = getinisetting spInifilepath "Main" "height"
				ScenePromoter4Rol.height = hh as integer
				setinisetting spInifilepath "Main" "minMax" "0"
				setMinMaxBmp "0"
			)
			else
			(	ScenePromoter4Rol.height = 20
				setinisetting spInifilepath "Main" "minMax" "1"
				setMinMaxBmp "1"
			)
		)
		else ()
	)
)
