Class extends _CLI

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705("csv2json"; $controller)
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function execute($option : Variant)->$this : cs:C1710.Csv2Json
	
	$this:=This:C1470
	
	var $commands; $options : Collection
	$commands:=New collection:C1472
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=New collection:C1472($option)
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
	End case 
	
	var $csvFile : 4D:C1709.File
	
	For each ($option; $options)
		
		If (OB Instance of:C1731($option.src; 4D:C1709.File))
/*
resolve filesystem path
*/
			$csvFile:=File:C1566($option.src.platformPath; fk platform path:K87:2)
			
			$command:=This:C1470.escape(This:C1470.executablePath)
/*
-pretty: generate pretty JSON
-separator: comma or semicolon
*/
			If (Bool:C1537($option.pretty))
				$command:=$command+" -pretty"
			End if 
			Case of 
				: (Value type:C1509($option.separator)#Is text:K8:3)
				: ($option.separator="semicolon")
					$command:=$command+" -separator semicolon"
			End case 
			$command:=$command+" "+This:C1470.quote($csvFile.path)
			$commands.push($command)
		End if 
	End for each 
	
	This:C1470.controller.execute($commands)