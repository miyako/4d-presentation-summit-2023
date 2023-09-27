//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	BRING TO FRONT:C326(New process:C317(Current method name:C684; 0; Current method name:C684; New object:C1471))
	
Else 
	
	TRACE:C157
	
	$temp:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2)
	
	$a:=$temp.file("a.txt")
	$b:=$temp.file("b.txt")
	$c:=$temp.file("c.txt")
	
	$files:=[$a; $b; $c]
	
	For each ($file; $files)
		$file.setText($file.fullName)
	End for each 
	
	$z:=Folder:C1567(fk desktop folder:K87:19).file("test.7z")
	$d:=Folder:C1567(fk desktop folder:K87:19)
	
	$zipper:=cs:C1710.SevenZip.new()
	
	$zipper.add($z; New collection:C1472($a; $b; $c))
	
	//this will fail in a new process because the process dies before the worker is finished
	
End if 