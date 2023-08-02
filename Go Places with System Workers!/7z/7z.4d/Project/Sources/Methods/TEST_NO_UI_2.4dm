//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(Current method name:C684; Current method name:C684; New object:C1471)
	
Else 
	
	TRACE:C157
	
	If (Is Windows:C1573)
		$app:=File:C1566(Application file:C491; fk platform path:K87:2).parent
	Else 
		$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	End if 
	
	$tar:=Folder:C1567(fk desktop folder:K87:19).file($app.fullName+".tar")
	
	$zipper:=cs:C1710.SevenZip.new(cs:C1710._Basic_Controller)
	
	$zipper.add($tar; $app)
	
	$zip:=Folder:C1567(fk desktop folder:K87:19).file($app.fullName+".7z")
	
	$zipper.add($zip; $tar)
	
	//a subclass of cs._CLI_Controller can be used to intercept events
	
End if 