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
try destroydialog alignToTheGround catch()
rollout alignToTheGround "��ֱ�������" width:118 height:82
(
	pickbutton Btn_pick "ʰȡ����" pos:[7,7] width:100 height:18 toolTip:"������ѡ��һ��������Ϊ����" autoDisplay:true
	button btn_align "�������" pos:[8,55] width:80 height:18
	checkbox chk_norm "���߶���" pos:[9,31] width:86 height:16 checked:true
	button btn49 "?" pos:[94,57] width:16 height:15
	on btn_align pressed do
	(	obj=Btn_pick.object
		if obj!=undefined and not isdeleted obj then
		(	if chk_norm.checked then
			( 
			undo on (
			for i in selection do 
			  (	  dirn=-1
			  	  if i.pos.z <0 then dirn = 1
			  	  r= ray i.pos [0,0,dirn]
			 	  d=intersectray obj r
			 	  if d!=undefined do 
			 	  ( 	  i.pos=d.pos
				  	  i.dir=d.dir
			    ))
			))
			else
			(	undo on (
				for i in selection do 
			  ( 	  dirn=-1
			  	  if i.pos.z <0 then dirn = 1  
			       r= ray i.pos [0,0,dirn]
			 	  d=intersectray obj r
			 	  if d!=undefined do 
			 	  ( 	  i.pos=d.pos
			    		)
			  ))
			)
		)
		
	)
	on btn49 pressed do
	(
			str = "1 .�˹���ֻ����Z�ᡣ��ʰȡһ��������Ϊ����\n2 .ѡ���������壬������������桱��ť����ѡ������嶼���뵽��ʰȡ�����塣\n"
			str +="3 .��ѡ�����ߡ����������ʱZ�᷽��ʰȡ���淨�ߣ�����ѡʱ�ı�Z�᷽��\n"
		str+="4 .ʰȡ�ı�������Ҫ����Ҫ����������·�����Ч��\n"	
		str+="5 .�˹��ܲ�������CG++��Աys172�ṩ��"
			messagebox str title:"������ʾ"
	)
	on alignToTheGround moved pp do
	(
		if CGplusplusFunc!=undefined then setinisetting spInifilepath "Main" "childLibPos" (pp as string)
	)
)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChildLib alignToTheGround 
else createdialog alignToTheGround
