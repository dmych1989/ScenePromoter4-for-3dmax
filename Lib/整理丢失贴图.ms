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

--������ͼ
--2008-06-17

global SP4AddQuickPathRlt,SP4relinkmapRlt,SP4relinkmapDlg
global pathsToSearch = #()
global fl_friendllytips="����������ʾ"
global spRootPath=getdir #scripts +"\\ScenePromoter4"
global spInifilepath=spRootPath+"\\ScenePromoter4.ini"

try destroydialog SP4missingMap catch()

fn SP4searchDialog =
(
	SP4relinkmapDlg = newRolloutFloater "ָ����ͼ" 330 291
	SP4relinkmapDlg.pos = GetDialogPos SP4missingMap + [SP4missingMap.width+8,0]
	addrollout SP4relinkmapRlt SP4relinkmapDlg
)
fn filenameFromPathNew p = getfilenamefile p + getfilenametype p 
rollout SP4missingMap "�鿴��ʧ��ͼ�͹������ļ�" width:460 height:285
(
	local Objs,missMaps,missingMapsTemp,missingMapsObjs
	local tempWidth = 460 ,tempHeight = 280
	fn trim_dupsOne a = (
		for i in a.count to 1 by -1 do 
		(
			idx = findItem a a[i]
			if (idx != 0) AND (idx != i) do 
				deleteItem a i
		)
		a
	)
	fn getMissingMaps = 
	(
			local mapfiles = #()
			local mapfileN = #()
			local mapWebfile = #()
			local mBitmaps = getClassInstances BitmapTexture		-- gets all bitmapTextures in the scene
	
			mapfiles = mBitmaps										-- copies the array instance to "mapfiles"
			for m in mapfiles do (
				-- for every bitmap texture in the scene
				if (isProperty m #filename) then (
					-- that has a #filename property	
					if m.filename != "" then (
						-- that isn't blank
						if not (doesFileExist m.filename) then		-- if it doesn't exist, add to the array mapfileN
							append mapfileN m.filename
					)
				)
			)
			if (not(doesFileExist(backgroundImageFilename))) then
				append mapfileN backgroundImageFilename
			trim_dupsOne mapfileN
			sort mapfileN
			--Collect missing webfiles
			for l in lights do
				if matchPattern (classof l as string) pattern:"Target_*" then
				(	local p = l.webfile
					if p != "" and not doesfileexist p then
						append mapWebfile p
				)
			if mapWebfile.count !=0 then
			(	trim_dupsOne mapWebfile
				sort mapWebfile
				join mapfileN mapWebfile
			)

			for i = 1 to mapfileN.count where mapfileN[i] == "" do deleteItem mapfileN i
			mapfileN											-- returns the new array of only missing bitmaptextures
	) 
	fn getMissingMapsObjs = 
	(
		missingMapsTemp = missMaps
		missingMapsObjs = #()
		if 	missingMapsTemp.count != 0 then
		(	
			-- initialize missingMapsObjs
			for o = 1 to missingMapsTemp.count do
				append missingMapsObjs #()
			-- called for enumerateFiles()
			fn addmapObjs map obj = 
			(
				local missingMapfilename = map as string
				local Idx = findItem missingMapsTemp missingMapfilename 
				if Idx != 0 do append missingMapsObjs[Idx] obj 
			)
			for i = 1 to objects.count where objects[i].material != undefined do		-- cycle through the scene objects
				enumerateFiles objects[i] addmapObjs objects[i] #missing	
			for j in lights where matchPattern (classof j as string) pattern:"Target_*" do
				enumerateFiles j addmapObjs j #missing
		)
		for k in missingMapsObjs do trim_dupsOne k 
		missingMapsObjs 										-- return the array of only missing bitmaptextures
	)
	--Clear selected missing maps
	fn clrMissingMaps = 
	(	local mapfiles = #()
		local mBitmaps = getClassInstances BitmapTexture
		
		if (not(doesFileExist(backgroundImageFilename))) then
			append mBitmaps backgroundImageFilename
		mapfiles = mBitmaps
		local clrSelection = SP4missingMap.lbx_missingMaps.selection as array
		if clrSelection.count != 0 then
		(	local clrMissingMaps = #()
			for c = 1 to clrSelection.count do
				append clrMissingMaps (filenameFromPathNew SP4missingMap.lbx_missingMaps.items[c]) --Get the map than will be cleared
			with redraw off (
					for i=1 to mapfiles.count do (
						-- for all bitmapTextures in the scene
						if (isProperty mapfiles[i] #filename) then (
							local curFile = filenameFromPathNew mapfiles[i].filename
							if (index = findItem clrMissingMaps curFile) != 0 then 	-- check if the current file is missing
									mapfiles[i].filename = ""		-- Clear the current file
						)
					)
					if (not(doesFileExist(backgroundImageFilename))) then (
						for i=1 to mapfiles.count do (
							local curFile = filenameFromPathNew (mapfiles[i] as string)
							if (index = findItem clrMissingMaps  curFile) != 0 then
								backgroundImageFilename = ""  -- Clear the background
						)
					)				
				)
		)
	)

	--Display the objects relective to the missing map
	fn displayObjs sel =
	(	s = sel
		if s != 0 then
		(	if Objs[s].count != 0 then
			(	objsNamesString = ""
				n = 0
				for o in 1 to Objs[s].count-1 while objsNamesString.count<100 do 
				(	append objsNamesString (Objs[s][o].name+", ")
					n+=1
				)
				append objsNamesString Objs[s][n+1].name
				SP4missingMap.edt_missingmapObjs.text = objsNamesString 
			) 
			else SP4missingMap.edt_missingmapObjs.text = "û���ҵ�ʹ�ø���ͼ�����壡"
		)
	)
	multiListBox lbx_missingMaps "��ʧ��ͼ·��:" pos:[5,27] width:450 height:10 
	button btn_refeshMaps "ˢ��" pos:[350,14] width:85 height:25 toolTip:"���¼��㶪ʧ��ͼ����ʾ�������б�"
	button btn_missMapObjs "ѡ������" pos:[258,14] width:85 height:25 toolTip:"ѡ��ʹ���б���ѡ����ͼ������"
	button btn_closeMissmap "�˳�" pos:[170,184] width:85 height:25 toolTip:"�رմ˶Ի���"
	button btn_printTxt "������ʧ��Ϣ" pos:[260,184] width:85 height:25 toolTip:"�رմ˶Ի���"
	edittext edt_missingmapObjs "ʹ�ø���ͼ�����壺" pos:[5,210] width:450 height:20 readOnly:true labelOnTop:true
	button btn_relinkDialog "ָ����ͼ" pos:[351,184] width:85 height:25 toolTip:"��/�ر�ָ����ͼ�Ի���"
	button btn_delSelectedMaps "���ѡ����ͼ" pos:[166,14] width:85 height:25 toolTip:"�������ļ����ֶ����"
	label lbl "������" pos:[416,258] width:59 height:16 enabled:false
	on SP4missingMap open do	--Initialize this dialog
		btn_refeshMaps.pressed()
	on SP4missingMap close do
		try closeRolloutFloater SP4relinkmapDlg catch()
	on SP4missingMap resized s do --Resezed doing
	(	if s[1]>=460 then
		(	
			if s[2] >= 280 then
			(
				movedWidth = s[1]-tempWidth
				movedHeight = s[2]-tempHeight
				lbx_missingMaps.width += movedWidth 
				lbx_missingMaps.height += movedHeight
				edt_missingmapObjs.width += movedWidth 
							
				btn_missMapObjs.pos.x += movedWidth
				btn_refeshMaps.pos.x += movedWidth
				btn_closeMissmap.pos.x += movedWidth
				btn_closeMissmap.pos.y += movedHeight
				btn_relinkDialog.pos.x += movedWidth
				btn_relinkDialog.pos.y += movedHeight
				edt_missingmapObjs.pos.y += movedHeight
				btn_delSelectedMaps.pos.x += movedWidth
				lbl.pos.x+=movedWidth
				lbl.pos.y+=movedHeight
				hplbs.pos.x+=movedWidth
				hplbs.pos.y+=movedHeight
				
				btn_printTxt.pos.x += movedWidth
				btn_printTxt.pos.y += movedHeight
				tempWidth = s[1]
				tempHeight= s[2]
				
				SP4relinkmapDlg.pos = GetDialogPos SP4missingMap + [SP4missingMap.width+8,0]
			)
			else	SP4missingMap.height = 280
		)
		else 
		(	if s[2] >= 280 then
			(
				movedHeight = s[2]-tempHeight
	
				lbx_missingMaps.height += movedHeight
				btn_closeMissmap.pos.y += movedHeight
				btn_relinkDialog.pos.y += movedHeight
				edt_missingmapObjs.pos.y += movedHeight
				
				tempHeight= s[2]
				SP4missingMap.width = 460
			)
			else SP4missingMap.height = 280
	
		)-- end else
	
	)	--end resezed button
	on SP4missingMap moved pp do
	(	
		SP4relinkmapDlg.pos = GetDialogPos SP4missingMap + [SP4missingMap.width+8,0]
		if CGplusplusFunc!=undefined then setinisetting spInifilepath "Main" "childLibPos" (pp as string)

	)
	on lbx_missingMaps selected sel do
	(	local selItem = (lbx_missingMaps.selection as array)[1]
		if selItem != undefiend then
			if missMaps[selItem] != "" then displayObjs selItem
	)
	on lbx_missingMaps doubleClicked sel do
		btn_missMapObjs.pressed()
	on btn_refeshMaps pressed do
	(	missMaps = getMissingMaps()
		if missMaps[1] == undefiend then
		(	lbx_missingMaps.items = #()
			edt_missingmapObjs.text = "û���ҵ���ʧ��ͼ��"
		)
		else
		(	lbx_missingMaps.items = missMaps
			Objs = getMissingMapsObjs()
			if missMaps.count !=0 then 
			(	lbx_missingMaps.selection = 1
				displayObjs 1
			)
		)
	)
	on btn_missMapObjs pressed do
	(	index = (lbx_missingMaps.selection as array)[1]
		if index != undefiend then
			if missMaps[index] != "" then
			(	if Objs[index].count != 0 then try select Objs[index] catch messagebox "����ʹ�ø���ͼ�������ѱ�ɾ������ˢ�����ԣ�" title:fl_friendllytips beep:off
				else messagebox "������û��ʹ�ø���ͼ�����壬��ˢ�²����򣬻�鿴������ͼ�ͱ�����ͼ��" title:fl_friendllytips beep:off
			)
	)
	on btn_printTxt pressed do
	(
		if lbx_missingMaps.items.count != 0 then
		(
			str = "Max�ļ�·����\n"+ maxfilepath + maxfilename
			str += "\n����ʱ�䣺" + localtime
			str += "\n��ʧ��ͼ��Ϣ��\n"
			for i in lbx_missingMaps.items do str +=i + "\n"
			s = newscript()
			format "%" str to:s
		)
		else messagebox "�б��ǿյ�~~~"
	)
	on btn_missMapObjs rightClick do
		messagebox "˵��������ѡ���������˫���б��е�ĳһ�����ѡ��ʹ�ø���ͼ�����塣\nAsset Tracking ������ʾΪ Found ����ͼ����ѡ�����塣" title:fl_friendllytips beep:off
	on btn_closeMissmap pressed do
	(	try closeRolloutFloater SP4relinkmapDlg catch()
		destroyDialog SP4missingMap
	)
	on btn_relinkDialog pressed do
	(	if SP4relinkmapDlg.open then closeRolloutFloater SP4relinkmapDlg
		else SP4searchDialog()
	)
	on btn_delSelectedMaps pressed do
	(	clrMissingMaps ()
		btn_refeshMaps.pressed()
	)
)



