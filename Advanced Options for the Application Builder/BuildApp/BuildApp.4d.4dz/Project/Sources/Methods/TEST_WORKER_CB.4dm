//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(Current method name:C684; Current method name:C684; New object:C1471)
	
Else 
	
	$desktopFolder:=Folder:C1567(fk desktop folder:K87:19)
	
	$src:=$desktopFolder.file("hello-world")
	$dst:=$desktopFolder.file("hello-world-intel")
	
	$one:=New object:C1471("src"; $src; "dst"; $dst; "arch"; "x86_64")
	
	$dst:=$desktopFolder.file("hello-world-silicon")
	
	$two:=New object:C1471("src"; $src; "dst"; $dst; "arch"; "arm64")
	
	$lipo:=cs:C1710.Lipo.new(cs:C1710._Worker_Controller)  //the controller will intercept callbacks
	
	$lipo.thin($one).thin($two)  //chaining syntax
	
End if 