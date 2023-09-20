Class extends CLI

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
	
	$CLI.print("Compile"; "bold").print(": ")
	
	$options:=New object:C1471
	$options.generateSymbols:=True:C214
	
	$status:=Compile project:C1760($options)
	
	$success:=$status.success
	
	If ($success)
		$CLI.print("success"; "green;bold").LF()
	Else 
		$CLI.print("failure"; "red;bold").LF()
	End if 
	
	$CLI.print(" "*Length:C16("Compile")).print("  ").print($compileProject.path; "240").LF()
	
	If (False:C215)
		
		For each ($error; $status.errors)
			$CLI.print("error"; "bold").print(".isError: ")
			If ($error.isError)
				$CLI.print(String:C10($error.isError); "red;bold").LF()
			Else 
				$CLI.print(String:C10($error.isError); "yellow;bold").LF()
			End if 
			$CLI.print("     "; "bold").print(".message: ").print($error.message).LF()
			$CLI.print("     "; "line").print(".line: ").print(String:C10($error.line)).LF()
			$CLI.print("     "; "lineInFile").print(".lineInFile: ").print(String:C10($error.lineInFile)).LF()
			$CLI.print("     "; "bold").print(".code.type: ").print($error.code.type).LF()
			$CLI.print("     "; "bold").print(".code.path: ").print($error.code.path).LF()
		End for each 
		
	End if 
	
Function build($buildProject : 4D:C1709.File; $compileProject : 4D:C1709.File)->$success : Boolean
	
	$CLI:=This:C1470
	
	var $BuildApp : cs:C1710.BuildApp
	
	$BuildApp:=cs:C1710.BuildApp.new($buildProject)
	
	$BuildApp.findLicenses().buildApplication($compileProject)