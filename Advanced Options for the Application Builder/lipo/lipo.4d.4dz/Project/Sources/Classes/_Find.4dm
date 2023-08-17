Class extends _CLI

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705("find"; $controller)
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function findExecutables($option : Variant)->$this : cs:C1710._Find
	
	$this:=This:C1470
	
	var $commands; $options : Collection
	$commands:=New collection:C1472
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=New collection:C1472($option)
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
	End case 
	
	For each ($option; $options)
		
		If (OB Instance of:C1731($option; 4D:C1709.Folder))
/*
resolve filesystem path
*/
			$input:=Folder:C1567($option.platformPath; fk platform path:K87:2)
			
			$command:=This:C1470.escape(This:C1470.executablePath)
			$command:=$command+" "+This:C1470.escape($input.path)+" -type f -perm +ugo+x -print"
			
			$commands.push($command)
		End if 
	End for each 
	
	This:C1470.controller._clear()
	
	This:C1470.controller.execute($commands)