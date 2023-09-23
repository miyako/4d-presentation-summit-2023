//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(Current method name:C684; Current method name:C684; New object:C1471)
	
Else 
	
	$desktopFolder:=Folder:C1567(fk desktop folder:K87:19)
	$resourcesFolder:=Folder:C1567(fk resources folder:K87:11).folder("mac")
	
	$src:=New collection:C1472
	
	For each ($file; $resourcesFolder.files(fk ignore invisible:K87:22))
		If (Match regex:C1019("icon_\\d+x\\d+(?:@\\dx)?"; $file.name; 1))
			$src.push($file)
		End if 
	End for each 
	
	$PROJECT:=File:C1566(Structure file:C489; fk platform path:K87:2).name
	
	$dst:=$desktopFolder.file($PROJECT+".icns")
	
	$one:=New object:C1471("src"; $src; "dst"; $dst)
	
	$iconutil:=cs:C1710.Iconutil.new()
	
	$iconutil.convert(New collection:C1472($one))
	
End if 