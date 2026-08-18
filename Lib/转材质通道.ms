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
--get random color
fn fl_getRandomcolor  =
(	
	local randomcolor = random black white
	randomcolor
)
	(	ifcontinue=queryBox "�˲������������в���תΪ��ɫͨ�������Ҳ����棬�Ƿ������" title:"������ʾ"	
		if ifcontinue then (
		sceneObjs=#();s=sceneMaterials.count
		sceneObjs=for i in objects where i.material!=undefiend collect i
		if sceneObjs.count!=0 then
		(		max create mode
				with redraw off
				timestart=timestamp()
				format "%\n" "����ת����..." 
				randomColor=fl_getRandomcolor()
				temp_Mtl=standardmaterial()
				temp_Mtl.name=sceneMaterials[1].name
				temp_Mtl.Diffuse =randomColor
				temp_Mtl.ambient =randomColor
				temp_Mtl.Specular =randomColor
				temp_Mtl.selfIllumAmount = 100
				tempObjs = #()
				for j in sceneObjs  do
				(	if j.material==sceneMaterials[1] then
					(	j.material=temp_Mtl
						append tempObjs j
					)
				)
				sceneObjs=fl_minusArr sceneObjs tempObjs
				tempObjs = #()
				for i=2 to s do
				(	ifMod2=mod i 2 as Integer
					if ifMod2==0 then
					(	randomColor=fl_getRandomcolor()
						temp_Mtl=standardmaterial()
						temp_Mtl.name=sceneMaterials[i].name
						temp_Mtl.Diffuse =randomColor
						temp_Mtl.ambient =randomColor
						temp_Mtl.Specular =randomColor
						temp_Mtl.selfIllumAmount = 100
						for j in sceneObjs do
						(	if j.material==sceneMaterials[i] then
							(	j.material=temp_Mtl
								append tempObjs j
							)
						)
						sceneObjs=fl_minusArr sceneObjs tempObjs
						tempObjs = #()
					)--end  ifMod2==0
					else
					(	randomColor=white-randomColor
						temp_Mtl=standardmaterial()
						temp_Mtl.name=sceneMaterials[i].name
						temp_Mtl.Diffuse =randomColor
						temp_Mtl.ambient =randomColor
						temp_Mtl.Specular =randomColor
						temp_Mtl.selfIllumAmount = 100
						for j in sceneObjs do
						(	if j.material==sceneMaterials[i] then
							(	j.material=temp_Mtl
								append tempObjs j
							)
						)
						sceneObjs=fl_minusArr sceneObjs tempObjs
						tempObjs = #()
					)--end 	ifMod2==1
				)--end for i=2 to s
				max views redraw
				timeend=timestamp()
				format "%%��\n" "����ת����ʱ" ((timeend-timestart)/1000.0)
		)--end if sceneObjs.count!=0
		else 
		(	format "%\n" "������û�в��ʣ�"
			messagebox "������û�в��ʣ�"
		)
		)--end if continue
	)	--end colorMtl 
