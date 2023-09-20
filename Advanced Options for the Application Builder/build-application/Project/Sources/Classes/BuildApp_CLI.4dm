Class extends CLI

Function _printTask($task : Text)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$CLI.print($path; "bold").print("…").LF()
	
Function _printList($list : Collection)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$CLI.print($list.join(","); "39").LF()
	
Function _printPath($path : Object)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	If (OB Instance of:C1731($path; 4D:C1709.File) || OB Instance of:C1731($path; 4D:C1709.Folder))
		$CLI.print($path.path; "244").LF()
	End if 
	
Function _printStatus($success : Boolean)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	If ($success)
		$CLI.print("success"; "82;bold").LF()
	Else 
		$CLI.print("failure"; "196;bold").LF()
	End if 
	
Function logo()->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$logo:=File:C1566("/RESOURCES/logo.txt").getText("us-ascii"; Document with CR:K24:21)
	$lines:=Split string:C1554($logo; "\r")
	
	For each ($line; $lines)
		$CLI.print($line; "117;18;bold").LF()
	End for each 
	
Function version()->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	var $build : Integer
	$version:=Application version:C493($build)
	
	$code:=Split string:C1554($version; "")
	$name:=(($code[2]="0") ? ("v"+$code[0]+$code[1]+"."+$code[3]) : ("v"+$code[0]+$code[1]+" R"+$code[2]))
	
	$version:=New collection:C1472($name; $build).join(".")
	
	$CLI.print($version; "231;bold").LF()
	
Function compile($compileProject : 4D:C1709.File)->$success : Boolean
	
	$CLI:=This:C1470
	
	This:C1470._printTask("Compile project")
	
	$options:=New object:C1471
	$options.generateSymbols:=True:C214
	
	$status:=Compile project:C1760($options)
	
	This:C1470._printStatus($status.success)
	
	For each ($error; $status.errors)
		If ($error.isError)
			$CLI.print($error.message; "177;bold")
		Else 
			$CLI.print($error.message; "166;bold")
		End if 
		$CLI.print("…").print($error.code.path+"#"+String:C10($error.lineInFile); "244").LF()
	End for each 
	
Function build($buildProject : 4D:C1709.File; $compileProject : 4D:C1709.File)->$success : Boolean
	
	$CLI:=This:C1470
	
	var $BuildApp : cs:C1710.BuildApp
	
	$BuildApp:=cs:C1710.BuildApp.new($buildProject)
	
	$BuildApp.findLicenses()
	
	This:C1470._printList(New collection:C1472("a"; "b"; "c"))
	
	This:C1470._printStatus(True:C214)
	This:C1470._printStatus(False:C215)
	This:C1470._printPath(File:C1566(Data file:C490; fk platform path:K87:2))
	This:C1470._printTask("Copy file")