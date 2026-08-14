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

--界面

--setting menu toolbar
--setting menu main ui
rcmenu SPsettingMenu 
(	--选项菜单
	fn filterAdd = ScenePromoter4Rol.listID!=1
	fn setStrs =
	(
		strs = #()
		append strs "1、如果你第一次用场景助手，建议先看一下场景助手"
		append strs "详细使用说明。如果你用过场景助手3.0及以前版本，"
		append strs "帮助里面那个4.0的视频，虽然普通话不标准，也能听。"
		append strs ""
		append strs "2、场景助手4.1的界面重写了，但是跟4.0变化不大，"
		append strs "某些功能可能换位置了。"
		append strs ""
		append strs "3、默认打开Max主界面会自动启动。在选项－界面设置"
		append strs "里面取消勾选[ 主界面随Max自动启动 ] 即可关掉。"
		append strs ""
		append strs "4、Vray代理管理器在4.0就升级了，只是没告知大家，"
		append strs "支持多选了，增加了一些功能。"
		append strs ""
		append strs "5、3.0版本的 [ 按元素分离 ] 在 [ 超级分离 ] 里面。"
		append strs ""
		append strs "6、[ 整理丢失贴图 ] 可以导出丢失信息。"
		append strs ""
		append strs "7、界面设置作了调整，可以调各种颜色，一看就明白。"
		append strs "记得保存你调的方案。"
		append strs ""
		append strs "8、导航栏右边那杠杠可以把界面收起来，试试就明白。"
		append strs ""
		append strs ""
		strs
	)
	subMenu "添加"
	(
		menuItem addOne "添加一个脚本" enabled:(ScenePromoter4Rol.listID!=1)
		menuItem addFolder "添加脚本文件夹" enabled:(ScenePromoter4Rol.listID!=1)
		menuItem addExe "添加exe文件" enabled:(ScenePromoter4Rol.listID!=1)
		menuItem addSep "添加空行" enabled:(ScenePromoter4Rol.listID!=1)
		menuItem addEpt "新建脚本" enabled:(ScenePromoter4Rol.listID!=1)
	)
	subMenu "界面停靠"
	(
		menuItem dockleft "左停靠"
		menuItem dockright "右停靠"
		menuItem floatstate "悬浮状态"
	)
	menuItem setui "界面设置"

	subMenu "工具栏"
	(
		menuItem topBar "停靠顶部"
		menuItem btmBar "停靠底部"
		menuItem btnSize "按钮大小设置"
		separator sp2012
		menuItem autoSt "是否随Max启动" checked:spShowtoolbar
		menuItem closeBar "关闭工具栏"
	)
	separator sp01
	menuItem manage "脚本管理"
	menuItem backup "数据同步"
	menuItem linkmng "快捷方式"
	separator sp02
	menuItem mytitle "个性化Max"
	menuItem restart "重启Max"
	separator sp03
	subMenu "帮助"
	(
		menuItem doc01 "帮助说明"
		menuItem doc02 "场景助手详细使用说明"
	)
	menuItem abt "关于"
	separator sp04
	menuItem uninstall "卸载"

	
	--个性化	
	on mytitle picked do (destroydialog SPmyPersTitle;CGplusplusFunc.createChild SPmyPersTitle width:347)

	on dockleft picked do
	(	
		CGplusplusFunc.dockMainRlt thetype:#left
	)
	on dockright picked do
	(	
		CGplusplusFunc.dockMainRlt thetype:#right
	)
	on floatstate picked do
	(	
		CGplusplusFunc.dockMainRlt thetype:#float
	)
	on setui picked do (destroydialog SPmainRolSet;CGplusplusFunc.createChild  SPmainRolSet width:211)
	--添加
	on addOne picked do
	(
		f=getOpenFileName caption:"增加一个脚本到助手工具栏" types:"*.ms, or *.mse|*.ms*"
		if f!=undefined then
		(
			CGplusplusFunc.addBtn ScenePromoter4Rol.listID files:#(f)
		)
	)
	on addFolder picked do
	(
		f=getSavePath  caption:"增加一个文件夹"
		if f!=undefined then
		(	thefile=getfiles (f+"\\*.ms")
			join thefile (getfiles (f+"\\*.mse"))
				if thefile[1]!=undefined then CGplusplusFunc.addBtn ScenePromoter4Rol.listID files:thefile
		)
	)
	on addExe picked do
	(	
		f=getOpenFileName caption:"增加一个可执行文件" types:"*.exe|*.exe"
		if f!=undefined then
		(
			CGplusplusFunc.addExe ScenePromoter4Rol.listID f
		)
	)
	on addEpt picked do
	(
		CGplusplusFunc.addEpt ScenePromoter4Rol.listID
	)
	on addSep picked do
	(
		CGplusplusFunc.addBtn ScenePromoter4Rol.listID
	)

	--工具栏
	on topBar picked do CGplusplusFunc.createToolbar thetype:#top
	on btmBar picked do CGplusplusFunc.createToolbar thetype:#bottom
	on closeBar picked do CGplusplusFunc.closeToolbar()
	on autoSt picked do (
		if spShowtoolbar then setinisetting spInifilepath "Main" "Toolbar" "false"
			else setinisetting spInifilepath "Main" "Toolbar" "true"
	)
	on btnSize picked do (destroydialog SPmtoolbarRolSet ; CGplusplusFunc.createChild SPmtoolbarRolSet width:277)

	--脚本管理
	on manage picked do (
		try destroydialog SPmanageScripts catch ()
		CGplusplusFunc.createChild SPmanageScripts width:350
		thenum=ScenePromoter4Rol.listID
		if thenum==1 then thenum=2
		SPmanageScripts.refeshList thenum
		)
	--同步
	on backup picked do (destroydialog SPdataSync ; CGplusplusFunc.createChild SPdataSync width:432)
	on linkmng picked do (destroydialog SPlinkmanage ; CGplusplusFunc.createChild SPlinkmanage width:350)
	on restart picked do CGplusplusFunc.restartMax()
	on abt picked do (
		destroydialog SPabtRol
		createdialog SPabtRol fgcolor:(color 0 123 238) bgcolor:white
	)
	on uninstall picked do CGplusplusFunc.unInstall()
	--帮助
	on doc01 picked do
	(
		rollout doc01rol "帮助文档" width:352 height:306
		(
			listbox lb "" pos:[13,7] width:323 height:17
			button btn1 "关闭" pos:[93,263] width:158 height:25
			on doc01rol open do
			(

				lb.items = setStrs()
			)
			on btn1 pressed  do
			(
			destroydialog doc01rol
			)
		)
		createdialog doc01rol
	)
	on doc02 picked do shellLaunch (spRootPath + "\\Help\\help.htm") ""
)
--setting menu toolbar
rcmenu SPsettingMenuTB 
(	--选项菜单,工具栏
	subMenu "添加"
	(
		menuItem addOne "添加一个脚本"
		menuItem addFolder "添加脚本文件夹"
		menuItem addExe "添加exe文件"
		menuItem addEpt "新建脚本"
	)
	subMenu "界面停靠"
	(
		menuItem dockleft "左停靠"
		menuItem dockright "右停靠"
		menuItem floatstate "悬浮状态"
	)
	menuItem setui "界面设置"
	subMenu "工具栏"
	(
		menuItem topBar "停靠顶部"
		menuItem btmBar "停靠底部"
		menuItem btnSize "按钮大小设置"
		separator sp2012
		menuItem autoSt "是否随Max启动" checked:spShowtoolbar
		menuItem closeBar "关闭工具栏"
	)
	separator sp01
	menuItem manage "脚本管理"
	menuItem backup "数据同步"
	menuItem linkmng "快捷方式"
	separator sp02
	menuItem mytitle "个性化Max"
	menuItem restart "重启Max"
	separator sp03
	subMenu "帮助"
	(
		menuItem doc01 "帮助说明"
		menuItem doc02 "场景助手详细使用说明"
	)
	menuItem abt "关于"
	separator sp04
	menuItem uninstall "卸载"
	on mytitle picked do (destroydialog SPmyPersTitle;CGplusplusFunc.createChild SPmyPersTitle width:347)
	--界面设置
	on dockleft picked do
	(	
		CGplusplusFunc.dockMainRlt thetype:#left
	)
	on dockright picked do
	(	
		CGplusplusFunc.dockMainRlt thetype:#right
	)
	on floatstate picked do
	(	
		CGplusplusFunc.dockMainRlt thetype:#float
	)
	on setui picked do (destroydialog SPmainRolSet;CGplusplusFunc.createChild  SPmainRolSet width:211)
	--添加
	on addOne picked do
	(
		f=getOpenFileName caption:"增加一个脚本到助手工具栏" types:"*.ms, or *.mse|*.ms*"
		if f!=undefined then
		(
			CGplusplusFunc.addBtn 6 files:#(f)
		)
	)
	on addFolder picked do
	(
		f=getSavePath  caption:"增加一个文件夹"
		if f!=undefined then
		(	thefile=getfiles (f+"\\*.ms")
			join thefile (getfiles (f+"\\*.mse"))
				if thefile[1]!=undefined then CGplusplusFunc.addBtn 6 files:thefile
		)
	)
	on addExe picked do
	(	
		f=getOpenFileName caption:"增加一个可执行文件" types:"*.exe|*.exe"
		if f!=undefined then
		(
			CGplusplusFunc.addExe 6 f
		)
	)
	on addEpt picked do
	(
		CGplusplusFunc.addEpt 6
	)
	--工具栏
	on topBar picked do CGplusplusFunc.createToolbar thetype:#top
	on btmBar picked do CGplusplusFunc.createToolbar thetype:#bottom
	on closeBar picked do CGplusplusFunc.closeToolbar()
	on btnSize picked do (destroydialog SPmtoolbarRolSet ; CGplusplusFunc.createChild SPmtoolbarRolSet width:277)
	
	on autoSt picked do (
		if spShowtoolbar then setinisetting spInifilepath "Main" "Toolbar" "false"
			else setinisetting spInifilepath "Main" "Toolbar" "true"
	)
	on manage picked do (
		try destroydialog SPmanageScripts catch ()
		CGplusplusFunc.createChild SPmanageScripts width:350
		SPmanageScripts.refeshList 6
		)
	on backup picked do (destroydialog SPdataSync ; CGplusplusFunc.createChild SPdataSync width:432)
	on linkmng picked do (destroydialog SPlinkmanage ;  CGplusplusFunc.createChild SPlinkmanage width:350)
	on restart picked do CGplusplusFunc.restartMax()
	on abt picked do (
		destroydialog SPabtRol
		createdialog SPabtRol fgcolor:(color 0 123 238) bgcolor:white
	)
	on uninstall picked do CGplusplusFunc.unInstall()
	--帮助
	on doc01 picked do
	(
		rollout doc01rol "帮助文档" width:352 height:306
		(
			listbox lb "" pos:[13,7] width:323 height:17
			button btn1 "关闭" pos:[93,263] width:158 height:25
			on doc01rol open do
			(

				lb.items = SPsettingMenu.setStrs()
			)
			on btn1 pressed  do
			(
			destroydialog doc01rol
			)
		)
		createdialog doc01rol
	)
	on doc02 picked do shellLaunch (spRootPath + "\\Help\\help.htm") ""
)
--脚本管理,添加到...
global SPmngAddtoValue=#()
rcmenu SPmngAddto 
(	fn filterFN2 = SPmngAddtoValue[1]!=2
	fn filterFN3 = SPmngAddtoValue[1]!=3
	fn filterFN4 = SPmngAddtoValue[1]!=4
	fn filterFN5 = SPmngAddtoValue[1]!=5
	fn filterFN6 = SPmngAddtoValue[1]!=6
	menuItem s2 "添加到第二屏" filter:filterFN2
	menuItem s3 "添加到第三屏" filter:filterFN3
	menuItem s4 "添加到第四屏" filter:filterFN4
	menuItem s5 "添加到第五屏" filter:filterFN5
	menuItem s6 "添加到助手工具栏" filter:filterFN6
	on s2 picked do CGplusplusFunc.addBtn 2 files:SPmngAddtoValue[2]
	on s3 picked do CGplusplusFunc.addBtn 3 files:SPmngAddtoValue[2]
	on s4 picked do CGplusplusFunc.addBtn 4 files:SPmngAddtoValue[2]
	on s5 picked do CGplusplusFunc.addBtn 5 files:SPmngAddtoValue[2]
	on s6 picked do CGplusplusFunc.addBtn 6 files:SPmngAddtoValue[2]
)
--manage scripts
rollout SPmanageScripts "脚本管理" width:350 height:350
(
	checkbutton btn2 "第二屏" pos:[4,3] width:46 height:18
	checkbutton btn3 "第三屏" pos:[53,3] width:46 height:18
	checkbutton btn4 "第四屏" pos:[102,3] width:46 height:18
	checkbutton btn5 "第五屏" pos:[151,3] width:46 height:18
	checkbutton btn6 "工具栏" pos:[201,3] width:46 height:18
	checkbutton nohome "无家可归" pos:[252,3] width:60 height:18
	multiListBox mt "请先选择列表" pos:[5,26] width:242 height:16
	button del "删除按钮" pos:[251,127] width:95 height:18 toolTip:"删除选择按钮,可多选"
	button addto "添加到..." pos:[251,42] width:95 height:18 toolTip:"添加到其他屏,可多选"
	button showfolder "源代码文件夹" pos:[251,210] width:95 height:18 toolTip:"打开文件夹"
	button Rename "重命名" pos:[251,85] width:95 height:18 toolTip:"重命名脚本同时更改按钮,单选"
	button editsp "编辑代码" pos:[251,106] width:95 height:18 toolTip:"打开脚本,可多选"
	button btnlink "生成快捷方式" pos:[251,189] width:95 height:18 toolTip:"可多选"
	button delspt "删除脚本(慎用)" pos:[251,168] width:95 height:18 toolTip:"删除脚本,并删除与之相关的所有按钮"
	label hy1 "Label" pos:[20,262] width:350 height:40
	button clearEpt "清除空按钮" pos:[251,147] width:95 height:18 toolTip:"如果Lib文件夹下无此文件清除相关按钮"
	button cls "关 闭" pos:[130,310] width:95 height:25
	button addEpt "新建脚本" pos:[251,64] width:95 height:18
	button moveUp "上移" pos:[251,231] width:46 height:18
	button moveDown "下移" pos:[300,232] width:46 height:18
	local btns=#(btn2,btn3,btn4,btn5,btn6,nohome)
	local num=2
	fn getAllbtn =
	(
		itemsFile=#()
		itemsTxtArr=getinisetting spIniCategory "S2"
		for s in itemsTxtArr do (
		temp=getinisetting spIniCategory "S2" s
		append itemsFile temp
		)--end for
		------
		itemsTxtArr=getinisetting spIniCategory "S3"
		for s in itemsTxtArr do (
		temp=getinisetting spIniCategory "S3" s
		if finditem itemsFile temp==0 then	append itemsFile temp
		)
		------
		itemsTxtArr=getinisetting spIniCategory "S4"
		for s in itemsTxtArr do (
		temp=getinisetting spIniCategory "S4" s
		if finditem itemsFile temp==0 then	append itemsFile temp
		)
		------
		itemsTxtArr=getinisetting spIniCategory "S5"
		for s in itemsTxtArr do (
		temp=getinisetting spIniCategory "S5" s
		if finditem itemsFile temp==0 then	append itemsFile temp
		)
		------
		itemsTxtArr=getinisetting spIniCategory "S6"
		for s in itemsTxtArr do (
		temp=getinisetting spIniCategory "S6" s
		if finditem itemsFile temp==0 then	append itemsFile temp
		)
		sort itemsFile
		itemsFile
	)
	fn clearEptFN =
	(	--清除空按钮
		itemsTxtArr=getinisetting spIniCategory "S2"
		for s in itemsTxtArr.count to 1 by -1 where itemsTxtArr[s]!=undefined do (
		temp=getinisetting spIniCategory "S2" itemsTxtArr[s]
		if temp!="undefined" and not doesfileexist (spLibPath+"\\"+temp) then CGplusplusFunc.delBtn 2 s  
		)--end for
		------
		itemsTxtArr=getinisetting spIniCategory "S3"
		for s in itemsTxtArr.count to 1 by -1 where itemsTxtArr[s]!=undefined do (
		temp=getinisetting spIniCategory "S3" itemsTxtArr[s]
		if temp!="undefined" and not doesfileexist (spLibPath+"\\"+temp) then CGplusplusFunc.delBtn 3 s  
		)--end for
		------
		itemsTxtArr=getinisetting spIniCategory "S4"
		for s in itemsTxtArr.count to 1 by -1 where itemsTxtArr[s]!=undefined do (
		temp=getinisetting spIniCategory "S4" itemsTxtArr[s]
		if temp!="undefined" and not doesfileexist (spLibPath+"\\"+temp) then CGplusplusFunc.delBtn 4 s  
		)--end for
		------
		itemsTxtArr=getinisetting spIniCategory "5"
		for s in itemsTxtArr.count to 1 by -1 where itemsTxtArr[s]!=undefined do (
		temp=getinisetting spIniCategory "S5" itemsTxtArr[s]
		if temp!="undefined" and not doesfileexist (spLibPath+"\\"+temp) then CGplusplusFunc.delBtn 5 s  
		)--end for
		------
		itemsTxtArr=getinisetting spIniCategory "S6"
		for s in itemsTxtArr.count to 1 by -1 where itemsTxtArr[s]!=undefined do (
		temp=getinisetting spIniCategory "S6" itemsTxtArr[s]
		if temp!="undefined" and not doesfileexist (spLibPath+"\\"+temp) then CGplusplusFunc.delBtn 6 s  
		)--end for
		------
	)
	fn getnohome =
	(	--收集“无家可归”脚本
		num=7
		for i in btns do i.checked=false
			nohome.checked=true
		itemsFile01=getAllbtn()
		thefiles=getfiles (spLibPath+"\\*.ms")
		join thefiles (getfiles (spLibPath+"\\*.mse"))
		thefilenames=for f in thefiles collect (getfilenamefile f +getfilenametype f)
		nohomefile=for i in 1 to thefiles.count where finditem itemsFile01 thefilenames[i]==0 collect thefiles[i]
		filenew=for f in nohomefile collect (getfilenamefile f +getfilenametype f)
		sort filenew
		mt.items=filenew
	)
	fn refeshList s =
	(	num=s
		if s>6 then (getnohome();return OK)
		for i in btns do i.checked=false
		btns[s-1].checked=true
		--读取脚本文件路径
		itemsFile=#()
		itemsTxtArr=getinisetting spIniCategory ("S"+s as string)
		for j in itemsTxtArr do (
		temp=getinisetting spIniCategory ("S"+s as string) j
			if temp=="undefined" then temp="--------这里是空行"
		append itemsFile temp
		)--end for
		mt.items=itemsFile
	)

	on SPmanageScripts open do
	(	str="除了 '重命名' ' 上移 ' ' 下移 ' 以外,其他均可多选;'无家可归' \n指Lib文件夹下有此脚本,"
		str+="但是没有添加到场景助手中来\n第一屏的按钮会根据场景动态创建，不提供管理。"
		hy1.text=str
		)
	on btn2 changed state do
	(
		refeshList 2
	)
	on btn3 changed state do
	(
		refeshList 3
	)
	on btn4 changed state do
	(
		refeshList 4
	)
	on btn5 changed state do
	(
		refeshList 5
	)
	on btn6 changed state do
	(
		refeshList 6
	)
	on nohome changed state do
		getnohome()
	on del pressed do
	(	if num < 7 then (
			sel=mt.selection as array
			if sel.count!=0 then (
			for i in sel.count to 1 by -1 do CGplusplusFunc.delBtn num sel[i]
				mt.selection=0
				CGplusplusFunc.refeshUIs()
			)
		)
		else ()
	)
	on addto pressed do
	(	sel=mt.selection as array
		SPmngAddtoValue[1]=num
		SPmngAddtoValue[2]=for j in sel where mt.items[j]!=ScenePromoter4Rol.sepStrs collect (spLibPath+"\\"+mt.items[j])
		if SPmngAddtoValue[2].count!=0 then 
		(	
			popupmenu SPmngAddto
		)
		else ()
	)
	on showfolder pressed do
		shellLaunch spRootPath ""
	on Rename pressed do
	(	
		sel=mt.selection as array
		if sel.count==1 then 
		(	if num<7 then
			(	if mt.items[sel[1]]!=ScenePromoter4Rol.sepStrs then CGplusplusFunc.renamebtn num sel[1]
				else CGplusplusFunc.msgbox "我是分隔线,行不改名,坐不改姓!"
			)
			else (CGplusplusFunc.renamescript mt.items[sel[1]])
		)
	)
	on editsp pressed do
	(
		sel=mt.selection as array
		if sel.count >= 1 then (
			for i in sel where mt.items[i]!=ScenePromoter4Rol.sepStrs do edit (spLibPath+"\\"+mt.items[i])
		)
		else ()
	)
	on btnlink pressed do
	(
		sel=mt.selection as array
		if sel.count >= 1 then (
			for i in sel where mt.items[i]!=ScenePromoter4Rol.sepStrs do 
			CGplusplusFunc.createLink (spLibPath+"\\"+mt.items[i])
			CGplusplusFunc.createLinkHint()
			if SPlinkmanage.open then SPlinkmanage.getLinks()
		)
		else ()
	)
	on delspt pressed do
	(
		sel=mt.selection as array
		if sel.count!=0 then (
			for i in sel.count to 1 by -1 do (
				deletefile (spLibPath+"\\"+mt.items[sel[i]])
			)
			mt.selection=0
			clearEptFN()
			CGplusplusFunc.refeshUIs()
		)
		else ()
	)
	on clearEpt pressed do
	(	clearEptFN()
		CGplusplusFunc.refeshUIs() 
	)
	on cls pressed do
		destroydialog SPmanageScripts
	on addEpt pressed do
	(
		CGplusplusFunc.addEpt num
		mt.selection=mt.items.count
	)
	on moveUp pressed do
	(	
		if num<7 then 
		(	sel=mt.selection as array
			if sel.count==1 and sel[1]>1 then (
				CGplusplusFunc.moveBtn num sel[1] state:#up
				mt.selection = sel[1]-1
			)
		)
		else ()
	)
	on moveDown pressed do
	(
		if num<7 then 
		(	sel=mt.selection as array
			if sel.count==1 and sel[1]<mt.items.count then (
				CGplusplusFunc.moveBtn num sel[1] state:#down
				mt.selection = sel[1]+1
			)
		)
		else ()
	)
)

