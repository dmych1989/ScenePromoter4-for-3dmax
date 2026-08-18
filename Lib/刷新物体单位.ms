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


--�����ԭ���Ǵ���һ��box����,Ȼ��attachĿ�������,��boxȥ��,����Ŀ������ĵ�λ�ͺ�boxһ����
--refesh unit
	fn fl_refeshObjUnit obj =
	(	
		--get the pros
		tempP = obj.pivot
		tempN = obj.name
		tempC = obj.wirecolor
		--bigin refesh
		b = convertToPoly(box())
		newName = uniquename (b.name as string)
		polyOp.attach b obj
		b.EditablePoly.SetSelection #Face #{1}
		b.selectElement()
		TargetElement = polyop.getFaceSelection b
		polyop.detachFaces b TargetElement asNode:true name:newName
		b.pivot = tempP
		b.name = tempN
		b.wirecolor = tempC
		select b
		NewObj = getnodebyname newName
		delete NewObj
	)
	(
		if selection.count != 0 then
		(	with redraw off
			undo on (
			sel=getcurrentselection()
			for s in sel do (
				if classof s == Editable_Poly then fl_refeshObjUnit $
				else if classof s == Editable_Mesh then
				(	convertToPoly s
					fl_refeshObjUnit s
					convertToMesh s
				)--end else
			)--end for
			) --end undo on
			max views redraw
		)
		else messagebox "��ѡ��EPoly����EMesh,�ɶ�ѡ!" title:"������ʾ" beep:off
	)
