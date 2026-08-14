 myfilename="_"
 mapfiles=#()

	
fn get_scene_materials = 
	(
	a = #()
	for i in $* do
		(
		if i.material != undefined then
			(
			if (finditem a i.material) == 0 then append a i.material
			)
		)

	return a
	)


fn cb_change_bitmaps onwhat  = 
	(
	if onwhat.numsubs != 0 then
		(
		for i = 1 to onwhat.numsubs do
			(
			if onwhat[i] != undefined then
				(
				if iskindof onwhat[i] bitmaptexture == true then
					(
					onwhat[i].filename = ("\\" +  filenameFromPath(onwhat[i].filename))
					)
				)
				if onwhat[i] != undefined then cb_change_bitmaps onwhat[i] 
			)
		)
	)



-----add map's filename to Array mapfiles---

fn addmap mapfile =

(

local mapfileN=mapfile as name

local index=finditem mapfiles mapfileN

if index == 0 do append mapfiles mapfileN

)

-----copy vrmesh to new path----
fn directproxy myproxy newpath =
		(
			
		    local oldfilename=myproxy
			myproxy=(myfilename+"\\"+filenameFromPath myproxy )
			 copyFile oldfilename myproxy
			 print (myproxy as string)
		)


------rollout-----

rollout readyforrender "ready for render" width:240 height:136
(
button btn1 "获取路径" pos:[8,8] width:96 height:25
label lbl1 "" pos:[8,39] width:216 height:41
button btn2 "执行" pos:[8,88] width:216 height:25

on btn1 pressed do
	(
		 myfilename = getSavePath()
		if substring myfilename (myfilename.count) 1 =="\\"  then 
		(
			messagebox "请输入路径"
			btn2.enabled=false
		)
		else
		(
			btn2.enabled=true
		)
		try(lbl1.caption = myfilename) catch(false)
	)

on btn2 pressed do
(
newproxy_array=#()
myproxy_array=#()
---------------------------------------------------------------
-----find maps-------------
enumeratefiles addmap 

sort mapfiles
-------------------------------------------------------------------
-----copy bitmaps to new path-----
for mapfile in mapfiles do 
(
newmapfile = (myfilename + "\\" + filenameFromPath(mapfile))
copyfile mapfile newmapfile
print (mapfile as string)
)
-------------------------------------------------------------
------add vrmesh's path to array-----------
myproxy_array=  for mmm in mapfiles where matchPattern mmm pattern:"*.vrmesh"  collect mmm

for f in myproxy_array do
(
eee=filenameFromPath f

files= mapPaths.getFullFilePath eee 
 
append newproxy_array files
)


for j =1 to newproxy_array.count do 
		(      
			directproxy newproxy_array[j] myfilename 
			
)

----change bitmap path------------------
mat_array = get_scene_materials()

for k=1 to mat_array.count do
(
cb_change_bitmaps mat_array[k]
)
----change vrmesh path----
myproxy_arrayX =for i in geometry where classof i == VRayProxy collect i
		for l =1 to myproxy_arrayX.count do 
		( 
		myproxy_arrayX[l].filename=("\\" + filenameFromPath(myproxy_arrayX[l].filename))
		)
-------------------------------------------------------------------
-------------change pts path-------------------------------------------		
fn moood obj=(
mod_array=#()
mod_array=obj.modifiers 
if mod_array.count != 0 then 
( for h=1 to mod_array.count do
( if classof  mod_array[h] == Point_Cache then 
(
lll=true
 return lll
 ) 
)
---for
)
---if
lll=false
return lll
)
------fn collect pts ------
mypts_array=for ff in geometry where moood ff collect ff
for gg=1 to mypts_array.count do
(
namepts= mypts_array[gg].modifiers[#point_cache].filename
mypts_array[gg].modifiers[#point_cache].filename = ("\\" + filenameFromPath(namepts))
)



----save max file---
maxfile=maxFileName
kkk=getMAXSaveFileName filename:(myfilename+"\\" + maxfile)
saveMaxFile kkk
messagebox "ok"
)
)
createdialog readyforrender
