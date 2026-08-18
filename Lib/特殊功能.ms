--���ߣ�����
--Author:Feilang
--------------------------------------------------
--��ӭʹ�ó�������4.0 

----��Դ����----

---------------------------------------------------
--��������4.0		2011-04-01
--��������3.0		2009-08-01
--��������2.6		2009-03-30
--��������2.0		2008-08-06
--��������1.0		2008-05-27

rollout fl_specialFunctions4_1 "���⹦��" width:240 height:123
(
	button btn_freeMemory "�ͷ��ڴ�" pos:[4,4] width:55 height:16 toolTip:"�ͷų�����������ͼʹ�õ��ڴ沢�����������Ĳ���"
	button btn_selectMissUVObjs "�Ҷ�ʧUV������" pos:[61,4] width:96 height:16
	button btn_selectOutSceneObj "ѡ��ǰ��ͼ������������" pos:[4,22] width:154 height:16 toolTip:"ѡ��ǰ������ͼ��������geometry��shapes"
	button btn_selectOutCameraObj "ѡ�񶯻����������������" pos:[4,41] width:154 height:16 toolTip:"ѡ�񶯻��������������geometry��shapes"
	button btn_setRegionRect "�һ���Ⱦ��" pos:[162,4] width:73 height:16 toolTip:"���Ƶ���Ļ�������Ⱦ���һ�"
	dropdownList ddl_region "" pos:[162,27] width:70 height:22 items:#("Region", "Blowup")
	GroupBox grp2 "��������" pos:[3,59] width:233 height:57
	pickbutton btn_pickTarget "ʰȡĿ������" pos:[6,77] width:100 height:30 message:"��ѡ��һ��������Ϊ�����Ĳ�����" toolTip:"������ѡ��һ��������Ϊ�����Ĳ�����" autoDisplay:true
	button btn_selectInstance "ѡ���������" pos:[109,72] width:104 height:16 toolTip:"ѡ����Ŀ�����������������"
	button btn_instanceSelection "����ѡ������" pos:[109,94] width:104 height:16 toolTip:"��ѡ���������Ŀ���������"
	button btn_instanceHelp "?" pos:[217,82] width:15 height:16
	local fl_tips01="����������ʾ"
	--Judge if the node was hidden or frozen
	fn fl_notHiddenOrFrozen obj = not (obj.isHidden or obj.isFrozen)

	on btn_freeMemory pressed do
	(	freeSceneBitmaps()
		clearUndoBuffer()
	)
	on btn_selectMissUVObjs pressed do
	(	local objs=for i in geometry where ((classof i)==Editable_Poly or (classof i)==Editable_mesh)  collect i
		missUVObjd=for obj in objs where (not (meshop.getMapSupport obj.mesh 1) and fl_notHiddenOrFrozen obj) collect obj
		if missUVObjd.count==0 then 
			messagebox "������û�ж�ʧUV������ ��" title:fl_friendllytips
		else select missUVObjd
	)
	on btn_selectOutSceneObj pressed do
	(	
		objs = for o in geometry collect o --collect geometry 
		objShapes = for s in shapes collect s --collect shapes
		join objs objShapes
		local a = boxPickNode (box2 [0,0] [gw.getWinSizeX(),gw.getWinSizeY()])
		select a
		max select invert
		currentSel = getCurrentSelection()
		selObj = for k in currentSel where finditem objs k != 0 and fl_notHiddenOrFrozen k collect k --exculde not geometry and shapes
		select selObj
		if selection.count == 0 then messagebox "���嶼���õ���û��ѡ�ˣ���" title:fl_friendllytips
	
	)
	on btn_selectOutCameraObj pressed do
	(	if selection.count == 1 and superclassof $ == camera then
		(	
			objs = for o in geometry collect o --collect geometry 
			objShapes = for s in shapes collect s --collect shapes
			join objs objShapes 
			viewport.setType #view_camera --set current view to camera
			pickObj = #()
			for i in animationRange.start to animationRange.end do --count each frame
			(	
				sliderTime = i
				a = boxPickNode (box2 [0,0] [gw.getWinSizeX(),gw.getWinSizeY()])
				for j in a where findItem pickObj j == 0 do append pickObj j
			)
			select pickObj
			max select invert
			currentSel = getCurrentSelection()
			selObj = for k in currentSel where finditem objs k != 0 and fl_notHiddenOrFrozen k collect k --exculde not geometry and shapes
			select selObj
		)
		else messagebox "����ѡ��һ���������" title:fl_friendllytips
	)
	on btn_setRegionRect pressed do
	(	--get the activeViewport index
		index = viewport.activeViewport
		if index == 0 then messagebox "���ȼ���һ����ά��ͼ��" title:fl_tips01
		else
		(	
			viewSize = getViewSize()
			X = (viewSize[1]/3) as integer
			Y = (viewSize[2]/3) as integer
			case ddl_region.selection of
			(	--set Blowup 
				1: viewport.setRegionRect index (box2 X Y X Y)
				2: viewport.setBlowupRect index (box2 X Y X Y)
			)
			max views redraw
		)--end else
	) -- end setRegionRect button
	on btn_selectInstance pressed do
	(
		if (obj = btn_pickTarget.object) != undefined and not isDeleted obj then
		(	--get instances
			InstanceMgr.GetInstances obj &instances
			myInstances = for i in instances where fl_notHiddenOrFrozen i collect i
			if myInstances.count != 1 then select myInstances
			else messagebox "û���ҵ���Ŀ������������壡" title:fl_tips01
		)
		else messagebox "û��ʰȡĿ���������ʰȡ���岻���ڣ�������ʰȡ��" title:fl_tips01
	)
	on btn_instanceSelection pressed do
	(	s = getCurrentSelection()
		if (obj = btn_pickTarget.object) != undefined and not isDeleted obj then
		(	
			if s.count != 0 then
			(	idx = findItem s obj
				if idx != 0 then deleteItem s idx --delete the target object
				if s.count != 0 then
				undo on
				(
					for i in s do
					( 	tempV=i.pos
						instanceReplace i obj
						CenterObject i
						i.pos=tempV
					)
				)--end undo on
				else messagebox "�����Լ����Լ����ܹ�������" title:fl_tips01
			)
			else messagebox "��ѡ��Ҫ���������壡" title:fl_tips01
		)
		else messagebox "û��ʰȡĿ���������ʰȡ���岻���ڣ�������ʰȡ��" title:fl_tips01
	) --end instanceSelection button
	on btn_instanceHelp pressed do
	(
		tips = "1��������ʰȡĿ�����塱����ѡ�г�����һ������Ϊ���ա�\n"
		tips += "2����ѡ��������塱�ǽ���ʰȡ���������������ȫ��ѡ�У�����ʰȡ�����塣\n"
		tips += "3��������ѡ�����塱�ǽ�ѡ���������ղ�ʰȡ�������������ע������Ĺ���\n      �Ǿ��Թ���������Խ�һ���ƹ������һ��BOX����ô�ƹ�Ҳ�����BOX��\n"
		tips += "4�������ɳ�����"
		messagebox tips title: ("�������� - "+fl_tips01) beep:off
	)
	on fl_specialFunctions4_1 moved pp do
	(
		if CGplusplusFunc!=undefined then setinisetting spInifilepath "Main" "childLibPos" (pp as string)
	)
)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChildLib fl_specialFunctions4_1 
else createdialog fl_specialFunctions4_1
