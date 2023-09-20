//%attributes = {"invisible":true}
/*

this method is designed to be executed in utility mode
https://developer.4d.com/docs/Admin/cli/#tool4d

*/

If (Get application info:C1599.headless)
	
	var $CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=cs:C1710.BuildApp_CLI.new()
	
	$CLI.logo().version()
	
	ON ERR CALL:C155(Formula:C1597(generic_error_handler).source)
	
	$CLI.LF()
	
	If (False:C215)
		$CLI\
			.print(Parse formula:C1576(":C489"); "bold;underline")\
			.print(": ")\
			.print(File:C1566(Structure file:C489; fk platform path:K87:2).path)\
			.LF()
	End if 
	
	var $userParamValue : Text
	$param:=Get database parameter:C643(User param value:K37:94; $userParamValue)
	
	Case of 
		: ($userParamValue="")
			$CLI.print("--user-param is missing!"; "red;bold").LF()
		Else 
			
			var $buildProject; $compileProject : 4D:C1709.File
			
			$paths:=Split string:C1554($userParamValue; ","; sk trim spaces:K86:2 | sk ignore empty strings:K86:1)
			
			For each ($path; $paths)
				
				Case of 
					: (New collection:C1472(".xml"; ".4DSettings").includes(Path to object:C1547($path).extension))
						$buildProject:=File:C1566($path; fk posix path:K87:1)
						$buildProject:=$buildProject.exists ? $buildProject : File:C1566($path; fk platform path:K87:2)
					: (New collection:C1472(".json"; ".4DProject").includes(Path to object:C1547($path).extension))
						$compileProject:=File:C1566($path; fk posix path:K87:1)
						$compileProject:=$compileProject.exists ? $compileProject : File:C1566($path; fk platform path:K87:2)
				End case 
			End for each 
			
			If ($compileProject#Null:C1517)
				If ($CLI.compile($compileProject))
					$CLI.build($buildProject; $compileProject)
				End if 
			End if 
			
	End case 
	
	ON ERR CALL:C155("")
	
End if 