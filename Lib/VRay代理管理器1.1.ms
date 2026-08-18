/*
		VRay����������1.0
		���ߣ�����  2008-11-3
		�˽ű���CG++ԭ�����������ɴ������޸ģ��뵽CG++��̳������Դ˽ű��������

					��������������������������������
					���� CG++,�����3DMAX������ ����
					��������������������������������
*/

try destroydialog fl_vrayproxyMgr catch()
global fl_vrayproxyMgr,fl_collectVRayProxies,selectlist
rollout fl_vrayproxyMgr "VRay����������V1.1" width:450 height:250
(
	MultiListBox lbx_vrayProxyPaths "VRay����·���б���" pos:[3,4] width:441 height:10 selection:#{}--�ĳɶ�ѡ
	edittext edt_selected "" pos:[-1,226] width:441 height:16 readOnly:true 
	radiobuttons rdo_area "" pos:[8,167] width:107 height:32 labels:#("����VRay����  ", "��ʧVRay����  ") default:1 columns:1
	button btn_collect "�ռ���ѡVRay����" pos:[4,205] width:214 height:16
	button btn_setPath "����·��" pos:[123,165] width:95 height:16
	radiobuttons rdo_display "��ʾ��ʽ��" pos:[234,164] width:114 height:62 labels:#("�߽��   ", "���ļ�Ԥ��   ", "�� ") columns:1
	button btn_select "ѡ��VRay����" pos:[123,185] width:95 height:16
	--�ռ�����VRay����
	fn fl_collectAllVrayProxies = 
	(	allVP = #()
		for i in geometry where classof i == VRayProxy do
		( 	
			f = i.filename
			if findItem allVP f == 0 then append allVP f
		)
		if allVP.count != 0 then lbx_vrayProxyPaths.items = allVP --Defined the listbox
		else lbx_vrayProxyPaths.items =#( "û���ҵ�VRay����","","CG++��Ʒ",,"","IVY-CG�޸�","www.IVYcg.com")
		lbx_vrayProxyPaths.selection = 1
		edt_selected.text = lbx_vrayProxyPaths.items[1]
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
		else lbx_vrayProxyPaths.items = #( "û���ҵ���ʧVRay����","","CG++��Ʒ",,"","IVY-CG�޸�","www.IVYcg.com")
		lbx_vrayProxyPaths.selection = 1
		edt_selected.text = lbx_vrayProxyPaths.items[1]
	)
	--��������·���ռ�VRay����
	fn fl_collectGivenVP path =
	(	colVP = #()
		for i in geometry while not isDeleted i where classof i == VRayProxy do
		( 	
			f = i.filename
			if f == path then append colVP i
		)
		colVP
	)
	--�ж��ļ���
	fn fl_ifVrmesh path = if getFilenameType path == ".vrmesh" then return true else return false
	fn fl_getTheInstanceVP path =
	(	local tempObj;i = 1
		if fl_ifVrmesh path then while i <= geometry.count do 
		(	--���ʹ�ô��ļ��ĵ�һ��VRay����
			if classof geometry[i] == VRayProxy and geometry[i].filename == path then 
			(	tempObj = geometry[i]
				i = geometry.count
			)
			i = i + 1
		)
		tempObj
	)
	--�б���һ��·������ʾ��ʽ
	fn fl_firstDisplay =
	(
		path = lbx_vrayProxyPaths.items[1]
		tempState = 1
 		obj = fl_getTheInstanceVP path
		if obj != undefined then tempState = obj.display
		rdo_display.state = tempState --������ʾ��ʽ
	)
	--�б�ѡ��·������ʾ��ʽ
	fn fl_selectDisplay =
	(
		path = lbx_vrayProxyPaths.items[selectlist[1]]
		tempState = 1
 		obj = fl_getTheInstanceVP path
		if obj != undefined then tempState = obj.display
		rdo_display.state = tempState --������ʾ��ʽ
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
	--��ʾѡ���б���·��
	--��ʾ��Χ
	--�ռ�

	on fl_vrayproxyMgr open do
	(
		
		fl_collectAllVrayProxies()
		fl_firstDisplay()
		selectlist=lbx_vrayProxyPaths.selection as array
	)
	on fl_vrayproxyMgr close do
	(
		try destroydialog fl_collectVRayProxies catch()
	)
	
	on lbx_vrayProxyPaths selected sel do
	(
		selectlist=#(sel)
		
		edt_selected.text = lbx_vrayProxyPaths.items[sel]
		fl_selectDisplay ()
			
			
	)
			
	on lbx_vrayProxyPaths selectionEnd do
	(
		selectlist=lbx_vrayProxyPaths.selection as array
		if selectlist.count==1 then
		(tempsel=selectlist[1]
		edt_selected.text = lbx_vrayProxyPaths.items[tempsel]
		fl_selectDisplay ()
			)
			else edt_selected.text="ѡ����"+selectlist.count as string+" ������"
	)
	
	on rdo_area changed stat do
	(
		fl_refeshListbox stat
	)
	on btn_collect pressed do
	(
		try destroydialog fl_collectVRayProxies catch()
		createdialog fl_collectVRayProxies
		selectlist=lbx_vrayProxyPaths.selection as array
	)
	on btn_setPath pressed do
	(
		newPath = getSavePath caption:"����VRay����·��" --types: "VRay mesh (*.vrmesh)|*.vrmesh"--getFilenamePath
		if newPath != undefined then
		(	--������·��
			selectlist=lbx_vrayProxyPaths.selection as array
			
				for i in selectlist do 
					(colVP = fl_collectGivenVP lbx_vrayProxyPaths.items[i]
						undo on (if colVP.count != 0 then for v in colVP do
									(v.filename = newPath+"\\"+filenameFromPath v.filename
									--CenterObject v --���Ĺ���������--ʹ�ù����г�������޸��˴��������ģ���ô�������ķ�ʽȥ��ָ��·���ᷢ�����������ƫ�ƣ����Ժ��Ե����
									)--end if
								) --end undo on
						)--end for
					
				
			
			--ˢ����ʾ��ʽ
			fl_refeshListbox rdo_area.state
		) --end if
	)
	on rdo_display changed stat do
	(	
		
		for j in selectlist do 
		(selPath = lbx_vrayProxyPaths.items[j]
		if fl_ifVrmesh selPath then
		(	
			colVP = fl_getTheInstanceVP selPath
			undo on (
			case stat of
			(
				1: for i in colVP do i.display = 0 --bounding box
				2: for i in colVP do i.display = 1 --preview from file
				3: for i in colVP do i.display = 2 --point
			)
			) --end undo on
		)--end if
		)--end for
		
	)
	on btn_select pressed do
	(clearSelection()
		
			for i in selectlist do 
				(colVP = fl_collectGivenVP lbx_vrayProxyPaths.items[i]
					undo on ( selectmore colVP )
					)
				
			
		
	)
)


rollout fl_collectVRayProxies "�ռ�����VRay����" width:220 height:134
(
	edittext edt_output "�ռ�·����" pos:[4,7] width:212 height:20 readOnly:true labelOnTop:true
	checkbox chk_ifUpdate "����VRay����·��" pos:[24,79] width:133 height:16 checked:false
	button btn_begin "��  ʼ" pos:[26,103] width:126 height:25
	button btn_browse "��" pos:[123,50] width:54 height:20
	--����VRay����
	fn fl_copyVP path newDir =
	(
 		colVP = fl_vrayproxyMgr.fl_getTheInstanceVP path
		if colVP != undefined then
		(	 VPfileName = colVP.filename
			 newFilename = newDir + "\\" + filenameFromPath VPfileName
			 copyFile VPfileName newFilename
		)
	)
	--����VRay����������·��
	fn fl_copyAndUpdateVP path newDir =
	(
 		colVP = fl_vrayproxyMgr.fl_getTheInstanceVP path
		if colVP != undefined then
		(	 VPfileName = colVP.filename
			 newFilename = newDir + "\\" + filenameFromPath VPfileName
			 copyFile VPfileName newFilename
			 colVP.filename = newFilename
		)
	)
	--�ռ�û�ж�ʧ��VRay����
	fn fl_notMissingFile =
	(
		allVP = #()
		tempitem=#()
		for j in selectlist do append tempitem fl_vrayproxyMgr.lbx_vrayProxyPaths.items[j]
			for i in geometry where classof i == VRayProxy do
			( 	
				f = i.filename
				if findItem allVP f == 0 and findItem tempitem f > 0 and doesfileexist f then append allVP f
			)
			allVP
		
	)
	on btn_begin pressed do
	(
		case chk_ifUpdate.checked of
		(
			true: --����VRay����������·��
			(	colVP = fl_notMissingFile()
				newDir = edt_output.text
				if colVP.count != 0 and newDir != "" then
				for v in colVP do fl_copyAndUpdateVP v newDir
			)
			false: --����VRay����
			( 	colVP = fl_notMissingFile()
				newDir = edt_output.text
				if colVP.count != 0 and newDir != "" then
				for v in colVP do fl_copyVP v newDir
			)
		)
		max views redraw
		fl_vrayproxyMgr.fl_refeshListbox fl_vrayproxyMgr.rdo_area.state
		destroydialog fl_collectVRayProxies
	)
	on btn_browse pressed do
	(
		collectPath = getSavePath caption: "ѡ�񱣴�·��"
		if collectPath != undefined then	edt_output.text = collectPath
	)
)
createdialog fl_vrayproxyMgr