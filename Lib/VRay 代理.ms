-- VRay��������2.0
-- ���ߣ����� 
-- 2011.04.06

--VRay����������1.0
--���ߣ����� 
--2008-11-3

--------------------------------------------------
--��ӭʹ�ó�������4.0 

----��Դ����----

---------------------------------------------------
--��������4.0		2011-04-01
--��������3.0		2009-08-01
--��������2.6		2009-03-30
--��������2.0		2008-08-06
--��������1.0		2008-05-27

try destroydialog fl_vrayproxyMgr2 catch()
global fl_vrayproxyMgr2,fl_collectVRayProxies
rollout fl_vrayproxyMgr2 "VRay��������2.0" width:457 height:396
(
	multiListBox lbx_vrayProxyPaths "VRay����·���б���" pos:[4,65] width:450 height:12
	radiobuttons rdo_area "��ʾ������" pos:[8,5] width:135 height:46 labels:#("����VRay����    ", "��ʧVRay����    ") default:1 columns:1
	button btn_setPath "����·��" pos:[5,252] width:95 height:18
	radiobuttons rdo_display "Display (ѡ�д�������ʾ��ʽ)��" pos:[176,3] width:408 height:62 labels:#("bounding box(�߽��)                  ", "preview from file(���ļ�Ԥ��)                          ", "point(��)           ") columns:1
	button btn_select "ѡ���������" pos:[106,252] width:95 height:18

	GroupBox grp1 "����б�ѡ��Ĵ���" pos:[4,279] width:447 height:108
	edittext edt_output "���·����" pos:[14,298] width:365 height:20 
	button btn_begin "��ʼ���" pos:[320,335] width:126 height:40 
	button btn_browse "ѡ��" pos:[387,299] width:60 height:18
	checkbox colmap "˳�����������õ�����ͼ" pos:[15,343] width:209 height:18 checked:true
	checkbox updvr "����VRay����·��" pos:[15,322] width:133 height:16 checked:true
	checkbox updmap "���´���������ͼ·��" pos:[15,362] width:197 height:18 checked:true
	--�ռ�����VRay����
	fn fl_collectAllVrayProxies = 
	(	allVP = #()
		for i in geometry where classof i == VRayProxy do
		( 	
			f = i.filename
			if findItem allVP f == 0 then append allVP f
		)
		if allVP.count != 0 then lbx_vrayProxyPaths.items = allVP --Defined the listbox
		else lbx_vrayProxyPaths.items =#( "û���ҵ�VRay����")
	)
	--�ռ���ʧVRay����
	fn fl_collectMissVrayProxies =
	(
		missVP = #()
		for i in geometry where classof i == VRayProxy do
		( 	
			f = i.filename
			if findItem missVP f == 0 and not doesfileexist f then append missVP f
		)
		if missVP.count != 0 then lbx_vrayProxyPaths.items = missVP --Defined the listbox
		else lbx_vrayProxyPaths.items = #( "û���ҵ���ʧVRay����")
	)
	--��������·���ռ�VRay����
	fn fl_collectGivenVP arr =
	(	colVP = #()
		for i in geometry while not isDeleted i where classof i == VRayProxy do
		( 	
			f = i.filename
			if finditem arr f != 0 then append colVP i
		)
		colVP
	)
	--�ж��ļ���
	fn fl_ifVrmesh thepath = if getFilenameType thepath == ".vrmesh" then return true else return false
	fn fl_getTheInstanceVP thepath =
	(	local tempObj=#();i = 1
		if fl_ifVrmesh thepath then while i <= geometry.count and not isDeleted geometry[i] do 
		(
			if classof geometry[i] == VRayProxy and geometry[i].filename == thepath then 
			(	append tempObj geometry[i]
			)
			i = i + 1
		)
		tempObj
	)
	--�б�����·������ʾ��ʽ
	fn fl_firstDisplay =
	(
		s=lbx_vrayProxyPaths.selection as array
		if s.count != 0 then (
		thepath = lbx_vrayProxyPaths.items[s[1]]
		tempState = 1
 		obj = fl_getTheInstanceVP thepath
		if obj[1] != undefined then tempState = obj[1].display + 1
		rdo_display.state = tempState --������ʾ��ʽ
		)
	)
	--ˢ���б�
	fn fl_refeshListbox stat =
	(
		case stat of
		(
			1: (		fl_collectAllVrayProxies() --��ʾ����VRay����
					fl_firstDisplay() --��һ������ʾ��ʽ
				)
			2: (		fl_collectMissVrayProxies() --��ʾ��ʧVRay����
					fl_firstDisplay() --��һ������ʾ��ʽ
				)
		)
	)
	--���
	fn fl_copyVP arr newDir colmap:true updvr:true updmap:true =
	(	--arr ,����·��
 		for a in arr do (
			--�������
			colVP = fl_getTheInstanceVP a
			if colVP[1] != undefined then
			(	
				VPfileName = colVP[1].filename
				newFilename = newDir + "\\" + getfilenamefile VPfileName + getfilenametype VPfileName
				copyFile VPfileName newFilename
			)
			--���´���·��
			if updvr then 
			(
				for c in colVP do c.filename = newDir + "\\" + getfilenamefile c.filename + getfilenametype c.filename
			)
			--�����ͼ
			themaps=#()
			for c in colVP where c.material!=undefined do
			(	temp=getclassinstances bitmaptexture target:c.material
				for t in temp where finditem themaps t == 0 do append themaps t
			)
			if colmap then
			(	
				for b in themaps do
				(	oldName=b.filename
					newName= newDir + "\\" + getfilenamefile oldName + getfilenametype oldName
					copyFile oldName newName
				)
			)
			--������ͼ·��
			if updmap then for b in themaps do b.filename = newDir + "\\" + getfilenamefile b.filename + getfilenametype b.filename
		)--end for
	)

	--�ռ�û�ж�ʧ��VRay����
	fn fl_notMissingFile =
	(
		allVP = #()
		for i in geometry where classof i == VRayProxy do
		( 	
			f = i.filename
			if findItem allVP f == 0 and doesfileexist f then append allVP f
		)
		allVP
	)

	on fl_vrayproxyMgr2 open do
	(
		fl_collectAllVrayProxies()
		fl_firstDisplay ()
	)
	on lbx_vrayProxyPaths selected sel do
	(
		fl_firstDisplay()
	)
	on rdo_area changed stat do
	(
		fl_refeshListbox stat
	)
	on btn_setPath pressed do
	(
		newPath = getsavepath caption:"����VRay����·��"
		if newPath != undefined then
		(	--������·��
		ids = lbx_vrayProxyPaths.selection as array
		selPath = for i in ids collect lbx_vrayProxyPaths.items[i]
			colVP = fl_collectGivenVP selPath
			undo on (
				if colVP.count != 0 then for v in colVP do
				(	v.filename = newPath + "\\" + getfilenamefile v.filename + getfilenametype v.filename
			--		CenterObject v --���Ĺ���������
				)
			) --end undo on
			--ˢ����ʾ��ʽ
			fl_refeshListbox rdo_area.state
		) --end if
	)
	on rdo_display changed stat do
	(	
		ids = lbx_vrayProxyPaths.selection as array
		selPath = for i in ids collect lbx_vrayProxyPaths.items[i]
			colVP = fl_collectGivenVP selPath
			undo on (
			case stat of
			(
				1: for i in colVP do i.display = 0 --bounding box
				2: for i in colVP do i.display = 1 --preview from file
				3: for i in colVP do i.display = 2 --point
			)
			) --end undo on
	)
	on btn_select pressed do
	(
		ids = lbx_vrayProxyPaths.selection as array
		selPath = for i in ids collect lbx_vrayProxyPaths.items[i]
		colVP = fl_collectGivenVP selPath
		undo on ( select colVP )
	)
	on btn_begin pressed do
	(
		if edt_output.text!="" then (
		fl_copyVP lbx_vrayProxyPaths.items edt_output.text colmap:colmap.checked updvr:updvr.checked updmap:updmap.checked
		)
		else messagebox "����ѡ��·��!"
		max views redraw
	)
	on btn_browse pressed do
	(
		collectPath = getSavePath caption: "ѡ�񱣴�·��"
		if collectPath != undefined then	edt_output.text = collectPath
	)
	on fl_vrayproxyMgr2 moved pp do
	(
		if CGplusplusFunc!=undefined then setinisetting spInifilepath "Main" "childLibPos" (pp as string)
	)
)

if CGplusplusFunc!=undefined  then CGplusplusFunc.createChildLib fl_vrayproxyMgr2
else createdialog fl_vrayproxyMgr2
