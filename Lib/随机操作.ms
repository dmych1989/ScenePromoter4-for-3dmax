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

try destroydialog SPrandomSelect catch() 

--Right click munu
	rcmenu SPrandomSelectMenu
	(
		menuItem selectHelp "Help" checked:false
		separator selectButtonHelp
		menuItem selectVertex "Vertex" checked:false
		menuItem selectEdge "Edge" checked:false
		menuItem selectPolygon "Polygon" checked:false
		menuItem selectElement "Element" checked:false
	/*	on SPrandomSelectMenu open do
		( 	tempType = fl_JudgeTheSelection ()
			if tempType == 0 then
			(	selectVertex .enabled = false
				selectEdge .enabled = false
				selectPolygon .enabled = false
				selectElement .enabled = false
			)
			else 
			(	selectVertex .enabled = true
				selectEdge .enabled = true
				selectPolygon .enabled = true
				selectElement .enabled = true
			)
		
		)--end off open
	*/
		on selectHelp picked do
		(	tips = "1�����û��ѡ�����壬��ѡ�����塱������ͼ������İٷֱ�ѡ�����塣\n"
			tips += "2�����ѡ�������������1����ѡ������ٷֱ�ѡ�����塣\n"
			tips += "3�����ѡ����һ��EPoly���򡰵㡱�����ߡ������桱����Ԫ�ء����յ㡢�ߡ��桢Ԫ�صİٷֱ�ѡ��\n"
			tips += "      ����������ʾ�㣬�ߣ����Ԫ�ص��ܸ�������ѡ����ʾѡ��㣬�ߣ����Ԫ�صĸ�����\n"
			tips += "4������ˢ�¿���ʾ��������򵥸�EPoly���Ӳ㼶������"
			messagebox tips title:("���ѡ��") beep:off
		)
		on selectVertex picked do
		(	subobjectLevel = 1
			SPrandomSelect.SPrandomSelectSub 1 SPrandomSelect.spn_percent.value
			SPrandomSelect.btn_refesh.pressed()
		)
		on selectEdge picked do
		(	subobjectLevel = 2
			SPrandomSelect.SPrandomSelectSub 2 SPrandomSelect.spn_percent.value
			SPrandomSelect.btn_refesh.pressed()
		)
		on selectPolygon picked do
		(	subobjectLevel = 4
			SPrandomSelect.SPrandomSelectSub 4 SPrandomSelect.spn_percent.value
			SPrandomSelect.btn_refesh.pressed()
		)
		on selectElement picked do
		(	subobjectLevel = 5
			SPrandomSelect.SPrandomSelectSub 5 SPrandomSelect.spn_percent.value
			SPrandomSelect.btn_refesh.pressed()
		)	
	)
