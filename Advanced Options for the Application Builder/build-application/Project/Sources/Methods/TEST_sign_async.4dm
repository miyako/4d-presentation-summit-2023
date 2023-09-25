//%attributes = {"invisible":true}
#DECLARE($signal : 4D:C1709.Signal)

If (Count parameters:C259=0)
	
	$signal:=New signal:C1641
	
	CALL WORKER:C1389("signApp"; Current method name:C684; $signal)
	
	$signal.wait()
	
Else 
	
	var $SignApp : cs:C1710.SignApp
	
	$application:=Folder:C1567("Macintosh HD:Users:miyako:Desktop:Final Application:TEST.app"; fk platform path:K87:2)
	$SignApp:=cs:C1710.SignApp.new(cs:C1710.SignApp_Worker_Controller; $signal)
	
	$SignApp.signAsync(Null:C1517; $application)
	
End if 