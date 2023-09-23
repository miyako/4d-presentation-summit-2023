//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(Current method name:C684; Current method name:C684; New object:C1471)
	
Else 
	
	$desktopFolder:=Folder:C1567(fk desktop folder:K87:19)
	
	$src:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	$dst:=$desktopFolder.folder("x86_64")
	
	$one:=New object:C1471("src"; $src; "dst"; $dst; "arch"; "x86_64")
	
	$dst:=$desktopFolder.folder("arm64")
	
	$two:=New object:C1471("src"; $src; "dst"; $dst; "arch"; "arm64")
	
	$lipo:=cs:C1710.Lipo.new()
	
	$lipo.thin(New collection:C1472($one; $two))
	
End if 