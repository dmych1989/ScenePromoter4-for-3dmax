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

	--minus the first array from the second
	fn fl_minusArr arrAll arrExclude  =
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
	)
	fn fl_removeDeleteObjs objs = 
	( 
		for i in objs where not isDeleted i collect i 
		objs
	)

	--collapse objects
	fn fl_collapseobjs sceneObjs =
	(
		fl_tips01="������ʾ"
		tempObjs=#()
		try 
		(	for i in sceneObjs do
			(	if (isKindof i shape) then
				if i.render_renderable==false then
					append tempObjs i
			)
		) catch()
		sceneObjs = fl_minusArr sceneObjs tempObjs
		tempObjs=#()
		if sceneObjs.count!=0 then
		(		--attach now
				for i in sceneMaterials do
				(	tempMtlname = i.name
					for j in sceneObjs where not isDeleted j do
						if j.material.name == tempMtlname then
						(	append tempObjs j
						)
					tN=tempObjs.count
					if tN!=0 then
					(	
						convertToPoly tempObjs[1]
						for k=2 to tN do
						(	
							polyOp.attach tempObjs[1] tempObjs[k]
						)
						convertToMesh tempObjs[1]
						sceneObjs = fl_removeDeleteObjs sceneObjs
						tempObjs=#()
					)
				)
				messagebox "���ݳɹ���" title:fl_tips01
		)
		else messagebox "û�п����ݵ����壡" title:fl_tips01
	)

(	--collapse all objects
		if selection.count == 0 then (	
			ifcontinue=queryBox "��������\n�˲����������������尴�������ݣ����Ҳ����棬�Ƿ������" title:"�������� - ��������" 
			if ifcontinue then (
			max create mode
			undo off(
				with redraw off
				timeStart=timestamp()
				format "%\n" "��������..."
				sceneObjs=#()
				--collect the nont material objects
				sceneObjs = for i in objects where not isDeleted i and i.material!=undefined collect i
				fl_collapseobjs sceneObjs
				max views redraw
				timeEnd=timestamp()
				format "������ʱ%��\n" ((timeEnd-timeStart)/1000.0)
				)--end undo off
			)--end if continue
		)--end collapse all
		else (  --collapse selected
			ifcontinue=queryBox "����ѡ��\n�˲�������������ѡ������尴�������ݣ����Ҳ����棬�Ƿ������" title:"�������� - ����ѡ��" 
			if ifcontinue then (
			max create mode
			undo off(
				with redraw off
				timeStart=timestamp()
				format "%\n" "��������..."
				sceneObjs=#()
				--collect the nont material objects
				sceneObjs = for i in selection where not isDeleted i and i.material!=undefined collect i
				fl_collapseobjs sceneObjs
				max views redraw
				timeEnd=timestamp()
				format "������ʱ%��\n" ((timeEnd-timeStart)/1000.0)
				)--end undo off
			)--end if continue
		)--end collapse selected
)--end collapse
