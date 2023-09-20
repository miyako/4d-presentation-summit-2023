Class extends CLI

Function _printTask($task : Text)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$CLI.print($task; "bold").print("…")
	
Function _printItem($item : Text)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$CLI.print($item; "39").LF()
	
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
	
	$CLI._printTask("Compile project")
	
	$options:=New object:C1471
	$options.generateSymbols:=True:C214
	
	$status:=Compile project:C1760($options)
	
	$success:=$status.success
	
	$CLI._printStatus($success)
	
	For each ($error; $status.errors)
		If ($error.isError)
			$CLI.print($error.message; "177;bold")
		Else 
			$CLI.print($error.message; "166;bold")
		End if 
		$CLI.print("…").print($error.code.path+"#"+String:C10($error.lineInFile); "244").LF()
	End for each 
	
Function _getVersioning($BuildApp : cs:C1710.BuildApp; $key : Text)->$value : Text
	
	$value:="com.4d"
	
	If ($BuildApp.Versioning.Common["Common"+$key]#Null:C1517)
		If ($BuildApp.Versioning.Common["Common"+$key]#"")
			$value:=$BuildApp.Versioning.Common["Common"+$key]
		End if 
	End if 
	
Function build($buildProject : 4D:C1709.File; $compileProject : 4D:C1709.File)->$success : Boolean
	
	$CLI:=This:C1470
	
	var $BuildApp : cs:C1710.BuildApp
	
	$BuildApp:=cs:C1710.BuildApp.new($buildProject)
	
	$BuildApp.findLicenses()
	
	var $BuildApplicationName; $CompanyName : Text
	
	If ($BuildApp.BuildApplicationName#Null:C1517) && ($BuildApp.BuildApplicationName#"")
		$BuildApplicationName:=$BuildApp.BuildApplicationName
	Else 
		$BuildApplicationName:=$compileProject.name
	End if 
	
	$CLI._printTask("Set application name")
	$CLI._printItem($BuildApplicationName)
	
	$CLI._printTask("Set identifier prefix")
	
	$CompanyName:=$CLI._getVersioning($BuildApp; "CompanyName")
	$CLI._printItem($CompanyName)
	
	var $platform; $Build___DestFolder : Text
	
	$platform:=(Is macOS:C1572 ? "Mac" : "Win")
	
	$Build___DestFolder:="Build"+$platform+"DestFolder"
	
	If ($BuildApp[$Build___DestFolder]#Null:C1517) && ($BuildApp[$Build___DestFolder]#"")
		$BuildDestFolder:=Folder:C1567($BuildApp[$Build___DestFolder]; fk platform path:K87:2).folder("Final Application")
		$BuildDestFolder.create()
	End if 
	
	$CLI._printTask("Set destination folder")
	$CLI._printPath($BuildDestFolder)
	
	$targets:=New collection:C1472
	
	If (Bool:C1537($BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt))
		If (Bool:C1537($BuildApp.BuildApplicationSerialized))
			$targets.push("Serialized")
		End if 
		If (Bool:C1537($BuildApp.BuildApplicationLight))
			$targets.push("Light")
		End if 
	End if 
	If (Bool:C1537($BuildApp.BuildComponent))
		$targets.push("Component")
	End if 
	If (Bool:C1537($BuildApp.CS.BuildServerApplication))
		If (Bool:C1537($BuildApp.SourcesFiles.CS.ServerIncludeIt))
			$targets.push("Server")
		End if 
		If (Bool:C1537($BuildApp.SourcesFiles.CS.ClientMacIncludeIt))
			$targets.push("ClientMac")
		End if 
		If (Bool:C1537($BuildApp.SourcesFiles.CS.ClientWinIncludeIt))
			$targets.push("ClientWin")
		End if 
	End if 
	
	$CLI._printTask("Set targets")
	$CLI._printList($targets)
	
	
	
	
	