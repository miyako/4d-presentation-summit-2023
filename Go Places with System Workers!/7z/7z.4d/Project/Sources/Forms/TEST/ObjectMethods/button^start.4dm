$event:=FORM Event:C1606

If ($event.code=On Clicked:K2:4)
	
	If (Is Windows:C1573)
		$app:=File:C1566(Application file:C491; fk platform path:K87:2).parent
	Else 
		$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	End if 
	
	$tar:=Folder:C1567(fk desktop folder:K87:19).file($app.fullName+".tar")
	
	If ($tar.exists)
		$tar.delete()  //otherwise the new object may be added to an existing archive
	End if 
	
	$zip:=Folder:C1567(fk desktop folder:K87:19).file($app.fullName+".7z")
	
	Form:C1466.controller.start()
	Form:C1466.add($tar; $app).add($zip; $tar)
	
End if 