rollout SP4relinkmapRlt "ָ����ͼ" width:320 height:260
(
	local tempSelPaths
	edittext edt_filepath "ָ����ͼ·����" pos:[12,7] width:264 height:20 labelOnTop:true
	button btn_browsemappath "..." pos:[278,25] width:29 height:20
	button btn_relinkmap "ָ����ͼ" pos:[20,52] width:100 height:20 enabled:false
	multiListBox mut_savedpath "Ĭ����ͼ·��:" pos:[10,79] width:302 height:10
	button btn_deletePath "ɾ��" pos:[272,235] width:40 height:20
	checkbox chk_selAll "ȫѡ" pos:[18,235] width:48 height:20
	button btn_clearSel "���ѡ��" pos:[77,235] width:60 height:18
	button btn_addPaths "����" pos:[227,235] width:40 height:20
	checkbox chk_includeSubDir "����������Ŀ¼(���Ƽ�)" pos:[135,53] width:175 height:20 checked:false
	
	
	fn updateSavedPaths = (
			local iniPaths = getINISetting spInifilepath "MapPaths"
			local keys = #()
			
			if iniPaths.count != 0 then(
			for i = 1 to iniPaths.count do
				append keys (getINISetting spInifilepath "MapPaths" iniPaths[i])
			
			mut_savedpath.items = #()
			mut_savedpath.items = keys
			)
	)
	fn updateRelinkButton = (
		if (mut_savedpath.selection as array).count == 0 and edt_filepath.text == "" then (
			btn_relinkmap.enabled = false
		)
		else
			btn_relinkmap.enabled = true
	)
	fn remakeINIFile = (
			local iniPaths = getINISetting spInifilepath "MapPaths"
			local keys = #()
			
			if iniPaths.count != 0 then(
			for i = 1 to iniPaths.count do
				append keys (getINISetting spInifilepath "MapPaths" iniPaths[i])
			
			delIniSetting spInifilepath "MapPaths"		-- Deletes all entries in the INI File
			
			for i = 1 to keys.count do
				setINISetting spInifilepath "MapPaths" (i as string) keys[i]
			)
	)
	-- Gets the paths the user wants to search for textures
	fn getFilesdirs root =
	(
		dir_array = GetDirectories (root+"/*")
		join pathsToSearch dir_array
		for d in dir_array do
		(	local dir = GetDirectories (d+"/*")
			if dir.count != 0 then
				getFilesdirs d
		)
	)
	fn getPathsToSearch = (
		pathsToSearch = #()
		if edt_filepath.text != "" then
			append pathsToSearch edt_filepath.text
		
		local lsel = (mut_savedpath.selection as array)
		if lsel.count != 0 then (
			for i = 1 to lsel.count do 
			(	append pathsToSearch mut_savedpath.items[lsel[i]]
				local dir = GetDirectories (mut_savedpath.items[lsel[i]]+"/*")
				if dir.count!=0 then join pathsToSearch dir
			)
		)
		--if chk_includeSubDir checked,then get all subdirectorys
		if chk_includeSubDir.checked then 
			for j in pathsToSearch do getFilesdirs j
		pathsToSearch
	)
	fn getDirectoryFiles = (
		local dir_arr = #()
		local file_arr = #()
	
		pathsToSearch = getPathsToSearch()
		join dir_arr pathsToSearch
	
		for d in dir_arr do (
			if d[d.count] != "\\" and d[d.count] != "/" then 
				d += "\\"
	
			try (
				local tmp_files = getFiles (d + "*.*")
				if tmp_files.count != 0 then 
					join file_arr tmp_files
			)
			catch ( )	
		)
		file_arr
	)
	-- Relinking Function 
	fn relinkMaps = (
		local mapfiles = #()
		local mapfilesMissing = #()
		local file_arr_filename = #()
		local mBitmaps = getClassInstances BitmapTexture
		local webPoints = for l in lights where  matchPattern (classof l as string) pattern:"Target_*" collect l
		local MissingPoints = for f in webPoints while f.webfile != "" where not doesFileExist f.webfile collect f
		if (not(doesFileExist(backgroundImageFilename))) then
			append mBitmaps backgroundImageFilename
		mapfiles = mBitmaps
		local file_arr = getDirectoryFiles()	-- contains the paths of found files
		for i in file_arr do
			append file_arr_filename (filenameFromPathNew i)
		local missingMaps = SP4missingMap.getMissingMaps()	-- Missing Map names
		with redraw off (
				for i=1 to mapfiles.count do (
					-- for all bitmapTextures in the scene
					if (isProperty mapfiles[i] #filename) then (
						local curFile = filenameFromPathNew mapfiles[i].filename
						if (index = findItem file_arr_filename curFile) != 0 then 	-- check if the current file is missing
								mapfiles[i].filename = file_arr[index]		-- Relinks the current file to the found file
					)
				)
				for w in MissingPoints do
				(	tempWebfile = w.webfile
					local curFile = filenameFromPathNew tempWebfile
					if (index = findItem file_arr_filename curFile) != 0 then 	-- check if the current webfile is missing
							w.webfile = file_arr[index]		-- Relinks the current webfile to the found file
				)
				if (not(doesFileExist(backgroundImageFilename))) then (
					for i=1 to mapfiles.count do (
						local curFile = filenameFromPathNew (mapfiles[i] as string)
						if (index = findItem file_arr_filename curFile) != 0 then
							backgroundImageFilename = file_arr[index]  -- Relink the background
					)
				)				
			)
	)

	on SP4relinkmapRlt open do
	(	if not doesfileexist spInifilepath then
		(	makedir spRootPath
			f=createfile spInifilepath
			close f
		)
		updateSavedPaths()
		)
	on edt_filepath changed txt do
	(	if txt != "" then
			btn_relinkmap.enabled = true
		else if (mut_savedpath.selection as array).count == 0 then
			btn_relinkmap.enabled = false
	
	)
	on btn_browsemappath pressed do
	(	local browseDirectory = getSavePath "ָ��·��"
		if browseDirectory != undefined and browseDirectory != "" then (
			edt_filepath.text = browseDirectory
			btn_relinkmap.enabled = true
		)
	)
	on btn_relinkmap pressed do
	(	if (local toSearch = getPathsToSearch()) != "" then 
		(	
			max create mode
			RelinkMaps()
			SP4missingMap.btn_refeshMaps.pressed()
		) 
	)
	on mut_savedpath selected sel do
		(	updateRelinkButton()
	)
	on btn_deletePath pressed do
	(	local selectedQuickPaths = mut_savedpath.selection as array
		for i in selectedQuickPaths do
			delIniSetting spInifilepath "MapPaths" (i as string)
		remakeINIFile()
		updateSavedPaths()
		closerolloutfloater SP4relinkmapDlg
		SP4searchDialog()
	)
	on chk_selAll changed state do
	(	if state then
		(	tempSelPaths = mut_savedpath.selection
			local tmp_arr = #()
			for i = 1 to mut_savedpath.items.count do tmp_arr[i] = i
			mut_savedpath.selection = tmp_arr
		)
		else mut_savedpath.selection = tempSelPaths
		updateRelinkButton ()
	)
	on btn_clearSel pressed do
	(	mut_savedpath.selection = #()
		chk_selAll.state = false
		tempSelPaths = #()
		updateRelinkButton ()
	)
	on btn_addPaths pressed do
	(	SP4relinkmapDlg.size.y = 352
		addrollout SP4AddQuickPathRlt SP4relinkmapDlg
	)
)


