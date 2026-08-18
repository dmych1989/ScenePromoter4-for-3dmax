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

global SP4_rename,SP4_renameManager
global spRootPath=getdir #scripts +"\\ScenePromoter4"
global spInifilepath=spRootPath+"\\ScenePromoter4.ini"

try destroydialog SP4_rename catch() 
try destroydialog SP4_renameManager catch() 
rollout SP4_rename "������" width:234 height:93
(
	local renameScreenNum = 0
	button btn_renameObj "������" pos:[148,5] width:40 height:16 
	edittext Obj_base_name "" pos:[2,5] width:141 height:16
	radiobuttons rdo_mtlRenameScale "��������Χ��" pos:[108,42] width:128 height:46 enabled:false labels:#("�������в���   ", "�༭���в���   ") default:2 columns:1
	radiobuttons rdo_renameMethod "��������ʽ��" pos:[10,42] width:100 height:46 labels:#("ȫ������   ", "��Ϊǰ׺   ") default:1 columns:1 
	radiobuttons rdo_objORmtl "" pos:[9,25] width:228 height:16 labels:#("����������     ", "����������   ") columns:2
	button btn_manager "������" pos:[191,5] width:40 height:16
	button btn_help06 "?" pos:[213,25] width:15 height:16
	on btn_renameObj pressed do		--rename selected objects
	(	
		if Obj_base_name.text != "" then 
		case rdo_objORmtl.state of
		(
			1:	( --if  object rename
					if rdo_renameMethod.state == 1 then
			       		for i in selection do i.name = uniquename Obj_base_name.text
					else 
						for i in selection do i.name = Obj_base_name.text  + i.name
				)
			2:	( --if material rename
					if rdo_mtlRenameScale.state == 1 then
					(	if rdo_renameMethod.state ==1 then
						(	for i in 1 to scenematerials.count do
								scenematerials[i].name = Obj_base_name.text  + i as string
						)
						else
						(	for i in 1 to scenematerials.count do
								scenematerials[i].name = Obj_base_name.text  + scenematerials[i].name
						)
					) -- end off rename in scenematerials
					else 
					(	
							if rdo_renameMethod.state == 1 then
							(	for i in 1 to 24 do
									meditmaterials[i].name = Obj_base_name.text  + i as string
							)
							else
							(	for i in 1 to 24 do
									meditmaterials[i].name = Obj_base_name.text  + meditmaterials[i].name
							)
			
					) -- end off rename in meditmaterials
				)
		)
		else messagebox "�����������ƣ�" title:fl_tips01
	)
	on rdo_objORmtl changed stat do
	(	
		case stat of
		(
			1: rdo_mtlRenameScale.enabled = false
			2: rdo_mtlRenameScale.enabled = true
		)

	)
	on btn_manager pressed do
	(
		try destroydialog SP4_renameManager catch()
		thepos=GetDialogPos SP4_rename
		thepos.x+=240
		createdialog SP4_renameManager pos:thepos
	)
	on btn_help06 pressed do
	(
		tips = "1��������������ѡ��������������\n2�����������������л��߱༭���в�����������\n"
		tips += "3��������Լ����ӻ���ɾ���������������������Զ����档"
		messagebox tips title:(fl_fun_tips + " - ������") beep:off

	)
	on SP4_rename moved p do (
		if SP4_renameManager.open do 
		(
			p.x+=240
			SetDialogPos SP4_renameManager p
		)
	)
)


rollout SP4_renameManager "����������" width:228 height:209
(
	listbox lbx_pre "˫��ѡ��������" pos:[7,4] width:216 height:10
	edittext edt3 "" pos:[5,165] width:175 height:16
	button btn_add "����" pos:[188,165] width:36 height:17
	button btn_delete "ɾ��ѡ��" pos:[49,185] width:60 height:20
	button btn_exit "�� ��" pos:[122,185] width:60 height:20
	
	--add rename preference
	fn fl_addRenamePre str =
	(
		prenames = execute (getinisetting spInifilepath "Rename" "PreNames")
		if classof prenames != array then prenames=#()
		if finditem prenames str == 0 then
		(    append prenames str
			setinisetting spInifilepath "Rename" "PreNames" (prenames as string)
		)
		else messagebox "�������Ѿ����ڣ�"  title:fl_tips01 beep:off
	)
	--delete rename preference
	fn fl_deleteRenamePre idx =
	(
		prenames = execute (getinisetting spInifilepath "Rename" "PreNames")
		if idx != 0 then deleteItem prenames idx
		setinisetting spInifilepath "Rename" "PreNames" (prenames as string)
	)

	on SP4_renameManager open do
	(	
		if not doesfileexist spInifilepath then
		(	makedir spRootPath
			f=createfile spInifilepath
			close f
		)
		prenames = execute (getinisetting spInifilepath "Rename" "PreNames")
		if classof prenames == array then lbx_pre.items = prenames
	)
	on lbx_pre doubleClicked sel do
	(
		if sel != 0 then ( fl_rename.Obj_base_name.text = lbx_pre.items[sel];destroydialog SP4_renameManager)
		else destroydialog SP4_renameManager
	)
	on btn_add pressed do
	(
		if edt3.text != "" then fl_addRenamePre edt3.text
		destroydialog SP4_renameManager
		createdialog SP4_renameManager
	)
	on btn_delete pressed do
	(
		fl_deleteRenamePre lbx_pre.selection
		destroydialog SP4_renameManager
		createdialog SP4_renameManager
	)
	on btn_exit pressed do
	(
		destroydialog SP4_renameManager
	)
	on SP4_rename moved pp do
	(
		if CGplusplusFunc!=undefined then setinisetting spInifilepath "Main" "childLibPos" (pp as string)
	)
)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChildLib SP4_rename
else createdialog SP4_rename
