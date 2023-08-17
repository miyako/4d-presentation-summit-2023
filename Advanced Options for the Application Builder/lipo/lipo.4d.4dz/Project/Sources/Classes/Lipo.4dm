Class extends _CLI

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705("lipo"; $controller)
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function thin($option : Variant)->$this : cs:C1710.Lipo
	
	$this:=This:C1470
	
	var $commands; $options : Collection
	$commands:=New collection:C1472
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=New collection:C1472($option)
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
	End case 
	
	var $src; $dst : 4D:C1709.File
	
	For each ($option; $options)
		
		If (OB Instance of:C1731($option.src; 4D:C1709.File)) && (OB Instance of:C1731($option.dst; 4D:C1709.File))
/*
resolve filesystem path
*/
			$input:=File:C1566($option.src.platformPath; fk platform path:K87:2)
			$output:=File:C1566($option.dst.platformPath; fk platform path:K87:2)
			
			$command:=This:C1470.escape(This:C1470.executablePath)
			$command:=$command+" "+This:C1470.escape($input.path)
			Case of 
				: (Value type:C1509($option.arch)=Is text:K8:3)
					$command:=$command+" -thin "+This:C1470.escape($option.arch)
				Else 
					$command:=$command+" -thin arm64"
			End case 
			$command:=$command+" -output "+This:C1470.escape($output.path)
			$commands.push($command)
		End if 
	End for each 
	
	This:C1470.controller.execute($commands)