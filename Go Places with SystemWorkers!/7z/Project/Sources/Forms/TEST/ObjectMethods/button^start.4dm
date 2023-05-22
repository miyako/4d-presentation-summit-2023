$event:=FORM Event:C1606

If ($event.code=On Clicked:K2:4)
	
	$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)
	
	$tar:=Folder:C1567(fk desktop folder:K87:19).file($app.fullName+".tar")
	
	If ($tar.exists)
		$tar.delete()  //otherwise the new object may be added to an existing archive
	End if 
	
	Form:C1466.controller.start()
	Form:C1466.add($tar; New collection:C1472($app))
	
End if 