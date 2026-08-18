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
fn openAllGroups obj =
(
	sourceObj = for i in obj where not isOpenGroupHead i collect i
	if sourceObj.count != 0 then for o in sourceObj do setGroupOpen o true else return true
	for j in 1 to sourceObj.count do openAllGroups sourceObj
)
(	if selection.count != 0 then
		obj = for i in selection where CGplusplusFunc.notHiddenOrFrozen i and isGroupHead i collect i
	else obj = for i in objects where CGplusplusFunc.notHiddenOrFrozen i and isGroupHead i collect i
		openAllGroups obj
)
