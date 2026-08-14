(
	clearListener()
	
	try destroyDialog cCleanerRollout catch()
	
	global lTasks_4648134686 =
	#(
		(struct s( tName = "--场景--记录 tracks",
			
			tTooltip = "\
			3ds Max tends to automaticly save notetracks in your scenes that are comments for animationtracks. \
			However these notetracks can become quite numerous and dramatically increase the size of your scene and make saving process extremly slow. \
			So it is a good idea to keep an eye on these automaticly created notetracks and clean them from time to time. \
			Remember that you will import notetracks from other files if you are using xrefs. \
			Cleaning just the scene doesn't solve the problem, you got to clean the xref aswell or you will import the notetracks everytime you load the xref.
			",
			
			fn autocount =
			(
				try (numNoteTracks TrackViewNodes.Max_MotionClip_Manager) catch ("-")
			),
			
			fn clean =
			(
				try 
				(
					trackViewNodes[#Max_MotionClip_Manager].track = copy trackViewNodes[#Max_MotionClip_Manager].track
					gc()
				)
				catch()
			)
			
		);)(),
		
		(struct s( tName = "反应 碰撞",
			
			tTooltip = "\
			3ds Max tends to save reactor collisions in your scene. \
			Just as notetracks this can increase the filesize, ram usage, savetime for your scene. \
			However Reactor is not part of 3ds Max anymore from version 2012 on.\
			",
			
			fn autocount =
			(
				if reactor != undefined
					then reactor.getNumStoredCollisions()
					else "-"
			),
			
			fn clean =
			(
				if reactor != undefined then reactor.clearStoredCollisions()
			)
			
		);)(),
		
		(struct s( tName = "空的 图层",
			
			tTooltip = "删除空的图层.",
			
			fn autocount =
			(
				local nEmptyLayers = 0
				
				for nLayer = layerManager.count to 2 by -1 do
				(
					local layer = layerManager.getLayer (nLayer - 1)
					
					local lNodes = undefined
					layer.nodes &lNodes
					
					if lNodes.count == 0 do nEmptyLayers += 1
				)
				
				return nEmptyLayers
			),
			
			fn clean =
			(
				-- active layer = layer 0
				(layerManager.getLayer 0).current = true
				
				for nLayer = layerManager.count to 2 by -1 do
				(
					local layer = layerManager.getLayer (nLayer - 1)
					
					local lNodes = undefined
					layer.nodes &lNodes
					
					if lNodes.count == 0 do layerManager.deleteLayerByName layer.name
				)
			)
			
		);)(),
		
		(struct s( tName = "重置材质编辑器",
			
			tTooltip = "重置为默认材质.",
			
			fn autocount =
			(
				"-"
			),
			
			fn clean =
			(
				for nMat = 2 to meditMaterials.count do
				(
					local tMat = "mat"+(sceneMaterials.count + nMat) as string
					local mat = if matchpattern (renderers.current as string) pattern:"v_ray*"
						then VR材质 name:tMat
						else standardmaterial name:tMat
					
					mat.diffuse = (color 30 30 30)
					setMTLMEditFlags mat #{2..3}
					setMeditMaterial nMat mat
				)
			)
			
		);)(),
		
		(struct s( tName = "失踪的插件",
			
			tTooltip = "场景正确必须所有插件都存在,有些插件可能丢失,导致当前场景的错误。",
			
			fn autocount =
			(
				""
			),
			
			fn usercount =
			(
				local nCount = 0
				
				local t = stringstream ""
				apropos "*missing*" to:t
				t = t as string
				
				local l = filterstring t "\n "
				local lMissingClasses = #()
				for t in l do
				(
					if matchpattern t pattern:"missing*" then
					(
						local cls = execute t
						if matchpattern (cls as string) pattern:"missing*" then
						(
							local lInst = getclassinstances cls
							nCount += lInst.count
						)
					)
				)
				
				nCount
			),
			
			fn clean =
			(
				local t = stringstream ""
				apropos "*missing*" to:t
				t = t as string
				
				local l = filterstring t "\n "
				local lMissingClasses = #()
				for t in l do
				(
					if matchpattern t pattern:"missing*" then
					(
						local cls = execute t
						if matchpattern (cls as string) pattern:"missing*" then
						(
							local lInst = getclassinstances cls
							print lInst
						)
					)
				)
			)
			
		);)(),
		
		(struct s( tName = "失踪的自定义属性",
			
			tTooltip = "一些奇怪的中文bug?",
			
			fn autocount =
			(
				"-"
			),
			
			fn clean =
			(
				local pickedTrack = trackView.pickTrackDlg()
				if pickedTrack != undefined then deleteItem pickedTrack.anim.CustAttributes 1
			)
			
		);)(),
		
		(struct s( tName = "场景状态",
			
			tTooltip = "一些奇怪的中文bug?",
			
			fn autocount =
			(
				sceneStateMgr.GetCount()   
			),
			
			fn clean =
			(
				for n=sceneStateMgr.GetCount() to 1 by -1 do sceneStateMgr.Delete (sceneStateMgr.GetSceneState n)
			)
			
		);)(),
		
		(struct s( tName = "选择集",
			
			tTooltip = "创建的选择集",
			
			fn autocount =
			(
				selectionSets.count
			),
			
			fn clean =
			(
				for n=selectionSets.count to 1 by -1 do deleteItem selectionSets selectionSets[n]
			)
			
		);)(),
		
		(struct s( tName = "--ID--对象 ID",
			
			tTooltip = "场景全部 对象 ID 0.",
			
			fn autocount =
			(
				local lObjIds = #()
				
				for obj in objects where obj.gbufferchannel != 0 do appendIfUnique lObjIds obj.gbufferchannel
				
				print "对象 ID:"
				print ((sort lObjIds) as string)
				
				return lObjIds.count
			),
			
			fn clean =
			(
				for obj in objects do obj.gbufferchannel = 0
			),
			
			fn selectObjects =
			(
				local lObjs = #()
				for obj in objects where obj.gbufferchannel != 0 do append lObjs obj
				
				select lObjs
				
				local bRefreshSel = false
				for obj in selection do
				(
					if isGroupHead obj and not isOpenGroupHead obj then
					(
						bRefreshSel = true
						setGroupOpen obj true
					)
				)
				if bRefreshSel then select lObjs
			)
			
		);)(),
		
		(struct s( tName = "材质 ID 通道",
			
			tTooltip = "场景全部 材质 ID 通道 0.",
			
			fn autocount =
			(
				local lMatIds = #()
				
				for mat in scenematerials do
				(
					try
					(
						if classof mat == multimaterial
							then for subMat in mat.materialList where subMat.effectsChannel != 0 do appendIfUnique lMatIds subMat.effectsChannel 
							else if mat.effectsChannel != 0 then appendIfUnique lMatIds mat.effectsChannel
					)
					catch ()
				)
				
				print "material ids:"
				print ((sort lMatIds) as string)
				
				return lMatIds.count
			),
			
			fn clean =
			(
				for mat in scenematerials do
				(
					try
					(
						if classof mat == multimaterial
							then for subMat in mat.materialList where subMat.effectsChannel != 0 do subMat.effectsChannel = 0
							else if mat.effectsChannel != 0 then mat.effectsChannel = 0
					)
					catch ()
				)
			),
			
			fn selectObjects =
			(
				local lMats = #()
				
				for mat in scenematerials do
				(
					try
					(
						if classof mat == multimaterial
							then for subMat in mat.materialList where subMat.effectsChannel != 0 do appendIfUnique lMats subMat
							else if mat.effectsChannel != 0 then appendIfUnique lMats mat
					)
					catch ()
				)
				
				local lObjs = #()
				for mat in lMats do for obj in (refs.dependents mat) where classof (superclassof obj) == node do appendIfUnique lObjs obj
				
				select lObjs
				
				local bRefreshSel = false
				for obj in selection do
				(
					if isGroupHead obj and not isOpenGroupHead obj then
					(
						bRefreshSel = true
						setGroupOpen obj true
					)
				)
				if bRefreshSel then select lObjs
			),
			
			fn selectMaterials =
			(
				local lMats = #()
				
				for mat in scenematerials do
				(
					try
					(
						if classof mat == multimaterial
							then for subMat in mat.materialList where subMat.effectsChannel != 0 do appendIfUnique lMats subMat
							else if mat.effectsChannel != 0 then appendIfUnique lMats mat
					)
					catch ()
				)
				
				for nMat = 1 to lMats.count where nMat <= meditMaterials.count do setMeditMaterial nMat lMats[nMat]
			)
			
		);)(),
		
		(struct s( tName = "--几何体--壳模型",
			
			tTooltip = "加了壳修改器的对象",
			
			fn autocount =
			(
				local nCount = 0
				
				for modObj in getclassinstances shell where not modObj.straightenCorners do nCount += 1
				
				nCount
			),
			
			fn clean =
			(
				for modObj in getclassinstances shell where not modObj.straightenCorners do modObj.straightenCorners = true
			),
			
			fn selectObjects =
			(
				local lmodInst = getclassinstances shell
				
				local lObjs = #()
				for modObj in lmodInst do for obj in (refs.dependents modObj) where classof (superclassof obj) == node do appendIfUnique lObjs obj
				
				select lObjs
				
				local bRefreshSel = false
				for obj in selection do
				(
					if isGroupHead obj and not isOpenGroupHead obj then
					(
						bRefreshSel = true
						setGroupOpen obj true
					)
				)
				if bRefreshSel then select lObjs
			)
			
		);)(),
		
-- 		(struct s( tName = "Flipped IES",
-- 			
-- 			tTooltip = "IES.",
-- 			
-- 			fn autocount =
-- 			(
-- 				local nCount = 0
-- 				
-- 				for iesLight in lights where classof iesLight == VRayIES do
-- 				(
-- 					if iesLight.transform[3].z < 0 and iesLight.center.z > iesLight.target.pos.z then nCount += 1
-- 				)
-- 				
-- 				nCount
-- 			),
-- 			
-- 			fn clean =
-- 			(
-- 				for iesLight in lights where classof iesLight == VRayIES do
-- 				(
-- 					if iesLight.transform[3].z < 0 and iesLight.center.z > iesLight.target.pos.z then
-- 					(
-- 						-- unlink
-- 						local lChilds = for child in iesLight.children collect child
-- 						local parent = iesLight.parent
-- 						for child in lChilds do child.parent = undefined
-- 						iesLight.parent = undefined
-- 						
-- 						iesLight.scale = [1,1,1]
-- 						
-- 						-- relink
-- 						for child in lChilds do child.parent = iesLight
-- 						iesLight.parent = parent
-- 					)
-- 				)
-- 			)
-- 			
-- 		);)(),
-- 		
		(struct s( tName = "连接符合",
			
			tTooltip = "有时候当你导入AutoCad模型到 max, 你会发现很多看不见的对象 连接符合.",
			
			fn autocount =
			(
				(getclassinstances LinkComposite).count
			),
			
			fn clean =
			(
				delete (for o in (getclassinstances LinkComposite astrackviewpick:true) collect o.client)
			)
			
		);)(),
		
		(struct s( tName = "失踪 几何对象",
			
			tTooltip = "失踪的插件来显示对象在你的场景",
			
			fn autocount =
			(
				local nCount = 0
				
				for obj in objects where matchpattern ((classof obj) as string) pattern:"*miss*" do nCount += 1
				
				nCount
			),
			
			fn clean =
			(
				for obj in objects where matchpattern ((classof obj) as string) pattern:"*miss*" do delete obj
			),
			
			fn selectObjects =
			(
				local lObjs = #()
				for obj in objects where matchpattern ((classof obj) as string) pattern:"*miss*" do append lObjs obj
				
				select lObjs
				local bRefreshSel = false
				for obj in selection do
				(
					if isGroupHead obj and not isOpenGroupHead obj then
					(
						bRefreshSel = true
						setGroupOpen obj true
					)
				)
				if bRefreshSel then select lObjs
			)
			
		);)(),
		
		(struct s( tName = "--材质--丢失纹理贴图",
			
			tTooltip = "场景中丢失纹理贴图的 对象/材质",
			
			fn autocount =
			(
				(getclassinstances missing_texturemap).count
			),
			
			fn clean =
			(
				local lTvps = #()
				for tvp in (getclassinstances missing_texturemap asTrackViewPick:true) do appendIfUnique lTvps tvp.client
				for tvp in lTvps do 
				(
					local lPropNames = getPropNames tvp
					for propName in lPropNames do
					(
						local prop = getproperty tvp propName
						if classof prop == missing_texturemap then try setProperty tvp propName undefined catch()
					)
				)
			),
			
			fn selectObjects =
			(
				local lObjs = #()
				for mat in (getclassinstances missing_texturemap) do
				(
					for obj in (refs.dependents mat) where classof (superclassof obj) == node do appendIfUnique lObjs obj
				)
				
				select lObjs
				local bRefreshSel = false
				for obj in selection do
				(
					if isGroupHead obj and not isOpenGroupHead obj then
					(
						bRefreshSel = true
						setGroupOpen obj true
					)
				)
				if bRefreshSel then select lObjs
			),
			
			fn selectMaterials =
			(
				local lMats = #()
				
				for mat in (getclassinstances missing_texturemap) do appendIfUnique lMats mat
				
				for nMat = 1 to lMats.count where nMat <= meditMaterials.count do setMeditMaterial nMat lMats[nMat]
			)
			
		);)(),
		
		(struct s( tName = "Bercon Noise",
			
			tTooltip = "Cleans Thinking Particles TP Variation Texmap in ColorCorrects, Vray-Materials and Multisubmaterials.",
			
			fn autocount =
			(
				if berconnoise != undefined
					then (getclassinstances berconnoise).count
					else "-"
			),
			
			fn clean =
			(
				if berconnoise != undefined then 
				(
					local lMaps = makeUniqueArray (getclassinstances berconnoise)
					
					for map in lMaps do
					(
						local lDeps = refs.dependents map
						local parent = lDeps[1]
						local replaceMap = noise \
							color1:map.color1 \
							color2:map.color2 \
							map1:map.map1 \
							map2:map.map2 \
							map1Enabled:map.map1Enabled \
							map2Enabled:map.map2Enabled \
							size:map.size \
							phase:map.phase \
							levels:map.levels \
							thresholdLow:map.thresholdLow \
							thresholdHigh:map.thresholdHigh \
							coords:map.coords \
							output:map.output
						
						if map.fractalType <= 2 then replaceMap.type = map.fractalType
						
						case classof parent of
						(
							ColorCorrect: parent.src_tex = replaceMap
							VrayMtl: parent.texmap_diffuse = replaceMap
							Standardmaterial: parent.diffuseMap = replaceMap
						)
					)
				)
			),
			
			fn selectObjects =
			(
				if berconnoise != undefined then 
				(
					local lObjs = #()
					for mat in (getclassinstances berconnoise) do
					(
						for obj in (refs.dependents mat) where classof (superclassof obj) == node do appendIfUnique lObjs obj
					)
					
					select lObjs
					local bRefreshSel = false
					for obj in selection do
					(
						if isGroupHead obj and not isOpenGroupHead obj then
						(
							bRefreshSel = true
							setGroupOpen obj true
						)
					)
					if bRefreshSel then select lObjs
				)
			),
			
			fn selectMaterials =
			(
				if berconnoise != undefined then 
				(
					local lMats = #()
					
					for mat in (getclassinstances berconnoise) do appendIfUnique lMats mat
					
					for nMat = 1 to lMats.count where nMat <= meditMaterials.count do setMeditMaterial nMat lMats[nMat]
				)
			)
			
		);)(),
		
		(struct s( tName = "TP Variation Texmap",
			
			tTooltip = "Cleans Thinking Particles TP Variation Texmap in ColorCorrects, Vray-Materials and Multisubmaterials.",
			
			fn autocount =
			(
				if tp_variation_texmap != undefined
					then (getclassinstances tp_variation_texmap).count
					else "-"
			),
			
			fn clean =
			(
				if tp_variation_texmap != undefined then 
				(
					local lMaps = makeUniqueArray (getclassinstances tp_variation_texmap)
					
					-- 
					for map in lMaps do
					(
						local lDeps = refs.dependents map
						local parent = lDeps[1]
						
						case classof parent of
						(
							ColorCorrect:
							(
								parent.src_color = parent.src_tex.color
								parent.src_tex = undefined
							)
							VrayMtl:
							(
								parent.diffuse = parent.texmap_diffuse.color
								parent.texmap_diffuse = undefined
							)
							Standardmaterial:
							(
								parent.diffuse = parent.diffuseMap.color
								parent.diffuseMap = undefined
							)
						)
					)
				)
			),
			
			fn selectObjects =
			(
				if tp_variation_texmap != undefined then 
				(
					local lObjs = #()
					for mat in (getclassinstances tp_variation_texmap) do
					(
						for obj in (refs.dependents mat) where classof (superclassof obj) == node do appendIfUnique lObjs obj
					)
					
					select lObjs
					local bRefreshSel = false
					for obj in selection do
					(
						if isGroupHead obj and not isOpenGroupHead obj then
						(
							bRefreshSel = true
							setGroupOpen obj true
						)
					)
					if bRefreshSel then select lObjs
				)
			),
			
			fn selectMaterials =
			(
				if tp_variation_texmap != undefined then 
				(
					local lMats = #()
					
					for mat in (getclassinstances tp_variation_texmap) do appendIfUnique lMats mat
					
					for nMat = 1 to lMats.count where nMat <= meditMaterials.count do setMeditMaterial nMat lMats[nMat]
				)
			)
			
		);)(),
		
		(struct s( tName = "Vray材质GI 灯光材质",
			
			tTooltip = "灯光材质必须在Vray包裹材质GI关闭, 否则会导致外部参照错误.",
			
			fn autocount =
			(
				local nCount = 0
				
				local lLightMtlTvps = getclassinstances VR灯光材质 astrackviewpick:true
				for lightMtlTvp in lLightMtlTvps do
				(
					local lightMtl = lightMtlTvp.anim
					local parent = lightMtlTvp.client
					local wrapperMtl = VR材质包裹器 generateGI:false basemtl:lightMtl
					
					if (classof (superclassof parent)) == node then
					(
						nCount += 1
					)
					
					else if classof parent == multimaterial then
					(
						for nMat = 1 to parent.MaterialList.count do
						(
							if parent.MaterialList[nMat] == lightMtl then nCount += 1
						)
					)
					
					else if classof parent == VR材质包裹器 and parent.generateGI == true then
					(
						nCount += 1
					)
				)
				
				nCount
			),
			
			fn clean =
			(
				-- lights need to be in wrappers
				local lLightMtlTvps = getclassinstances VR灯光材质 astrackviewpick:true
				for lightMtlTvp in lLightMtlTvps do
				(
					local lightMtl = lightMtlTvp.anim
					local parent = lightMtlTvp.client
					local wrapperMtl = VR材质包裹器 generateGI:false basemtl:lightMtl
					
					if (classof (superclassof parent)) == node then
					(
						parent.mat = wrapperMtl
					)
					
					else if classof parent == multimaterial then
					(
						for nMat = 1 to parent.MaterialList.count do
						(
							if parent.MaterialList[nMat] == lightMtl then parent.MaterialList[nMat] = wrapperMtl
						)
					)
					
					else if classof parent == VR材质包裹器 then
					(
						parent.generateGI = false
					)
				)
			)
			
		);)(),
		
		(struct s( tName = "Vray材质 ClampTex 关闭",
			
			tTooltip = "Can kill renderings. Light calculation takes forever.",
			
			fn autocount =
			(
				local nCount = 0
				
				for mtl in getclassinstances VrayMtl where mtl.option_clampTextures != true do nCount += 1
				
				nCount
			),
			
			fn clean =
			(
				for mtl in getclassinstances VrayMtl where mtl.option_clampTextures != true do mtl.option_clampTextures = true
			)
			
		);)(),
		
		(struct s( tName = "Vay材质 折射/反射 细分 > 8",
			
			tTooltip = "Too high subdivs in vray materials can slow down your rendering.",
			
			fn autocount =
			(
				local nCount = 0
				
				local nMaxSubdivs = 8
				
				for mat in (getclassinstances VrayMtl)
					where mat.reflection_subdivs > nMaxSubdivs or mat.refraction_subdivs > nMaxSubdivs
					do nCount += 1
				
				nCount
			),
			
			fn clean =
			(
				local nMaxSubdivs = 8
				
				for mat in (getclassinstances VrayMtl) do
				(
					if mat.reflection_subdivs > nMaxSubdivs then mat.reflection_subdivs = nMaxSubdivs
					if mat.refraction_subdivs > nMaxSubdivs then mat.refraction_subdivs = nMaxSubdivs
				)
			)
			
		);)(),
		
		(struct s( tName = "Vay材质 折射/反射 细分 > 16",
			
			tTooltip = "Too high subdivs in vray materials can slow down your rendering.",
			
			fn autocount =
			(
				local nCount = 0
				
				local nMaxSubdivs = 16
				
				for mat in (getclassinstances VrayMtl)
					where mat.reflection_subdivs > nMaxSubdivs or mat.refraction_subdivs > nMaxSubdivs
					do nCount += 1
				
				nCount
			),
			
			fn clean =
			(
				local nMaxSubdivs = 16
				
				for mat in (getclassinstances VrayMtl) do
				(
					if mat.reflection_subdivs > nMaxSubdivs then mat.reflection_subdivs = nMaxSubdivs
					if mat.refraction_subdivs > nMaxSubdivs then mat.refraction_subdivs = nMaxSubdivs
				)
			)
			
		);)(),
			

		(struct s( tName = "Vay材质 折射/反射 细分 > 24",
			
			tTooltip = "Too high subdivs in vray materials can slow down your rendering.",
			
			fn autocount =
			(
				local nCount = 0
				
				local nMaxSubdivs = 24
				
				for mat in (getclassinstances VrayMtl)
					where mat.reflection_subdivs > nMaxSubdivs or mat.refraction_subdivs > nMaxSubdivs
					do nCount += 1
				
				nCount
			),
			
			fn clean =
			(
				local nMaxSubdivs = 24
				
				for mat in (getclassinstances VrayMtl) do
				(
					if mat.reflection_subdivs > nMaxSubdivs then mat.reflection_subdivs = nMaxSubdivs
					if mat.refraction_subdivs > nMaxSubdivs then mat.refraction_subdivs = nMaxSubdivs
				)
			)
			
		);)(),
			

		(struct s( tName = "Vay材质 折射/反射 细分 > 32",
			
			tTooltip = "Too high subdivs in vray materials can slow down your rendering.",
			
			fn autocount =
			(
				local nCount = 0
				
				local nMaxSubdivs = 32
				
				for mat in (getclassinstances VrayMtl)
					where mat.reflection_subdivs > nMaxSubdivs or mat.refraction_subdivs > nMaxSubdivs
					do nCount += 1
				
				nCount
			),

			fn clean =
			(
				local nMaxSubdivs = 32
				
				for mat in (getclassinstances VrayMtl) do
				(
					if mat.reflection_subdivs > nMaxSubdivs then mat.reflection_subdivs = nMaxSubdivs
					if mat.refraction_subdivs > nMaxSubdivs then mat.refraction_subdivs = nMaxSubdivs
				)
			)
			
		);)(),
			
			-- by Simon
		(struct s( tName = "纹理 过滤",
			
			tTooltip = "Filtering will be set to Pyramidal for all bitmaps and to None if the bitmap belongs to a leaf or model+model book",
			
			fn autocount =
			(
				local nCount = 0
				
				for curr_map in (getclassinstances bitmaptexture) do
				(
					if
						curr_map.filename != undefined and
						curr_map.filtering != 2 and
						(
							matchpattern (getfilenamefile curr_map.filename) pattern:"*leaf*" or
							matchpattern (curr_map.filename) pattern:"*model+model*maps_high*" or
							matchpattern (getfilenamefile curr_map.filename) pattern:"*flower*"
						)
					then nCount += 1
					else if(curr_map.filtering == 1) then
						nCount += 1
				)
				
				nCount
			),
			
			fn clean =
			(
				for curr_map in (getclassinstances bitmaptexture) do
				(
					-- auto-detect plants
					if
						curr_map.filename != undefined and
						(
							matchpattern (getfilenamefile curr_map.filename) pattern:"*leaf*" or
							matchpattern (curr_map.filename) pattern:"*model+model*maps_high*" or
							matchpattern (getfilenamefile curr_map.filename) pattern:"*flower*"
						)
					then curr_map.filtering = 2
					else curr_map.filtering = 0
				)
			)
			
		);)()
			-- /by Simon
		
	)
	
	function getTooltip task =
	(
		local t = task.tTooltip
		
		t = substituteString t "\\" ""
		t = substituteString t "\t" ""
		t = substituteString t "\n" ""
	)
	
	local tCode = ""
	tCode += "global cCleanerRollout = rollout cCleanerRollout \"Cleaner_ZX汉化_场景清理器 v6\" ("
	tCode += "label cLabCount \"计数:\" width:160 height:24 pos:[200,7];"
	tCode += "label cLabSelect \"从场景中选择:\" width:160 height:24 pos:[265,7];"
		
		-- vertical control position
		local nPosY = 5
		
		-- add tasks
		for nTask = 1 to lTasks_4648134686.count do
		(
			local task = lTasks_4648134686[nTask]
			local tTask = nTask as string
			
			-- groups
			if matchpattern task.tName pattern:"--*--*" then
			(
				local tGroup = (filterstring task.tName "--")[1]
				task.tName = (filterstring task.tName "--")[2]
				
				tCode += "label cLab_group"+ nPosY as string +" \""+ tGroup +":\" width:100 height:24 pos:[10,"+ (nPosY+2) as string +"];"
				nPosY += 24
			)
			
			-- clean
			tCode += "button cBut_clean"+ tTask +" \""+ task.tName +"\" tooltip:\""+ getTooltip task +"\" width:160 height:24 pos:[5,"+ nPosY as string +"];"
			tCode += "on cBut_clean"+ tTask +" pressed do ("
			tCode += "lTasks_4648134686["+ tTask +"].clean();"
			tCode += "cCleanerRollout.cLab"+ tTask +".text = lTasks_4648134686["+ tTask +"].autocount() as string;"
			tCode += ");"
			
			if try (task.usercount; true) catch false then
			(
				-- usercount
				tCode += "button cBut_count"+ tTask +" \"计数\" tooltip:\"This tasks takes longer to count, so you have to start the count manually.\" width:50 height:24 pos:[189,"+ nPosY as string +"];"
				tCode += "on cBut_count"+ tTask +" pressed do ("
				tCode += "cCleanerRollout.cBut_count"+ tTask +".text = lTasks_4648134686["+ tTask +"].usercount() as string;"
				tCode += ");"
			)
			else
			(
				-- autocount
				tCode += "label cLab"+ tTask +" \"计数..\" pos:[190,"+ (nPosY+5) as string +"];"
			)
			
			-- objects
			if try (task.selectObjects; true) catch false then
			(
				tCode += "button cBut_objects"+ tTask +" \"选对象\" tooltip:\"select objects (opens groups)\" width:50 height:24 pos:[260,"+ nPosY as string +"];"
				tCode += "on cBut_objects"+ tTask +" pressed do lTasks_4648134686["+ tTask +"].selectObjects();"
			)
			
			-- materials
			if try (task.selectMaterials; true) catch false then
			(
				tCode += "button cBut_materials"+ tTask +" \"选材质\" tooltip:\"select materials (in materialeditor)\" width:50 height:24 pos:[315,"+ nPosY as string +"];"
				tCode += "on cBut_materials"+ tTask +" pressed do lTasks_4648134686["+ tTask +"].selectMaterials();"
			)
			
			nPosY += 28
		)
		
		-- on rollout open
		tCode += "on cCleanerRollout open do ("
		for nTask = 1 to lTasks_4648134686.count do
		(
			if try (lTasks_4648134686[nTask].usercount; false) catch true then
			(
				local tTask = nTask as string
				tCode += "cLab"+ tTask +".text = lTasks_4648134686["+ tTask +"].autocount() as string;"
			)
		)
		tCode += ");"
		
	tCode += ")"
	local cCleanerRollout = execute tCode
	createDialog cCleanerRollout 370 (nPosY+2)
)