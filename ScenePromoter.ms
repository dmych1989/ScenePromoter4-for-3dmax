--��������4.1.00

--���ߣ�����
--Author:Feilang
--------------------------------------------------
--��ӭʹ�ó�������4.0 

----��Դ����----

---------------------------------------------------
--��������4.1 	2012-02-01
--��������4.0		2011-04-01
--��������3.0		2009-08-01
--��������2.6		2009-03-30
--��������2.0		2008-08-06
--��������1.0		2008-05-27

--����

--setting menu toolbar
--setting menu main ui
rcmenu SPsettingMenu 
(	--ѡ��˵�
	fn filterAdd = ScenePromoter4Rol.listID!=1
	fn setStrs =
	(
		strs = #()
		append strs "1��������һ���ó������֣������ȿ�һ�³�������"
		append strs "��ϸʹ��˵����������ù���������3.0����ǰ�汾��"
		append strs "���������Ǹ�4.0����Ƶ����Ȼ��ͨ������׼��Ҳ������"
		append strs ""
		append strs "2����������4.1�Ľ�����д�ˣ����Ǹ�4.0�仯����"
		append strs "ĳЩ���ܿ��ܻ�λ���ˡ�"
		append strs ""
		append strs "3��Ĭ�ϴ�Max��������Զ���������ѡ���������"
		append strs "����ȡ����ѡ[ ��������Max�Զ����� ] ���ɹص���"
		append strs ""
		append strs "4��Vray������������4.0�������ˣ�ֻ��û��֪��ң�"
		append strs "֧�ֶ�ѡ�ˣ�������һЩ���ܡ�"
		append strs ""
		append strs "5��3.0�汾�� [ ��Ԫ�ط��� ] �� [ �������� ] ���档"
		append strs ""
		append strs "6��[ ������ʧ��ͼ ] ���Ե�����ʧ��Ϣ��"
		append strs ""
		append strs "7�������������˵��������Ե�������ɫ��һ�������ס�"
		append strs "�ǵñ�������ķ�����"
		append strs ""
		append strs "8���������ұ��Ǹܸܿ��԰ѽ��������������Ծ����ס�"
		append strs ""
		append strs ""
		strs
	)
	subMenu "����"
	(
		menuItem addOne "����һ���ű�" enabled:(ScenePromoter4Rol.listID!=1)
		menuItem addFolder "���ӽű��ļ���" enabled:(ScenePromoter4Rol.listID!=1)
		menuItem addExe "����exe�ļ�" enabled:(ScenePromoter4Rol.listID!=1)
		menuItem addSep "���ӿ���" enabled:(ScenePromoter4Rol.listID!=1)
		menuItem addEpt "�½��ű�" enabled:(ScenePromoter4Rol.listID!=1)
	)
	subMenu "����ͣ��"
	(
		menuItem dockleft "��ͣ��"
		menuItem dockright "��ͣ��"
		menuItem floatstate "����״̬"
	)
	menuItem setui "��������"

	subMenu "������"
	(
		menuItem topBar "ͣ������"
		menuItem btmBar "ͣ���ײ�"
		menuItem btnSize "��ť��С����"
		separator sp2012
		menuItem autoSt "�Ƿ���Max����" checked:spShowtoolbar
		menuItem closeBar "�رչ�����"
	)
	separator sp01
	menuItem manage "�ű�����"
	menuItem backup "����ͬ��"
	menuItem linkmng "��ݷ�ʽ"
	separator sp02
	menuItem mytitle "���Ի�Max"
	menuItem restart "����Max"
	separator sp03
	subMenu "����"
	(
		menuItem doc01 "����˵��"
		menuItem doc02 "����������ϸʹ��˵��"
	)
	menuItem abt "����"
	separator sp04
	menuItem uninstall "ж��"

	
	--���Ի�	
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
	--����
	on addOne picked do
	(
		f=getOpenFileName caption:"����һ���ű������ֹ�����" types:"*.ms, or *.mse|*.ms*"
		if f!=undefined then
		(
			CGplusplusFunc.addBtn ScenePromoter4Rol.listID files:#(f)
		)
	)
	on addFolder picked do
	(
		f=getSavePath  caption:"����һ���ļ���"
		if f!=undefined then
		(	thefile=getfiles (f+"\\*.ms")
			join thefile (getfiles (f+"\\*.mse"))
				if thefile[1]!=undefined then CGplusplusFunc.addBtn ScenePromoter4Rol.listID files:thefile
		)
	)
	on addExe picked do
	(	
		f=getOpenFileName caption:"����һ����ִ���ļ�" types:"*.exe|*.exe"
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

	--������
	on topBar picked do CGplusplusFunc.createToolbar thetype:#top
	on btmBar picked do CGplusplusFunc.createToolbar thetype:#bottom
	on closeBar picked do CGplusplusFunc.closeToolbar()
	on autoSt picked do (
		if spShowtoolbar then setinisetting spInifilepath "Main" "Toolbar" "false"
			else setinisetting spInifilepath "Main" "Toolbar" "true"
	)
	on btnSize picked do (destroydialog SPmtoolbarRolSet ; CGplusplusFunc.createChild SPmtoolbarRolSet width:277)

	--�ű�����
	on manage picked do (
		try destroydialog SPmanageScripts catch ()
		CGplusplusFunc.createChild SPmanageScripts width:350
		thenum=ScenePromoter4Rol.listID
		if thenum==1 then thenum=2
		SPmanageScripts.refeshList thenum
		)
	--ͬ��
	on backup picked do (destroydialog SPdataSync ; CGplusplusFunc.createChild SPdataSync width:432)
	on linkmng picked do (destroydialog SPlinkmanage ; CGplusplusFunc.createChild SPlinkmanage width:350)
	on restart picked do CGplusplusFunc.restartMax()
	on abt picked do (
		destroydialog SPabtRol
		createdialog SPabtRol fgcolor:(color 0 123 238) bgcolor:white
	)
	on uninstall picked do CGplusplusFunc.unInstall()
	--����
	on doc01 picked do
	(
		rollout doc01rol "�����ĵ�" width:352 height:306
		(
			listbox lb "" pos:[13,7] width:323 height:17
			button btn1 "�ر�" pos:[93,263] width:158 height:25
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
(	--ѡ��˵�,������
	subMenu "����"
	(
		menuItem addOne "����һ���ű�"
		menuItem addFolder "���ӽű��ļ���"
		menuItem addExe "����exe�ļ�"
		menuItem addEpt "�½��ű�"
	)
	subMenu "����ͣ��"
	(
		menuItem dockleft "��ͣ��"
		menuItem dockright "��ͣ��"
		menuItem floatstate "����״̬"
	)
	menuItem setui "��������"
	subMenu "������"
	(
		menuItem topBar "ͣ������"
		menuItem btmBar "ͣ���ײ�"
		menuItem btnSize "��ť��С����"
		separator sp2012
		menuItem autoSt "�Ƿ���Max����" checked:spShowtoolbar
		menuItem closeBar "�رչ�����"
	)
	separator sp01
	menuItem manage "�ű�����"
	menuItem backup "����ͬ��"
	menuItem linkmng "��ݷ�ʽ"
	separator sp02
	menuItem mytitle "���Ի�Max"
	menuItem restart "����Max"
	separator sp03
	subMenu "����"
	(
		menuItem doc01 "����˵��"
		menuItem doc02 "����������ϸʹ��˵��"
	)
	menuItem abt "����"
	separator sp04
	menuItem uninstall "ж��"
	on mytitle picked do (destroydialog SPmyPersTitle;CGplusplusFunc.createChild SPmyPersTitle width:347)
	--��������
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
	--����
	on addOne picked do
	(
		f=getOpenFileName caption:"����һ���ű������ֹ�����" types:"*.ms, or *.mse|*.ms*"
		if f!=undefined then
		(
			CGplusplusFunc.addBtn 6 files:#(f)
		)
	)
	on addFolder picked do
	(
		f=getSavePath  caption:"����һ���ļ���"
		if f!=undefined then
		(	thefile=getfiles (f+"\\*.ms")
			join thefile (getfiles (f+"\\*.mse"))
				if thefile[1]!=undefined then CGplusplusFunc.addBtn 6 files:thefile
		)
	)
	on addExe picked do
	(	
		f=getOpenFileName caption:"����һ����ִ���ļ�" types:"*.exe|*.exe"
		if f!=undefined then
		(
			CGplusplusFunc.addExe 6 f
		)
	)
	on addEpt picked do
	(
		CGplusplusFunc.addEpt 6
	)
	--������
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
	--����
	on doc01 picked do
	(
		rollout doc01rol "�����ĵ�" width:352 height:306
		(
			listbox lb "" pos:[13,7] width:323 height:17
			button btn1 "�ر�" pos:[93,263] width:158 height:25
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
--�ű�����,���ӵ�...
global SPmngAddtoValue=#()
rcmenu SPmngAddto 
(	fn filterFN2 = SPmngAddtoValue[1]!=2
	fn filterFN3 = SPmngAddtoValue[1]!=3
	fn filterFN4 = SPmngAddtoValue[1]!=4
	fn filterFN5 = SPmngAddtoValue[1]!=5
	fn filterFN6 = SPmngAddtoValue[1]!=6
	menuItem s2 "���ӵ��ڶ���" filter:filterFN2
	menuItem s3 "���ӵ�������" filter:filterFN3
	menuItem s4 "���ӵ�������" filter:filterFN4
	menuItem s5 "���ӵ�������" filter:filterFN5
	menuItem s6 "���ӵ����ֹ�����" filter:filterFN6
	on s2 picked do CGplusplusFunc.addBtn 2 files:SPmngAddtoValue[2]
	on s3 picked do CGplusplusFunc.addBtn 3 files:SPmngAddtoValue[2]
	on s4 picked do CGplusplusFunc.addBtn 4 files:SPmngAddtoValue[2]
	on s5 picked do CGplusplusFunc.addBtn 5 files:SPmngAddtoValue[2]
	on s6 picked do CGplusplusFunc.addBtn 6 files:SPmngAddtoValue[2]
)
--manage scripts
rollout SPmanageScripts "�ű�����" width:350 height:350
(
	checkbutton btn2 "�ڶ���" pos:[4,3] width:46 height:18
	checkbutton btn3 "������" pos:[53,3] width:46 height:18
	checkbutton btn4 "������" pos:[102,3] width:46 height:18
	checkbutton btn5 "������" pos:[151,3] width:46 height:18
	checkbutton btn6 "������" pos:[201,3] width:46 height:18
	checkbutton nohome "�޼ҿɹ�" pos:[252,3] width:60 height:18
	multiListBox mt "����ѡ���б�" pos:[5,26] width:242 height:16
	button del "ɾ����ť" pos:[251,127] width:95 height:18 toolTip:"ɾ��ѡ��ť,�ɶ�ѡ"
	button addto "���ӵ�..." pos:[251,42] width:95 height:18 toolTip:"���ӵ�������,�ɶ�ѡ"
	button showfolder "Դ�����ļ���" pos:[251,210] width:95 height:18 toolTip:"���ļ���"
	button Rename "������" pos:[251,85] width:95 height:18 toolTip:"�������ű�ͬʱ���İ�ť,��ѡ"
	button editsp "�༭����" pos:[251,106] width:95 height:18 toolTip:"�򿪽ű�,�ɶ�ѡ"
	button btnlink "���ɿ�ݷ�ʽ" pos:[251,189] width:95 height:18 toolTip:"�ɶ�ѡ"
	button delspt "ɾ���ű�(����)" pos:[251,168] width:95 height:18 toolTip:"ɾ���ű�,��ɾ����֮��ص����а�ť"
	label hy1 "Label" pos:[20,262] width:350 height:40
	button clearEpt "����հ�ť" pos:[251,147] width:95 height:18 toolTip:"���Lib�ļ������޴��ļ������ذ�ť"
	button cls "�� ��" pos:[130,310] width:95 height:25
	button addEpt "�½��ű�" pos:[251,64] width:95 height:18
	button moveUp "����" pos:[251,231] width:46 height:18
	button moveDown "����" pos:[300,232] width:46 height:18
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
	(	--����հ�ť
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
	(	--�ռ����޼ҿɹ顱�ű�
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
		--��ȡ�ű��ļ�·��
		itemsFile=#()
		itemsTxtArr=getinisetting spIniCategory ("S"+s as string)
		for j in itemsTxtArr do (
		temp=getinisetting spIniCategory ("S"+s as string) j
			if temp=="undefined" then temp="--------�����ǿ���"
		append itemsFile temp
		)--end for
		mt.items=itemsFile
	)

	on SPmanageScripts open do
	(	str="���� '������' ' ���� ' ' ���� ' ����,�������ɶ�ѡ;'�޼ҿɹ�' \nָLib�ļ������д˽ű�,"
		str+="����û�����ӵ�������������\n��һ���İ�ť����ݳ�����̬���������ṩ������"
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
				else CGplusplusFunc.msgbox "���Ƿָ���,�в�����,��������!"
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

--��ݷ�ʽ
rollout SPlinkmanage "��ݷ�ʽ����" width:350 height:293
(
	multiListBox mt "��ݷ�ʽ�б�:" pos:[5,5] width:242 height:15
	button del "ɾ��ѡ��" pos:[257,84] width:80 height:18
	button refesh "ˢ���б�" pos:[257,62] width:80 height:18
	label hy "label" pos:[29,225] width:316 height:30
	button help "˵ ��" pos:[257,106] width:80 height:18
	button cls "�� ��" pos:[257,128] width:80 height:18
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
	(	str="�˴��Ŀ�ݷ�ʽ���ɳ��������Զ�����, ɾ����, �뵽\n��������-->ѡ��-->����MAX����Ч."
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
		else CGplusplusFunc.msgbox "��ѡ��һ����ݷ�ʽ��:)"
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
--����ͬ��
rollout SPdataSync "������������ͬ��" width:432 height:210
(
	multiListBox lb "������3ds Max��װ·���б�:" pos:[7,9] width:419 height:6
	button addFolder "����·��" pos:[6,120] width:100 height:20
	button delfolder "ɾ��·��" pos:[111,120] width:100 height:20
	button syncNow "����ͬ��" pos:[216,120] width:100 height:20
	button cls "�˳�" pos:[322,119] width:100 height:20
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
		curPath=substring curPath 1 (curPath.count-1) --ȥ��������Ǹ���б��\
		if finditem items02 curPath == 0 then append items02 curPath
		setPathINI items02
		
		str="���� '����ͬ��' ��ť�󣬱� Max ����ĳ������ֻᱻ���Ƶ�·���б������� Max �Ķ�Ӧ·������ĵ����������� Max �ĳ����������谲װ�������ø��� Max һģһ����"
		lbl1.text=str
	)
	on addFolder pressed do
	(
		f=getsavepath caption:"��ѡ������max��װĿ¼"
		if f!=undefined then (
			f=CGplusplusFunc.slashConvert f
			if doesfileexist (f+"/3dsmax.exe") then (
				theitems=lb.items
				if finditem theitems f==0 then append theitems f
				setPathINI theitems
			)--end if
			else CGplusplusFunc.msgbox "����ļ�����û��3dsmax.exe�� ,�����ҵİ� ?"
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

--���ɿ�ݷ�ʽ��ʾ
rollout SPLinkHint "����������ʾ" width:302 height:96
(
	button btn1 "��֪����!" pos:[50,71] width:77 height:18
	checkbox chk1 "�Ժ�����ʾ" pos:[155,71] width:130 height:18
	label lbl1 "Label" pos:[13,9] width:277 height:55
	on SPLinkHint open do
	(
		str="��ݷ�ʽ���ɺ�,�������'Customize-->Customize User Interface...-->Category'�б���FeilangTools�����ҵ���."
		str+="��Ҳ���Ե�'��������-->ѡ��-->��ݷ�ʽ'ɾ����."
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
--����������
rollout SPmainRolSet "����������" width:278 height:323
(
	local spRolHeight=execute (getinisetting spInifilepath "Main" "Height")
	local spRolWidth=execute (getinisetting spInifilepath "Main" "Width")
	local size=sysInfo.DesktopSize
	local idx = (getinisetting spInifilepath "Color" "Index") as integer
	local total = (getinisetting spInifilepath "Color" "Total") as integer
	local tempName = "�Զ���"+localtime
	local oldColors = for i in 1 to 4 collect ScenePromoter4Rol.theColors[i]
	
	spinner hh "�߶�:" pos:[22,28] width:100 height:16 range:[100,800,500] type:#integer
	spinner ww "����:" pos:[22,52] width:100 height:16 range:[160,1280,160] type:#integer
	GroupBox grp1 "��������״̬���������" pos:[8,8] width:260 height:67
	button gogo "ȷ��" pos:[127,28] width:48 height:40
	checkbox chk1 "��������Max�Զ�����" pos:[51,250] width:184 height:18
	button btnClose "�� ��" pos:[83,292] width:116 height:25
	button def "Ĭ�ϳߴ�" pos:[181,27] width:80 height:18
	button defPos "Ĭ��λ��" pos:[181,50] width:80 height:18
--	checkbox childui "��������������" pos:[51,271] width:184 height:20
	GroupBox grp4 "������ɫ" pos:[8,82] width:260 height:163
	colorPicker colNav "��������" pos:[20,99] width:150 height:20
	colorPicker colBG "������ɫ" pos:[20,123] width:150 height:20
	colorPicker colLink "������ɫ" pos:[20,148] width:150 height:20
	colorPicker colTxt "�ı���ɫ" pos:[20,173] width:150 height:20
	dropdownList ddl1 "ѡ����ɫ����:" pos:[22,197] width:147 height:41 items:#("Ĭ��")
	button btnOldCol "��ԭ" pos:[179,191] width:80 height:18
	button RenameCol "����������" pos:[179,216] width:80 height:18
	button DelCol "ɾ������" pos:[179,98] width:80 height:18
	button SaveCol "���淽��" pos:[179,120] width:80 height:18
	
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
		tempName = "�Զ���"+localtime
		--else idx = ddl1.selection - 1
	)
	fn refeshList =
	(
		idx = (getinisetting spInifilepath "Color" "Index") as integer
		total = (getinisetting spInifilepath "Color" "Total") as integer
		names = for i in 1 to total collect (getinisetting spInifilepath "Color" ("Name" + i as string))
		items = #("Ĭ��")
		if names != 0 then 
		(
			join items names
		)
		ddl1.items = items
		ddl1.selection = idx + 1 
		
		cols = CGplusplusFunc.getUIcol()
		--�����ֵ���ɫ
		colLink.color = cols[1]
		--����ɫ
		colBG.color = cols[2]
		--�ı���ɫ
		colTxt.color = cols[3]
		--��������
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
			rollout renameTemp "����������" width:221 height:32
			(
				editText edt1 "" pos:[7,5] width:163 height:21
				button rename "ȷ��" pos:[178,5] width:40 height:20
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
		else messagebox "Ĭ�Ϸ������ǲ�Ҫ�����ĺ�~~~" title:"����������ʾ"
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
		else messagebox "Ĭ�Ϸ����������ŵĺ�~~~" title:"����������ʾ"
	)
)

--����������
rollout SPmtoolbarRolSet "����������" width:277 height:119
(
	local spRolHeight=execute (getinisetting spInifilepath "Main" "Height")
	local spRolWidth=execute (getinisetting spInifilepath "Main" "Width")
	local size=sysInfo.DesktopSize
	local idx = (getinisetting spInifilepath "Color" "Index") as integer
	local total = (getinisetting spInifilepath "Color" "Total") as integer
	local tempName = "�Զ���"+localtime
	local oldColors = for i in 1 to 4 collect ScenePromoter4Rol.theColors[i]
	
	spinner hh "�߶�:" pos:[22,28] width:100 height:16 range:[0,999,0] type:#integer
	spinner ww "����:" pos:[22,52] width:100 height:16 range:[0,999,0] type:#integer
	GroupBox grp1 "���ù�������ť�������Ӷ�������" pos:[8,8] width:260 height:67
	button gogo "ȷ��" pos:[127,28] width:48 height:40
	button btnClose "�� ��" pos:[80,84] width:116 height:25
	button def "Ĭ�ϳ�0" pos:[181,29] width:80 height:38
	
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
--���Ի�
rollout SPmyPersTitle "���Ի�Max" width:347 height:318
(
	GroupBox grp1 "���Ի�������" pos:[10,10] width:195 height:176
	checkbox isOpen "���ø��Ի�������" pos:[23,158] width:150 height:18
	checkbox filen "�ļ���" pos:[23,30] width:120 height:20
	checkbox filep "�ļ�·��" pos:[23,50] width:120 height:18
	checkbox size "�ļ���С" pos:[23,70] width:120 height:20
	checkbox creDate "�ļ�����ʱ��" pos:[23,90] width:120 height:20
	checkbox modDate "����޸�ʱ��" pos:[23,110] width:120 height:18
	checkbox ver "Max�汾" pos:[23,130] width:120 height:18
	GroupBox grp_display "��ʾ/����" pos:[219,10] width:117 height:108
	checkbox chk_slider "������" pos:[235,30] width:90 height:18
	checkbox chk_frame "����֡" pos:[235,50] width:90 height:21
	checkbox chk_status "״̬��" pos:[235,70] width:90 height:18
	checkbox chk_modify "�޸����" pos:[235,90] width:90 height:17
	radiobuttons rdo1 "ѡ������ʽ" pos:[215,129] width:163 height:46 labels:#("Max 9��֮ǰ      ", "Max 2008��֮��      ") default:1 columns:1
	label lbl1 "Label" pos:[12,231] width:330 height:46
	button btnClose "�� ��" pos:[124,282] width:111 height:27
	radiobuttons meditui "���ʱ༭����ʽ(Max 2011����)" pos:[23,193] width:328 height:30 labels:#("Max 2010��֮ǰ        ", "Max 2011        ") columns:2
	local cont=#(filen,filep,size,creDate,modDate,ver)
	local tit=""
	--��ȡMAX�汾
	fn getVer =
	(	v=(maxversion())[1]/1000
		if v<=9 then return v
		else return (2008+v-10)
	)
	--���ñ���
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
			3 : (	thestr="��С:"
					fs=getFileSize file
					ss=fs/1024
					if ss < 1024 then thestr+=ss as string + " KB"
					else thestr+=(fs/1048576) as string + " MB"
					thestr
				)
			4 : ( 	s01="����:"
					if not doesfileexist file then s01+="δ����" else s01+=getFileCreateDate file
					s01
				)
			5 : (	s01="�޸�:"
					if not doesfileexist file then s01+="δ�޸�" else s01+=getFileModDate file
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
		if str.count==0 then str="���ڳ�������-->ѡ��-->���Ի�Max �ж��ƴ˴�����"
		cui.setAppTitle str
	)
	--���Ʊ�����
	fn setTheTitle =
	(	tit=getinisetting spInifilepath "Main" "PerTitle"
		SPmyPersTitle.setTitle content:tit
	)
	--����
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
	--�����ļ�·��
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
	(	str="���ø��Ի���������Max������������ָ�����ݽ�����ʾ��\nһֱ��Ч��"
		str+="�رո��Ի����������½�Max������Max���ߴ�\nһ��Max�ļ���ԭ��"
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
rollout SPabtRol "���ڳ�������" width:319 height:262
(
	imgtag img "" bitmap:(openbitmap (spRootPath+"\\images\\logo.gif")) pos:[200,25]
	label lbl1 "Label" pos:[38,30] width:150 height:70
	label lbl2 "Label" pos:[38,120] width:250 height:70

	HyperLink hy1 "���ںţ�ɽҽ���������½ű�" pos:[38,180] width:150 height:15 address:"http://mp.weixin.qq.com/mp/homepage?__biz=MzA4NjQ2MDYzMA==&hid=1&sn=bb2531d86a7d41ca361cca9081151faa&scene=18#wechat_redirect" color:(color 0 128 128) hovercolor:(color 128 0 255) visitedcolor:(color 0 128 128)
	button okok "ȷ ��" pos:[205,214] width:80 height:18
	on SPabtRol open do
	(	
		ver="4.1.10"--getinisetting spInifilepath "Main" "Version"
		str="��������\n\n�汾: "+ver+"\n����: ɽҽ���ಷ\nQQȺ: 756653752"
		lbl1.text=str
		lbl2.text = "���汾������3dmax9-2028.ϵͳ֧��32λ.64λ,WinXP/Win7~11."
	)
	on okok pressed do
	(
		destroydialog SPabtRol
	)
)

