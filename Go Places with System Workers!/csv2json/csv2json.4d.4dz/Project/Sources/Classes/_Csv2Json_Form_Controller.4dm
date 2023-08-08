Class extends _Form_Controller

property _csvInputName; _jsonInputName : Text
property _src; _dst : 4D:C1709.File

Class constructor()
	
	Super:C1705()
	
Function get dst()->$dst : 4D:C1709.File
	
	$dst:=This:C1470._dst
	
Function get src()->$dst : 4D:C1709.File
	
	$dst:=This:C1470._src
	
Function setInput()->$src : 4D:C1709.File
	
	var $csv : Text
	
	If (OBJECT Get name:C1087(Object with focus:K67:3)=This:C1470._csvInputName)
		$csv:=Get edited text:C655
	Else 
		$csv:=OBJECT Get value:C1743(This:C1470._csvInputName)
	End if 
	
	var $tempFolder : 4D:C1709.Folder
	$tempFolder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2)
	
	This:C1470._src:=$tempFolder.file("test.csv")
	This:C1470._dst:=$tempFolder.file("test.json")
	
	This:C1470._src.setText($csv; "utf-8"; Document with LF:K24:22)
	This:C1470._dst.delete()
	
	$src:=This:C1470._src
	
	//MARK:-polymorphism
	
Function bind($options : Object)
	
	If ($options#Null:C1517)
		var $option : Text
		For each ($option; $options)
			Case of 
				: ($option="startButton") && (Value type:C1509($options[$option])=Is text:K8:3)
					This:C1470._startButtonName:=$options[$option]
				: ($option="stopButton") && (Value type:C1509($options[$option])=Is text:K8:3)
					This:C1470._stopButtonName:=$options[$option]
				: ($option="csvInput") && (Value type:C1509($options[$option])=Is text:K8:3)
					This:C1470._csvInputName:=$options[$option]
				: ($option="jsonInput") && (Value type:C1509($options[$option])=Is text:K8:3)
					This:C1470._jsonInputName:=$options[$option]
			End case 
		End for each 
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
			
			If (OB Instance of:C1731(This:C1470.dst; 4D:C1709.File))
				$json:=This:C1470.dst.getText()
				OBJECT SET VALUE:C1742(This:C1470._jsonInputName; $json)
			End if 
			
		End if 
		
	End if 