rollout SP4AddQuickPathRlt "����Ĭ��·��" width:320 height:37
(
	edittext edt_AddQuickPath "" pos:[4,9] width:274 height:20
	button btn_browseAddQuickPaths "..." pos:[287,10] width:24 height:20
	--replace the "\\" to "/"
	fn fl_replaceBlackSlash path =
	(	
		for i = 1 to path.count do 
		if (idx = findstring path "\\" ) != undefined then path[idx] = "/"
		path
	)
	on btn_browseAddQuickPaths pressed do
	(
			local browseDirectory = getSavePath "ָ��·��"
			if browseDirectory != undefined then (
				edt_AddQuickPath.text = browseDirectory
			)
			if edt_AddQuickPath.text != "" then (
				local iniPaths = getINISetting spInifilepath "MapPaths"
				local keys = #()
				
				if iniPaths.count != 0 then (
				for i = 1 to iniPaths.count do
					append keys (getINISetting spInifilepath "MapPaths" iniPaths[i])
				)
				setINISetting spInifilepath "MapPaths" (((iniPaths.count)+1) as string) (fl_replaceBlackSlash edt_AddQuickPath.text)
				SP4relinkmapRlt.updateSavedPaths()
			)
			removerollout SP4AddQuickPathRlt SP4relinkmapDlg
			SP4relinkmapDlg.size.y = 291
	)

)

if CGplusplusFunc!=undefined  then 
(
	pos0 = execute (getinisetting spInifilepath "Main" "childLibPos")
	if classof pos0 == Point2 then createdialog SP4missingMap pos:pos0 fgcolor:SPtxtcolor style:#(#style_titlebar, #style_border, #style_sysmenu,#style_resizing)
	else createdialog SP4missingMap style:#(#style_titlebar, #style_border, #style_sysmenu,#style_resizing)
)
else createdialog SP4missingMap
--createdialog SP4missingMap pos:[0,(sysInfo.desktopSize[1]*0.1)] style:#(#style_titlebar, #style_border, #style_sysmenu,#style_resizing)
SP4searchDialog()

