Class extends _Form_Controller

property _commandLine : Text

Class constructor()
	
	Super:C1705()
	
Function get commandLine()->$commandLine : Text
	
	$commandLine:=This:C1470._commandLine
	
	//MARK:-polymorphism
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is an instance of the view
	//This is an instance of the controller
	
	If (Form:C1466#Null:C1517)
		
		This:C1470._onResponseCount+=1
		
		This:C1470._commandLine:=This:C1470._worker.commandLine
		
		If (This:C1470.complete)
			//end of the queue
		End if 
		
	End if 
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is an instance of the view
	//This is an instance of the controller
	
	If (Form:C1466#Null:C1517)
		
		This:C1470._onTerminateCount+=1
		
		If (This:C1470.complete)
			//end of the queue
			OBJECT SET ENABLED:C1123(*; This:C1470._stopButtonName; False:C215)
			OBJECT SET ENABLED:C1123(*; This:C1470._startButtonName; True:C214)
		End if 
		
	End if 