--快捷方式
rollout SPlinkmanage "快捷方式管理" width:350 height:293
(
	multiListBox mt "快捷方式列表:" pos:[5,5] width:242 height:15
	button del "删除选择" pos:[257,84] width:80 height:18
	button refesh "刷新列表" pos:[257,62] width:80 height:18
	label hy "label" pos:[29,225] width:316 height:30
	button help "说 明" pos:[257,106] width:80 height:18
	button cls "退 出" pos:[257,128] width:80 height:18
	local thefiles=#(),thetxts=#()
	fn getLinks =
	(
		thefiles=getfiles (getdir #ui + "\\macroscripts\\FeilangTools-SP_*.mcr")
		thetxts=#()
		for ff in thefiles do
		(	f=openFile ff
			skipToString f "tooltip:\""
			append thetxts (readDelimitedString f "\"")
			close f
		)
		mt.items=thetxts
	)

	on SPlinkmanage open do
	(	str="此处的快捷方式均由场景助手自动生成, 删除后, 请到\n场景助手-->选项-->重启MAX后生效."
		hy.text=str
		getLinks()
	)
	on del pressed do
	(
		sel=mt.selection as array
		if sel.count!=0 then (
		for i in sel.count to 1 by -1 do 
		(	
			deletefile thefiles[sel[i]]
			deletefile (getdir #usermacros + "\\" +getfilenamefile thefiles[sel[i]]+getfilenametype thefiles[sel[i]])
		)
		mt.selection=0
		getLinks()
		)
		else CGplusplusFunc.msgbox "请选择一个快捷方式先:)"
	)
	on refesh pressed do
		getLinks()
	on help pressed do
	(
		try destroydialog SPLinkHint catch() ; createdialog SPLinkHint
	)
	on cls pressed do
		destroydialog SPlinkmanage
)
--数据同步
rollout SPdataSync "场景助手数据同步" width:432 height:210
(
	multiListBox lb "本机上3ds Max安装路径列表:" pos:[7,9] width:419 height:6
	button addFolder "添加路径" pos:[6,120] width:100 height:20
	button delfolder "删除路径" pos:[111,120] width:100 height:20
	button syncNow "马上同步" pos:[216,120] width:100 height:20
	button cls "退出" pos:[322,119] width:100 height:20
	label lbl1 "Label" pos:[7,150] width:415 height:60
	fn setPathINI arr =
	(	sort arr
		lb.items=arr
		delinisetting spInifilepath "Path"
		for i in 1 to arr.count do setinisetting spInifilepath "Path" ("p"+i as string) arr[i]
	)

	on SPdataSync open do
	(
		items01=getinisetting spInifilepath "Path"
		items02=for i in items01 collect (getinisetting spInifilepath "Path" i)
		curPath=CGplusplusFunc.slashConvert (getdir #maxroot)
		curPath=substring curPath 1 (curPath.count-1) --去掉最后面那个反斜杠\
		if finditem items02 curPath == 0 then append items02 curPath
		setPathINI items02
		
		str="单击 '马上同步' 按钮后，本 Max 下面的场景助手会被复制到路径列表中其他 Max 的对应路径，你的电脑上其他的 Max 的场景助手无需安装，且配置跟本 Max 一模一样。"
		lbl1.text=str
	)
	on addFolder pressed do
	(
		f=getsavepath caption:"请选择其他max安装目录"
		if f!=undefined then (
			f=CGplusplusFunc.slashConvert f
			if doesfileexist (f+"/3dsmax.exe") then (
				theitems=lb.items
				if finditem theitems f==0 then append theitems f
				setPathINI theitems
			)--end if
			else CGplusplusFunc.msgbox "这个文件夹下没有3dsmax.exe呢 ,你玩我的吧 ?"
		)--end if
	)
	on delfolder pressed do
	(
		sel=lb.selection as array
		theitems=lb.items
		if sel.count!=0 then
		(	for s in sel.count to 1 by -1 do deleteitem theitems sel[s]
			setPathINI theitems
		)	
	)
	on syncNow pressed do
	(
		CGplusplusFunc.dataSync()
	)
	on cls pressed do
		destroydialog SPdataSync
)

--生成快捷方式提示
rollout SPLinkHint "场景助手提示" width:302 height:96
(
	button btn1 "我知道啦!" pos:[50,71] width:77 height:18
	checkbox chk1 "以后不再显示" pos:[155,71] width:130 height:18
	label lbl1 "Label" pos:[13,9] width:277 height:55
	on SPLinkHint open do
	(
		str="快捷方式生成后,你可以在'Customize-->Customize User Interface...-->Category'列表的FeilangTools下面找到它."
		str+="你也可以到'场景助手-->选项-->快捷方式'删除它."
		lbl1.text=str
		spCreateLinkHint=try execute (getinisetting spInifilepath "Main" "Linkhint") catch true
		chk1.checked=not spCreateLinkHint
	)
	on btn1 pressed do
		destroydialog SPLinkHint
	on chk1 changed state do
	(
		if state then setinisetting spInifilepath "Main" "Linkhint" "false" 
			else setinisetting spInifilepath "Main" "Linkhint" "true"
	)
)
--主界面设置
rollout SPmainRolSet "主界面设置" width:278 height:323
(
	local spRolHeight=execute (getinisetting spInifilepath "Main" "Height")
	local spRolWidth=execute (getinisetting spInifilepath "Main" "Width")
	local size=sysInfo.DesktopSize
	local idx = (getinisetting spInifilepath "Color" "Index") as integer
	local total = (getinisetting spInifilepath "Color" "Total") as integer
	local tempName = "自定义"+localtime
	local oldColors = for i in 1 to 4 collect ScenePromoter4Rol.theColors[i]
	
	spinner hh "高度:" pos:[22,28] width:100 height:16 range:[100,800,500] type:#integer
	spinner ww "宽度:" pos:[22,52] width:100 height:16 range:[160,1280,160] type:#integer
	GroupBox grp1 "设置悬浮状态主界面参数" pos:[8,8] width:260 height:67
	button gogo "确定" pos:[127,28] width:48 height:40
	checkbox chk1 "主界面随Max自动启动" pos:[51,250] width:184 height:18
	button btnClose "关 闭" pos:[83,292] width:116 height:25
	button def "默认尺寸" pos:[181,27] width:80 height:18
	button defPos "默认位置" pos:[181,50] width:80 height:18
--	checkbox childui "子面板紧靠主界面" pos:[51,271] width:184 height:20
	GroupBox grp4 "界面颜色" pos:[8,82] width:260 height:163
	colorPicker colNav "导航背景" pos:[20,99] width:150 height:20
	colorPicker colBG "背景颜色" pos:[20,123] width:150 height:20
	colorPicker colLink "链接颜色" pos:[20,148] width:150 height:20
	colorPicker colTxt "文本颜色" pos:[20,173] width:150 height:20
	dropdownList ddl1 "选择配色方案:" pos:[22,197] width:147 height:41 items:#("默认")
	button btnOldCol "还原" pos:[179,191] width:80 height:18
	button RenameCol "重命名方案" pos:[179,216] width:80 height:18
	button DelCol "删除方案" pos:[179,98] width:80 height:18
	button SaveCol "保存方案" pos:[179,120] width:80 height:18
	
	fn setPreset =
	(
		items = ddl1.items
		if items[items.count] != tempName then
		(
			append items tempName
			ddl1.items = items
			idx = total + 1
		)
		ddl1.selection = ddl1.items.count
	)
	
	fn savePreset =
	(
		if idx > total then
		(
			str = (total+1) as string
			setinisetting spInifilepath "Color" "Index" str
			setinisetting spInifilepath "Color" "Total" str
			setinisetting spInifilepath "Color" ("Name"+str) ddl1.items[ddl1.selection]
			
			colstr = ""
			for i in 1 to 3 do 
			(
				colstr += ScenePromoter4Rol.theColors[i].r as string + "|"
				colstr += ScenePromoter4Rol.theColors[i].g as string + "|"
				colstr += ScenePromoter4Rol.theColors[i].b as string + "|"
			)
			colstr += ScenePromoter4Rol.theColors[4].r as string + "|"
			colstr += ScenePromoter4Rol.theColors[4].g as string + "|"
			colstr += ScenePromoter4Rol.theColors[4].b as string

			setinisetting spInifilepath "Color" ("Color"+str) colstr
			total = idx
		)
		tempName = "自定义"+localtime
		--else idx = ddl1.selection - 1
	)
	fn refeshList =
	(
		idx = (getinisetting spInifilepath "Color" "Index") as integer
		total = (getinisetting spInifilepath "Color" "Total") as integer
		names = for i in 1 to total collect (getinisetting spInifilepath "Color" ("Name" + i as string))
		items = #("默认")
		if names != 0 then 
		(
			join items names
		)
		ddl1.items = items
		ddl1.selection = idx + 1 
		
		cols = CGplusplusFunc.getUIcol()
		--链接字的颜色
		colLink.color = cols[1]
		--背景色
		colBG.color = cols[2]
		--文本颜色
		colTxt.color = cols[3]
		--导航背景
		colNav.color = cols[4]
		ScenePromoter4Rol.theColors = cols
	)

	on SPmainRolSet open do
	(	s=getinisetting spInifilepath "Main" "Mainuiauto"
		if s != "0" then chk1.checked = true
	--	s1=getinisetting spInifilepath "Main" "ChildUIPos"
	--	if s1 != "0" then childui.checked = true
		hh.value = execute (getinisetting spInifilepath "Main" "Height")
		ww.value = execute (getinisetting spInifilepath "Main" "Width")
		refeshList()
	)
	on SPmainRolSet close do
	(
		refeshList()
		ScenePromoter4Rol.refeshUIColor()
		ScenePromoter4Rol.refreshNav()
	)
	on gogo pressed do
	(
		setinisetting spInifilepath "Main" "Height" (hh.value as string) 
		setinisetting spInifilepath "Main" "Width" (ww.value as string) 
		CGplusplusFunc.restartMainRlt()
	)
	on chk1 changed state do
	(	if state then setinisetting spInifilepath "Main" "Mainuiauto" "1"
		else setinisetting spInifilepath "Main" "Mainuiauto" "0"
	)
	on SaveCol pressed do SavePreset()
	on btnClose pressed do
		destroydialog SPmainRolSet
	on def pressed do
	(	hh.value=500
		ww.value=160
		setinisetting spInifilepath "Main" "Height" "500"
		setinisetting spInifilepath "Main" "Width" "160"
		CGplusplusFunc.restartMainRlt()
	)
	on defPos pressed do
	(
		setinisetting spInifilepath "Main" "Pos" "[0,100]"
		CGplusplusFunc.restartMainRlt()
	)
	on childui changed state do
	(	if state then setinisetting spInifilepath "Main" "ChildUIPos" "1"
		else setinisetting spInifilepath "Main" "ChildUIPos" "0"
	)
	on colNav changed col do
	(
		setPreset()
		ScenePromoter4Rol.theColors[4] = col
		ScenePromoter4Rol.refreshNav()
	)
	on colBG changed col do
	(
		setPreset()
		ScenePromoter4Rol.theColors[2] = col
		ScenePromoter4Rol.refeshUIColor()
	)
	on colLink changed col do
	(
		setPreset()
		ScenePromoter4Rol.theColors[1] = col
		ScenePromoter4Rol.refeshUIColor()
	)
	on colTxt changed col do
	(
		setPreset()
		ScenePromoter4Rol.theColors[3] = col
		ScenePromoter4Rol.refeshUIColor()
	)
	on ddl1 selected sel do
	(
		setinisetting spInifilepath "Color" "Index" ((sel-1) as string)
		refeshList()
		ScenePromoter4Rol.refeshUIColor()
		ScenePromoter4Rol.refreshNav()
	)
	on btnOldCol pressed do
	(
		refeshList()
		ScenePromoter4Rol.refeshUIColor()
		ScenePromoter4Rol.refreshNav()
	)
	on RenameCol pressed do
	(
		if ddl1.selection != 1 then 
		(
			rollout renameTemp "重命名方案" width:221 height:32
			(
				editText edt1 "" pos:[7,5] width:163 height:21
				button rename "确定" pos:[178,5] width:40 height:20
				on rename pressed  do
				(
					if edt1.text != "" then
					(
						savePreset()
						setinisetting spInifilepath "Color" ("Name"+(idx as string)) edt1.text
						SPmainRolSet.refeshList()
					)
					destroydialog renameTemp
				)
			)
			createdialog renameTemp
		)
		else messagebox "默认方案还是不要改名的好~~~" title:"场景助手提示"
	)
	on DelCol pressed  do
	(
		if ddl1.selection != 1 then 
		(
			idx = (getinisetting spInifilepath "Color" "Index") as integer
			total = (getinisetting spInifilepath "Color" "Total") as integer
			if idx >= 1 and idx <= total then
			(
				names = for i in 1 to total collect (getinisetting spInifilepath "Color" ("Name" + i as string))
				colors = for i in 1 to total collect (getinisetting spInifilepath "Color" ("Color" + i as string))
				deleteitem names idx
				deleteitem colors idx
				delinisetting spInifilepath "Color" 
				
				idx -= 1
				total -= 1
				
				setinisetting spInifilepath "Color" "Index" (idx as string)
				setinisetting spInifilepath "Color" "Total" (total as string)
				for i in 1 to names.count do
				(
					setinisetting spInifilepath "Color" ("Name" + i as string)	names[i]
					setinisetting spInifilepath "Color" ("Color" + i as string) colors[i]
				)
			)
			refeshList()
			ScenePromoter4Rol.refeshUIColor()
			ScenePromoter4Rol.refreshNav()
		)
		else messagebox "默认方案还是留着的好~~~" title:"场景助手提示"
	)
)

--工具栏设置
rollout SPmtoolbarRolSet "工具栏设置" width:277 height:119
(
	local spRolHeight=execute (getinisetting spInifilepath "Main" "Height")
	local spRolWidth=execute (getinisetting spInifilepath "Main" "Width")
	local size=sysInfo.DesktopSize
	local idx = (getinisetting spInifilepath "Color" "Index") as integer
	local total = (getinisetting spInifilepath "Color" "Total") as integer
	local tempName = "自定义"+localtime
	local oldColors = for i in 1 to 4 collect ScenePromoter4Rol.theColors[i]
	
	spinner hh "高度:" pos:[22,28] width:100 height:16 range:[0,999,0] type:#integer
	spinner ww "宽度:" pos:[22,52] width:100 height:16 range:[0,999,0] type:#integer
	GroupBox grp1 "设置工具栏按钮长宽增加多少像素" pos:[8,8] width:260 height:67
	button gogo "确定" pos:[127,28] width:48 height:40
	button btnClose "关 闭" pos:[80,84] width:116 height:25
	button def "默认成0" pos:[181,29] width:80 height:38
	
	on SPmtoolbarRolSet open do
	(
		hh.value = SPToolBarHeightOffset
		ww.value = SPToolBarWidthOffset
	)
	on gogo pressed do
	(
		setinisetting spInifilepath "Main" "ToolBarHeightoffset" (hh.value as string)
		setinisetting spInifilepath "Main" "ToolBarWidthoffset" (ww.value as string)
		CGplusplusFunc.createToolbar thetype:spToolbarType
	)
	on btnClose pressed do
		destroydialog SPmtoolbarRolSet
	on def pressed do
	(	
		hh.value=0
		ww.value=0
		SPmtoolbarRolSet.gogo.pressed()
	)
)
--个性化
rollout SPmyPersTitle "个性化Max" width:347 height:318
(
	GroupBox grp1 "个性化标题栏" pos:[10,10] width:195 height:176
	checkbox isOpen "启用个性化标题栏" pos:[23,158] width:150 height:18
	checkbox filen "文件名" pos:[23,30] width:120 height:20
	checkbox filep "文件路径" pos:[23,50] width:120 height:18
	checkbox size "文件大小" pos:[23,70] width:120 height:20
	checkbox creDate "文件创建时间" pos:[23,90] width:120 height:20
	checkbox modDate "最后修改时间" pos:[23,110] width:120 height:18
	checkbox ver "Max版本" pos:[23,130] width:120 height:18
	GroupBox grp_display "显示/隐藏" pos:[219,10] width:117 height:108
	checkbox chk_slider "滑动条" pos:[235,30] width:90 height:18
	checkbox chk_frame "动画帧" pos:[235,50] width:90 height:21
	checkbox chk_status "状态栏" pos:[235,70] width:90 height:18
	checkbox chk_modify "修改面板" pos:[235,90] width:90 height:17
	radiobuttons rdo1 "选择框的样式" pos:[215,129] width:163 height:46 labels:#("Max 9及之前      ", "Max 2008及之后      ") default:1 columns:1
	label lbl1 "Label" pos:[12,231] width:330 height:46
	button btnClose "关 闭" pos:[124,282] width:111 height:27
	radiobuttons meditui "材质编辑器样式(Max 2011才用)" pos:[23,193] width:328 height:30 labels:#("Max 2010及之前        ", "Max 2011        ") columns:2
	local cont=#(filen,filep,size,creDate,modDate,ver)
	local tit=""
	--获取MAX版本
	fn getVer =
	(	v=(maxversion())[1]/1000
		if v<=9 then return v
		else return (2008+v-10)
	)
	--设置标题
	fn getStr n =
	(	filename=maxfilename
		filepath=CGplusplusFunc.SlashConvert maxfilepath
		file=filepath+filename
		if not doesfileexist file then (
			filename="Untitled"
			filepath=CGplusplusFunc.SlashConvert (getdir #Scene)
		)
		case n of
		(	1 : filename
			2 : filepath
			3 : (	thestr="大小:"
					fs=getFileSize file
					ss=fs/1024
					if ss < 1024 then thestr+=ss as string + " KB"
					else thestr+=(fs/1048576) as string + " MB"
					thestr
				)
			4 : ( 	s01="创建:"
					if not doesfileexist file then s01+="未创建" else s01+=getFileCreateDate file
					s01
				)
			5 : (	s01="修改:"
					if not doesfileexist file then s01+="未修改" else s01+=getFileModDate file
					s01
				)
			6 : "3ds Max "+(getVer()) as string
			default : ""
		)
	)
	fn setTitle content:"" =
	(	str=""
		idx=findstring content "1"
		if idx!=undefined then 
		(	str+=getStr idx
			for t in idx+1 to 6 where content[t]!=undefined and content[t]!="0" do str+="  -  " + getStr t
		)
		if str.count==0 then str="请在场景助手-->选项-->个性化Max 中定制此处标题"
		cui.setAppTitle str
	)
	--定制标题栏
	fn setTheTitle =
	(	tit=getinisetting spInifilepath "Main" "PerTitle"
		SPmyPersTitle.setTitle content:tit
	)
	--开关
	fn switchTitle state:false =
	(	callbacks.removeScripts id:#setThePersTitle
		if state then
		(	tit=getinisetting spInifilepath "Main" "PerTitle"
			SPmyPersTitle.setTitle content:tit
			callbacks.addScript #filePostOpen "SPmyPersTitle.setTheTitle()" id:#setThePersTitle
			callbacks.addScript #filePostSave "SPmyPersTitle.setTheTitle()" id:#setThePersTitle
			callbacks.addScript #systemPostReset "SPmyPersTitle.setTheTitle()" id:#setThePersTitle
			callbacks.addScript #systemPostNew "SPmyPersTitle.setTheTitle()" id:#setThePersTitle
		)
		else ()
	)
	--配置文件路径
	fn getINIpath = 
	(	
		thepath = getFilenamePath (getmaxinifile())+"defaults\\*"
		dirs = getDirectories thepath
		for d in dirs do
		(	
			file=d+"\\CurrentDefaults.ini"
			if doesfileexist file then return file 
			else (
				dirs01 = getDirectories (d+"*")
				for d01 in dirs01 do (
					file01 = d01+"\\CurrentDefaults.ini"
					if doesfileexist file then return file01
				)--end for
			)--end else
		)--end for
		""
	)
	on SPmyPersTitle open do
	(	str="启用个性化标题栏后，Max标题栏将按照指定内容进行显示，\n一直生效。"
		str+="关闭个性化标题栏后，新建Max，重置Max或者打开\n一个Max文件后还原。"
		lbl1.text=str
		
		if timeSlider.isVisible() then chk_slider.checked = true else chk_slider.checked = false
		if trackbar.visible then chk_frame.checked = true else chk_frame.checked = false
		if statusPanel.visible then chk_status.checked = true else chk_status.checked = false
		if cui.commandPanelOpen then chk_modify.checked = true else chk_modify.checked = false
		
		maxinipath=getINIpath()
		ss=getINISetting maxinipath "Scene Explorer" "SelectByNameUsesSceneExplorer"
		format "%\t%\n" ss rdo1.state
		if ss == "1" then rdo1.state = 2 else rdo1.state=1
		
		tit=getinisetting spInifilepath "Main" "PerTitle"
		for t in 1 to 6 do if tit[t]=="0" then cont[t].checked=false else cont[t].checked=true
		st=getinisetting spInifilepath "Main" "PerTitOpen"
		if st=="1" then isOpen.checked=true
		else (isOpen.checked=false;for i in cont do i.enabled=false)
		thever=maxversion()
		if thever[1]>=13000 then (
			str="SPmyPersTitle.meditui.state=case maxOps.mtlDlgMode of ( #basic : 1\ndefault : 2)"
			execute str
		)
	)
	on isOpen changed st do
	(	if st then
		(	setTheTitle()
			for i in cont do i.enabled=true
			setinisetting spInifilepath "Main" "PerTitOpen" "1"
		)
		else (
			for i in cont do i.enabled=false
			setinisetting spInifilepath "Main" "PerTitOpen" "0"
		)
		switchTitle state:st
	)
	on filen changed state do
	(	if state then tit[1]="1"
		else tit[1]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on filep changed state do
	(	if state then tit[2]="1"
		else tit[2]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on size changed state do
	(	if state then tit[3]="1"
		else tit[3]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on creDate changed state do
	(	if state then tit[4]="1"
		else tit[4]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on modDate changed state do
	(	if state then tit[5]="1"
		else tit[5]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on ver changed state do
	(	if state then tit[6]="1"
		else tit[6]="0"
		setTitle content:tit
		setinisetting spInifilepath "Main" "PerTitle" tit
	)
	on chk_slider changed state do
	(
		if state then timeSlider.setVisible true else timeSlider.setVisible false
	)
	on chk_frame changed state do
	(
	 	if state then trackbar.visible = true else trackbar.visible = false
	)
	on chk_status changed state do
	(
		if state then statusPanel.visible = true else statusPanel.visible = false
	)
	on chk_modify changed state do
	(
		if state then cui.commandPanelOpen = true else cui.commandPanelOpen = false
	)
	on rdo1 changed stat do
	(	maxinipath=getINIpath()
		case stat of
		(	1: (
				setINISetting maxinipath "Scene Explorer" "SelectByNameUsesSceneExplorer" "0"
				)
			2: (
				setINISetting maxinipath "Scene Explorer" "SelectByNameUsesSceneExplorer" "1"
				)
		)
	)
	on btnClose pressed do
		destroydialog SPmyPersTitle
	on meditui changed stat do
	(	thever=maxversion()
		if thever[1]>=13000 then 
		(	if stat==1 then execute "maxOps.mtlDlgMode=0" else execute "maxOps.mtlDlgMode=1"
		)
		else ()
	)
)
rollout SPabtRol "关于场景助手" width:319 height:262
(
	imgtag img "" bitmap:(openbitmap (spRootPath+"\\images\\logo.gif")) pos:[200,25]
	label lbl1 "Label" pos:[38,30] width:150 height:70
	label lbl2 "Label" pos:[38,120] width:250 height:70

	HyperLink hy "www.cgplusplus.com" pos:[38,99] width:100 height:15 address:"http://www.cgplusplus.com/" color:(color 0 128 128) hovercolor:(color 128 0 255) visitedcolor:(color 0 128 128)
	HyperLink hy1 "公众号：山医命象卜下载新脚本" pos:[38,180] width:150 height:15 address:"http://mp.weixin.qq.com/mp/homepage?__biz=MzA4NjQ2MDYzMA==&hid=1&sn=bb2531d86a7d41ca361cca9081151faa&scene=18#wechat_redirect" color:(color 0 128 128) hovercolor:(color 128 0 255) visitedcolor:(color 0 128 128)
	button okok "确 定" pos:[205,214] width:80 height:18
	on SPabtRol open do
	(	
		ver="4.1.10"--getinisetting spInifilepath "Main" "Version"
		str="场景助手\n\n版本: "+ver+"\n作者: 山医命相卜\nQQ群: 756653752"
		lbl1.text=str
		lbl2.text = "本版本适用于3dmax9-2028.系统支持32位.64位,WinXP/Win7~11."
	)
	on okok pressed do
	(
		destroydialog SPabtRol
	)
)

