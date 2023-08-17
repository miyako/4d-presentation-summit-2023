Class extends _CLI_Controller

property _startButtonName; _stopButtonName : Text
property _stdErr; _stdOut : Text
property _stdErrBuffer; _stdOutBuffer : Text
property _onDataCount; _onDataErrorCount; _onResponseCount; _onTerminateCount : Integer

Class constructor()
	
	Super:C1705()
	
Function get stdOut()->$stdOut : Text
	
	$stdOut:=This:C1470._stdOut
	
Function get stdErr()->$stdErr : Text
	
	$stdErr:=This:C1470._stdErr
	
Function get onDataCount()->$onDataCount : Integer
	
	$onDataCount:=This:C1470._onDataCount
	
Function get onDataErrorCount()->$onDataErrorCount : Integer
	
	$onDataErrorCount:=This:C1470._onDataErrorCount
	
Function get onResponseCount()->$onResponseCount : Integer
	
	$onResponseCount:=This:C1470._onResponseCount
	
Function get onTerminateCount()->$onTerminateCount : Integer
	
	$onTerminateCount:=This:C1470._onTerminateCount
	
	//MARK:-public methods
	
Function bind($options : Object)
	
	If ($options#Null:C1517)
		var $option : Text
		For each ($option; $options)
			Case of 
				: ($option="startButton") && (Value type:C1509($options[$option])=Is text:K8:3)
					This:C1470._startButtonName:=$options[$option]
				: ($option="stopButton") && (Value type:C1509($options[$option])=Is text:K8:3)
					This:C1470._stopButtonName:=$options[$option]
			End case 
		End for each 
	End if 
	
Function start()
	
	This:C1470._clear()
	
	OBJECT SET ENABLED:C1123(*; This:C1470._startButtonName; False:C215)
	OBJECT SET ENABLED:C1123(*; This:C1470._stopButtonName; True:C214)
	
Function stop()
	
	This:C1470._clear()
	
	OBJECT SET ENABLED:C1123(*; This:C1470._startButtonName; True:C214)
	OBJECT SET ENABLED:C1123(*; This:C1470._stopButtonName; False:C215)
	
	//MARK:-private methods
	
Function _clear()
	
	This:C1470._onDataCount:=0
	This:C1470._onDataErrorCount:=0
	This:C1470._onResponseCount:=0
	This:C1470._onTerminateCount:=0
	
	This:C1470._stdErr:=""
	This:C1470._stdOut:=""
	This:C1470._stdErrBuffer:=""
	This:C1470._stdOutBuffer:=""
	
	//MARK:-polymorphism
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is an instance of the view
	//This is an instance of the controller
	
	If (Form:C1466#Null:C1517)
		
		Case of 
			: ($worker.dataType="text")
				
				This:C1470._stdErrBuffer+=$params.data
				
			: ($worker.dataType="blob")
				
				This:C1470._stdErrBuffer+=Convert to text:C1012($params.data; This:C1470.encoding)
				
		End case 
		
		$data:=This:C1470._stdErrBuffer
		
		This:C1470._stdErr+=Split string:C1554($data; Form:C1466.EOL; sk ignore empty strings:K86:1 | sk trim spaces:K86:2).join("\r")
		
		This:C1470._onDataErrorCount+=1
		
	End if 
	
Function onData($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is an instance of the view
	//This is an instance of the controller
	
	If (Form:C1466#Null:C1517)
		
		Case of 
			: ($worker.dataType="text")
				
				This:C1470._stdOutBuffer+=$params.data
				
			: ($worker.dataType="blob")
				
				This:C1470._stdOutBuffer+=Convert to text:C1012($params.data; This:C1470.encoding)
				
		End case 
		
		$data:=This:C1470._stdOutBuffer
		
		This:C1470._stdOut+=Split string:C1554($data; Form:C1466.EOL; sk ignore empty strings:K86:1 | sk trim spaces:K86:2).join("\r")
		
		This:C1470._onDataCount+=1
		
	End if 
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is an instance of the view
	//This is an instance of the controller
	
	If (Form:C1466#Null:C1517)
		
		This:C1470._onResponseCount+=1
		
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