rollout SPrandomSelect "�������" width:240 height:241
(
	GroupBox grp_sublevel "���ѡ��" pos:[3,5] width:232 height:83
	spinner spn_percent "�ٷֱȣ� " pos:[34,23] width:80 height:16 range:[0,100,30]
	edittext edt_total "������" pos:[103,45] width:122 height:16 readOnly:true
	edittext edt_select "ѡ��" pos:[103,64] width:122 height:16 readOnly:true
	button btn_refesh "ˢ��" pos:[177,23] width:32 height:16 toolTip:"���¼���ѡ����������������������"
	GroupBox grp_randomTransform "�������" pos:[3,88] width:232 height:87
	GroupBox grp_minAndMax "��С��    ���" pos:[12,107] width:148 height:62
	spinner spn_scaleMin "%" pos:[26,124] width:55 height:16 range:[0,500,80]
	spinner spn_scaleMax "%" pos:[99,124] width:55 height:16 range:[0,500,120]
	spinner spn_rotateMin "��" pos:[24,145] width:57 height:16 range:[-180,180,-180]
	spinner spn_rotateMax "��" pos:[97,145] width:57 height:16 range:[-180,180,180]
	button btn_randomScale "����" pos:[170,125] width:55 height:16 toolTip:"ѡ�����������������,�Ҽ���λ"
	button btn_randomRotate "��ת" pos:[170,148] width:55 height:16 toolTip:"ѡ��������Z�������ת,�Ҽ���λ"
	GroupBox grp7 "���ı任" pos:[3,178] width:232 height:58
	button btn_centerPivot "���Ĺ���" pos:[8,196] width:68 height:16 toolTip:"�����������Ƶ���������"
	button btn_bottomPivot "���Ĺ��" pos:[79,196] width:68 height:16 toolTip:"�����������Ƶ��������ײ�"
	button btn_centerObject "����������" pos:[150,196] width:80 height:16 toolTip:"�������ƶ�������λ��"
	button btn_zeroMin "��͵����" pos:[8,216] width:90 height:16 toolTip:"���������͵�Z�������0"
	checkbox chk_groupFirst "������������" pos:[105,217] width:110 height:16
	button btn_selectObj "ѡ������" pos:[120,23] width:55 height:16 toolTip:"���ѡ������"
	button btn_vertex "��" pos:[18,45] width:35 height:16 toolTip:"���ѡ���"
	button btn_edge "��" pos:[58,44] width:35 height:16 toolTip:"���ѡ����"
	button btn_polygen "��" pos:[18,64] width:35 height:16 toolTip:"���ѡ����"
	button btn_element "Ԫ��" pos:[58,64] width:35 height:16 toolTip:"���ѡ��Ԫ��"
	button btn_help "?" pos:[210,23] width:15 height:16
	button btn_scaleHelp "?" pos:[208,103] width:15 height:16
	button btn15 "?" pos:[214,216] width:15 height:16
	local fl_tips01="����������ʾ"
	--Judge the number of selection
fn fl_JudgeTheSelection = 
(	local type
	if selection.count == 1 then
	(	tempClass = classof (modPanel.getCurrentObject())
		if tempClass == Editable_Poly then
		(
			type = 1
			
			)
		else type = 0
	)
	else type = 0
)
fn fl_ifSelectPoly =
	(
		if fl_JudgeTheSelection() == 1 then return true
		else (
		messagebox "��ѡ��һ��EPoly���岢���õ�ǰ�޸�����Editable Poly�£�" title:fl_tips01 beep:off
		return false
		)
	)
	--Get element numbers
	fn fl_getElementItem SourceOBJ =
	(	
		tempSel = polyop.getFaceSelection SourceOBJ
		elementFirstFlags = #()
		faceCount = polyOp.getNumFaces SourceOBJ
		faceFlags = #{1..faceCount}
		for i in 1 to faceCount where not faceFlags.isempty do
		(	--start element count loop
			if faceFlags[i] then
			(	append elementFirstFlags i
				SourceOBJ.EditablePoly.SetSelection #Face #{i}
				SourceOBJ.selectElement()
				TargetElement = polyop.getFaceSelection SourceOBJ
				faceFlags -= TargetElement
			)
			else()
		)
		polyOp.setFaceSelection SourceOBJ tempSel
		elementFirstFlags
	)
	-- Random select objects
	fn fl_randomselectObjs vP =
	(
		objNum = selection.count
		if objNum == 0 then
		(
			objs = boxPickNode (box2 [0,0] [gw.getWinSizeX(),gw.getWinSizeY()])--collect scene objects
			n = objs.count 
			if n != 0 then --If there are no objects selected
			(	sObj = #() 
				--Select objects by percent
				while sObj.count as float/n*100 < vP do  --collect select objects
				(
					tN = random 1 n
					if finditem sObj objs[tN] == 0 then
					(
						append sObj objs[tN]
					)
				) --end while
				select sObj
			)
			else messagebox "��ǰ��ͼ��û�п��ü�������:)" title:fl_tips01
		)
		else if objNum > 0 then --If there are objects selected
		(
			objs = getCurrentSelection()
			n = objs.count
				--Select objects by percent
				sObj = #() 
				while (sObj.count/n as float)*100 < vP do  --collect select objects
				(
					tN = random 1 n
					if finditem sObj objs[tN] == 0 then
					(
						append sObj objs[tN]
					)
				) --end while
				select sObj
		)
		else()
	)
	--Random select subobject level
	fn SPrandomSelectSub subNum vP =
	(
		case subNum of 
		(
			--random select vertexs
			1: (
					tV = polyOp.getNumVerts $  --total vertexs
					sB = #()
					while sB.count/tV as float*100 < vP do --collect select vertexs
					(
						tI = random 1 tV
						if finditem sB tI == 0 then
						(
							append sB tI
						)
					)-- end while
					polyOp.setVertSelection $ (sB as bitarray)
					max views redraw
				)
			--random select edges
			2: (
					tV = polyOp.getNumEdges $ --total edges
					sB = #()
					while sB.count/tV as float*100 < vP do --collect select edges
					(
						tI = random 1 tV
						if finditem sB tI == 0 then
						(
							append sB tI
						)
					)-- end while
					polyOp.setEdgeSelection $ (sB as bitarray)
					max views redraw
				)
		/*	3: (
					tV = polyOp.getOpenEdges $
					polyOp.setEdgeSelection $ (tV as bitarray)
					max views redraw
				)
		*/
			4: (
					tV = polyOp.getNumFaces $ --total faces
					sB = #()
					while sB.count/tV as float*100 < vP do --collect select faces
					(
						tI = random 1 tV
						if finditem sB tI == 0 then
						(
							append sB tI
						)
					)-- end while
					polyOp.setFaceSelection $ (sB as bitarray)
					max views redraw
				)
			5: (
					fV = fl_getElementItem $ --get Element flags
					tV = fV.count
					sV = #()
					sB = #()
					while sB.count/tV as float*100 < vP do
					(
						tI = random 1 tV
						if finditem sB tI == 0 then
						(
							append sB tI
						)
					)
					if sB.count != 0 then
						for j in sB do append sV fV[j]
					polyOp.setFaceSelection $ (sV as bitarray)
					$.selectElement()
					max views redraw
				)
			default: ()
			)
	
	)
	--Get Subobject numbers
	fn fl_getSubojectNum obj subNum =
	(	num = case subNum of
		(
			1:	 polyOp.getNumVerts obj
			2:	 polyOp.getNumEdges obj
			--3:	 (polyOp.getOpenEdges obj).numberSet
			4:	 polyOp.getNumFaces obj
			5:	(fl_getElementItem obj).count
			default:	 0
		)
	)
	fn fl_getSubojectSel obj subNum =
	(
		num = case subNum of
		(
			1:	 (polyOp.getVertSelection obj).numberSet
			2:	 (polyOp.getEdgeSelection obj).numberSet
			--3:	 (polyOp.getEdgeSelection obj).numberSet
			4:	 (polyOp.getFaceSelection obj).numberSet
			5:	(
					tempSel = polyop.getFaceSelection obj
					sel = copy tempSel
					elementFirstFlags = #()
					faceCount = tempSel.numberSet
					for i in tempSel where not tempSel.isempty do
					(	--start element count loop
						if tempSel[i] then
						(	append elementFirstFlags i
							obj.EditablePoly.SetSelection #Face #{i}
							obj.selectElement()
							TargetElement = polyop.getFaceSelection obj
							tempSel -= TargetElement
						)
						else()
					)
					polyOp.setFaceSelection obj sel
					elementFirstFlags.count
				)
			default:	 0
		)
	)
	fn CommaNumbers numberstring divstring:"," = 
	(	numCount=numberstring.count 
			for i = (numCount- 3) to 1 by -3 do
			(	numberstring = replace numberstring i 1 (numberstring[i]+divstring)
			 )
			numberstring
	)

	on btn_refesh pressed do
	(	
		tempSelectObj = selection.count
		tempType = fl_JudgeTheSelection ()
		if tempSelectObj == 1 then --One object selected
		(	if tempType == 1 then
			(	--Modifier supported
				subNum = fl_getSubojectNum $ subObjectlevel
				subSel = fl_getSubojectSel $ subObjectlevel
				edt_total.text = CommaNumbers (subNum as string)
				edt_select.text = CommaNumbers (subSel as string)
			)
			else --No modifier supported
			(	edt_total.text = "1"
				edt_select.text = "1"
				)
		)
		else if tempSelectObj == 0 then --No objects selected
		( 	objs = boxPickNode (box2 [0,0] [gw.getWinSizeX(),gw.getWinSizeY()])--collect scene objects
			edt_total.text = CommaNumbers (objs.count as string)
			edt_select.text = "0"
		)
		else --Objects selected
		(	edt_total.text = CommaNumbers (tempSelectObj as string)
			edt_select.text = edt_total.text
		)
	)
	on btn_randomScale pressed do
	(	
		undo on(
		if chk_groupFirst.checked then
			selectObj = for j in selection where not isGroupMember j collect j
		else selectObj = getCurrentSelection()
		for i in selectObj do
		(
			scaleV = (random spn_scaleMin.value spn_scaleMax.value)/100
			i.scale=[scaleV,scaleV,scaleV]
		)
		) --end undo on
	)
	on btn_randomScale rightClick do
	(	undo on(
		if chk_groupFirst.checked then
			selectObj = for j in selection where not isGroupMember j collect j
		else selectObj = getCurrentSelection()
		for i in selectObj do
		(
			i.scale=[1,1,1]
		)
		) --end undo on
	)
	on btn_randomRotate pressed do
	(
		undo on(
		if chk_groupFirst.checked then
			selectObj = for j in selection where not isGroupMember j collect j
		else selectObj = getCurrentSelection()
		for i in selectObj do
		(	rotateV = random spn_rotateMin.value spn_rotateMax.value
			i.rotation.z_rotation = rotateV
		)
		) --end undo on
	)
	on btn_randomRotate rightClick do
	(	undo on(
		if chk_groupFirst.checked then
			selectObj = for j in selection where not isGroupMember j collect j
		else selectObj = getCurrentSelection()
		for i in selectObj do
		(
			i.rotation.z_rotation = 0
		)
		) --end undo on
	)
	on btn_centerPivot pressed do
	(	if selection.count == 0 then messagebox "����ѡ�����壡" title:fl_tips01
		else 
		(	
			undo on (
			if chk_groupFirst.checked then
				selectObj = for j in selection where not isGroupMember j collect j
			else selectObj = getCurrentSelection()
			for i in selectObj do CenterPivot i 
			)--end undo on
		)
	)
	on btn_bottomPivot pressed do
	(	if selection.count == 0 then messagebox "����ѡ�����壡" title:fl_tips01
		else 
		(	undo on(
			if chk_groupFirst.checked then
				selectObj = for j in selection where not isGroupMember j collect j
			else selectObj = getCurrentSelection()
			for i in selectObj do
			(	CenterPivot i
				i.pivot.z = i.min.z
			)
			)--end undo on
		)
	)
	on btn_centerObject pressed do
	(	if selection.count == 0 then messagebox "����ѡ�����壡" title:fl_tips01
		else 
		(	if chk_groupFirst.checked then
				selectObj = for j in selection where not isGroupMember j collect j
			else selectObj = getCurrentSelection()
			undo on (
			for i in selectObj do
				CenterObject i 
			)--end undo on
		)
	)
	on btn_zeroMin pressed do
	(	if selection.count == 0 then messagebox "����ѡ�����壡" title:fl_tips01
		else 
		(	undo on(
			if chk_groupFirst.checked then
				selectObj = for j in selection where not isGroupMember j collect j
			else selectObj = getCurrentSelection()
			for i in selectObj do
			(	tempZ = i.pos.z
				tempMinZ = i.min.z
				i.pivot.z = i.min.z
				i.pos.z = 0
				i.pivot.z = tempZ - tempMinZ
			)
			)--end undo on
		)
	
	)
	on btn_selectObj pressed do
	(
		fl_randomselectObjs spn_percent.value
		btn_refesh.pressed()
	)
	on btn_vertex pressed do
	(
		if fl_ifSelectPoly() then
		(
			SPrandomSelectMenu.selectVertex.picked()
		)
		else()
	)
	on btn_edge pressed do
	(
		if fl_ifSelectPoly() then
		(
			SPrandomSelectMenu.selectEdge.picked()
		)
		else()	
	)
	on btn_polygen pressed do
	(
		if fl_ifSelectPoly() then
		(
			SPrandomSelectMenu.selectPolygon.picked()
		)
		else()	
	)
	on btn_element pressed do
	(
		if fl_ifSelectPoly() then
		(
			SPrandomSelectMenu.selectElement.picked()
		)
		else()
	)
	on btn_help pressed do
	(
		SPrandomSelectMenu.selectHelp.picked()
		)
	on btn_scaleHelp pressed do
	(
		tips = "1�����Ű���ԭ����İٷֱȽ��У�ÿ���������Ŵ�Сȡ�������С�ٷ�\n      ��һ�����ֵ�������Ҽ��ɽ�ѡ�����嶼����ԭʼ��С���ɳ�����\n"
		tips += "2����ת��ԭʼ������У�ÿ��������ת�Ƕ�ȡ�����С�Ƕ�һ�����ֵ��\n      �����Ҽ��ɽ�ѡ������Ƕȶ�����ԭʼ�Ƕȣ��ɳ�����"
		messagebox tips title: fl_tips01 beep:off
	)
	on btn15 pressed  do
	(
		str = "���Ĺ��У���ѡ����������Ĺ��У��൱��Hierarchy����Pivot/Affect Pivot Only -\n"
		str +="Center to Object����ѭ�������������ȡ���\n"
		str +="���Ĺ�ף���ѡ����������Ĺ鵽�ײ�����λ�á���ѭ�������������ȡ���\n"
		str +="���������ģ��������Ƶ�����λ�ã��൱��Hierarchy����Pivot/Affect Object Only - \n"
		str +="Center to Pivot.��ѭ�������������ȡ���\n"
		str +="��͵���㣺��ѡ����������͵�Ϊ׼�Ƶ�X��Y��ˮƽ���ϡ���ѭ�������������ȡ���\n"
		str +="�����������ȣ������ѡ��ֻ�Դ����������������������Ĳ���������ѡ��ѡ��\n�������������������"
		messagebox str title: fl_tips01 beep:off
	)
	on SPrandomSelect moved pp do
	(
		if CGplusplusFunc!=undefined then setinisetting spInifilepath "Main" "childLibPos" (pp as string)
	)
)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChildLib SPrandomSelect 
else createdialog SPrandomSelect
