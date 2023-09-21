property IMAGES : 4D:C1709.Folder  //the root images folder
property controlAccentColor : Text

Class constructor
	
	var $colors : Object
	$colors:=Get control color
	
	This:C1470._controlAccentColor:="rgb("+String:C10($colors.red*100; "&xml")+"%"+", "+String:C10($colors.green*100; "&xml")+"%"+", "+String:C10($colors.blue*100; "&xml")+"%"+")"
	This:C1470._IMAGES:=Folder:C1567("/RESOURCES/Images/src/")
	
	This:C1470._cacheFolder:=Folder:C1567("/LOGS/")
	
Function get cacheFolder()->$cacheFolder : 4D:C1709.Folder
	
	This:C1470._cacheFolder.create()
	$cacheFolder:=This:C1470._cacheFolder
	
Function get applicationName()->$applicationName : Text
	
	$applicationName:=This:C1470._applicationName
	
Function get controlAccentColor()->$controlAccentColor : Text
	
	$controlAccentColor:=This:C1470._controlAccentColor
	
Function get IMAGES()->$IMAGES : 4D:C1709.Folder
	
	$IMAGES:=This:C1470._IMAGES
	
Function _export($image : Picture; $name : Text; $scale : Integer)
	
	TRANSFORM PICTURE:C988($image; Reset:K61:1)
	
	var $path : Text
	
	Case of 
		: ($scale<2)
			$path:=This:C1470.cacheFolder.file($name+".png").platformPath
		Else 
			TRANSFORM PICTURE:C988($image; Scale:K61:2; $scale; $scale)
			$path:=This:C1470.cacheFolder.file($name+"@"+String:C10($scale)+"x.png").platformPath
	End case 
	
	WRITE PICTURE FILE:C680($path; $image)
	
Function exportAll()
	
	var $file : 4D:C1709.File
	
	For each ($file; This:C1470.IMAGES.files(fk ignore invisible:K87:22))
		This:C1470.exportOne($file.name)
	End for each 
	
Function exportOne($name : Text)
	
	var $image : Picture
	
	$image:=This:C1470.getColoredButton($name)
	
	This:C1470._export($image; $name; 1)
	This:C1470._export($image; $name; 2)
	This:C1470._export($image; $name; 3)
	
Function getColoredImage($name : Text)->$SVG : Text
	
	$SVG:=Replace string:C233(This:C1470.getRawImage($name); "accent-color"; This:C1470.controlAccentColor; *)
	
Function getColoredButton($name : Text)->$image : Picture
	
	$SVG:=This:C1470.getColoredImage($name)
	
	var $blob : 4D:C1709.Blob
	
	CONVERT FROM TEXT:C1011($SVG; "utf-8"; $blob)
	
	BLOB TO PICTURE:C682($blob; $image)
	
Function getRawImage($name : Text)->$SVG : Text
	
	var $file : 4D:C1709.File
	
	$file:=This:C1470.IMAGES.file($name+".svg")
	
	If ($file.exists)
		$SVG:=$file.getText("utf-8-no-bom"; Document with CR:K24:21)
	End if 
	