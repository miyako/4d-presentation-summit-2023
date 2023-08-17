Class extends _Worker_Controller

property _stdErrBuffer; _stdOutBuffer : Text
property _instance : Object
property _parameters : Collection

Class constructor
	
	Super:C1705()
	
	//MARK:-public methods
	
Function bind($instance : cs:C1710._CLI)
	
	If (OB Instance of:C1731($instance; cs:C1710._CLI))
		This:C1470._instance:=$instance
		This:C1470._parameters:=Copy parameters:C1790(2)
	End if 
	
	//MARK:-private methods
	
Function _clear()
	
	This:C1470._stdErrBuffer:=""
	This:C1470._stdOutBuffer:=""
	
	//MARK:-polymorphism
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	Case of 
		: ($worker.dataType="text")
			
			This:C1470._stdErrBuffer+=$params.data
			
		: ($worker.dataType="blob")
			
			This:C1470._stdErrBuffer+=Convert to text:C1012($params.data; This:C1470.encoding)
			
	End case 
	
Function onData($worker : 4D:C1709.SystemWorker; $params : Object)
	
	Case of 
		: ($worker.dataType="text")
			
			This:C1470._stdOutBuffer+=$params.data
			
		: ($worker.dataType="blob")
			
			This:C1470._stdOutBuffer+=Convert to text:C1012($params.data; This:C1470.encoding)
			
	End case 
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
	var $paths; $messages : Collection
	
	$paths:=Split string:C1554(This:C1470._stdOutBuffer; "\n"; sk ignore empty strings:K86:1 | sk trim spaces:K86:2)
	$messages:=Split string:C1554(This:C1470._stdErrBuffer; "\n"; sk ignore empty strings:K86:1 | sk trim spaces:K86:2)
	
	If (This:C1470.complete)
		If (OB Instance of:C1731(This:C1470._instance.onResponse; 4D:C1709.Function))
			This:C1470._instance.onResponse($paths; $messages; This:C1470._parameters)
		End if 
	End if 
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	
	If (This:C1470.complete)
		If (OB Instance of:C1731(This:C1470._instance.onTerminate; 4D:C1709.Function))
			This:C1470._instance.onTerminate(This:C1470._parameters)
		End if 
	End if 