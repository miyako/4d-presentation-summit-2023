//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($RuntimeFolder : 4D:C1709.Folder; $signal : 4D:C1709.Signal)

Case of 
	: (Count parameters:C259=1)
		
		$signal:=New signal:C1641
		
		CALL WORKER:C1389("signApp"; Current method name:C684; $RuntimeFolder; $signal)
		
		$signal.wait()
		
	: (Count parameters:C259=2)
		
		var $SignApp : cs:C1710.SignApp
		
		$SignApp:=cs:C1710.SignApp.new(cs:C1710.SignApp_Worker_Controller; $signal)
		
		$SignApp.signAsync($RuntimeFolder)
		
End case 