Class extends CLI

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
	
Function _printTask($task : Text)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$CLI.print($task; "bold").print("…")
	
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
	
Function _getVersioning($BuildApp : cs:C1710.BuildApp; $key : Text; $domain : Text)->$value : Text
	
	If ($domain#"")
		If ($BuildApp.Versioning[$domain][$domain+$key]#Null:C1517)
			If ($BuildApp.Versioning[$domain][$domain+$key]#"")
				$value:=$BuildApp.Versioning[$domain][$domain+$key]
			End if 
		End if 
	End if 
	
	If ($value="")
		If ($BuildApp.Versioning.Common["Common"+$key]#Null:C1517)
			If ($BuildApp.Versioning.Common["Common"+$key]#"")
				$value:=$BuildApp.Versioning.Common["Common"+$key]
			End if 
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
	
	If ($CompanyName="")
		$CompanyName:="com.4d"
	End if 
	
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
	
	var $xmlParser : cs:C1710._SettingsXmlParser
	
	$xmlParser:=cs:C1710._SettingsXmlParser.new()
	
	$settings:=$xmlParser.parse($compileProject)
	
	$RuntimeVL___Folder:="RuntimeVL"+$platform+"Folder"
	
	If ($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVL___Folder]#Null:C1517) && ($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVL___Folder]#"")
		
		var $RuntimeVLFolder : 4D:C1709.Folder
		$RuntimeVLFolder:=Folder:C1567($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVL___Folder]; fk platform path:K87:2)
		
		$CLI._printTask("Check runtime folder")
		$CLI._printStatus($RuntimeVLFolder.exists)
		$CLI._printPath($RuntimeVLFolder)
		
		If ($RuntimeVLFolder.exists)
			
			$targetRuntimeVLFolder:=$CLI._copyRuntime($BuildApp; $RuntimeVLFolder; $BuildDestFolder; $BuildApplicationName)
			
			$CLI._updateProperty($BuildApp; $targetRuntimeVLFolder; $CompanyName; $BuildApplicationName; $settings.sdi_application)
			
		End if 
		
	End if 
	
Function _copyRuntime($BuildApp : cs:C1710.BuildApp; \
$RuntimeFolder : 4D:C1709.Folder; \
$BuildDestFolder : 4D:C1709.Folder; $BuildApplicationName : Text)->$targetFolder : 4D:C1709.Folder
	
	$CLI:=This:C1470
	
	If (Is macOS:C1572)
		$targetName:=$BuildApplicationName+".app"
	Else 
		$targetName:=$BuildApplicationName
	End if 
	
	$targetFolder:=$BuildDestFolder.folder($targetName)
	
	If ($targetFolder.exists)
		$CLI._printTask("Delete target runtime folder")
		$CLI._printPath($targetFolder)
		$targetFolder.delete(Delete with contents:K24:24)
	End if 
	
	$targetFolder:=$RuntimeFolder.copyTo($BuildDestFolder; $targetName; fk overwrite:K87:5)
	
	$CLI._printTask("Copy runtime folder")
	$CLI._printPath($targetFolder)
	
	If (Is macOS:C1572)
		$executableFile:=$targetFolder.folder("Contents").folder("MacOS").file("4D Volume Desktop")
		$executableName:=$BuildApplicationName
	Else 
		$executableFile:=$targetFolder.file("4D Volume Desktop.4DE")
		$executableName:=$BuildApplicationName+".exe"
	End if 
	
	$targetExecutableFile:=$executableFile.rename($executableName)
	
	$CLI._printTask("Rename executable file")
	$CLI._printPath($targetExecutableFile)
	
	If (Is Windows:C1573)
		$resourceFile:=$targetFolder.file("4D Volume Desktop.rsr")
		$targetResourceFile:=$resourceFile.rename($BuildApplicationName+".rsr")
		$CLI._printTask("Rename resource file")
		$CLI._printPath($targetResourceFile)
	End if 
	
Function _updateProperty($BuildApp : cs:C1710.BuildApp; \
$targetRuntimeFolder : 4D:C1709.Folder; \
$CompanyName : Text; \
$BuildApplicationName : Text; \
$sdi_application : Boolean; $buildApplicationType : Text)
	
	$CLI:=This:C1470
	
	var $propertyListFile : 4D:C1709.File
	
	If (Is macOS:C1572)
		$propertyListFile:=$targetRuntimeFolder.folder("Contents").file("Info.plist")
	Else 
		$propertyListFile:=$targetRuntimeFolder.folder("Resources").file("Info.plist")
	End if 
	
	$keys:=New collection:C1472
	
	$info:=New object:C1471
	
	If (Is macOS:C1572)
		$info.CFBundleDisplayName:=$BuildApp.BuildApplicationName
		$info.CFBundleName:=$BuildApp.BuildApplicationName
		$info.CFBundleExecutable:=$appFolder.name
		$info.CFBundleIdentifier:=New collection:C1472($CompanyName; $BuildApplicationName; $buildApplicationType).join("."; ck ignore null or empty:K85:5)
		$keys.push("CFBundleName")
		$keys.push("CFBundleDisplayName")
		$keys.push("CFBundleExecutable")
		$keys.push("CFBundleIdentifier")
	Else 
		$info.OriginalFilename:=$BuildApplicationName+".exe"
		$keys.push("OriginalFilename")
		$info.ProductName:=$BuildApplicationName
		$keys.push("ProductName")
	End if 
	
	$info.DataFileConversionMode:="0"
	$keys.push("DataFileConversionMode")
	
	If (Is Windows:C1573)
		$info.SDIRuntime:=$sdi_application ? "1" : "0"
		$keys.push("SDIRuntime")
	End if 
	
	$info["com.4D.BuildApp.ReadOnlyApp"]:="true"
	$keys.push("com.4D.BuildApp.ReadOnlyApp")
	
	Case of 
		: ($buildApplicationType="Client")
		: ($buildApplicationType="Server")
			$info["com.4D.BuildApp.LastDataPathLookup"]:=$BuildApp.CS.LastDataPathLookup
			$keys.push("com.4D.BuildApp.LastDataPathLookup")
		Else 
			$info["com.4D.BuildApp.LastDataPathLookup"]:=$BuildApp.RuntimeVL.LastDataPathLookup
			$keys.push("com.4D.BuildApp.LastDataPathLookup")
	End case 
	
	var $platform; $RuntimeVLIcon___Path : Text
	
	$platform:=(Is macOS:C1572 ? "Mac" : "Win")
	
	$RuntimeVLIcon___Path:="RuntimeVLIcon"+$platform+"Path"
	
	Case of 
		: ($buildApplicationType="Client")
		: ($buildApplicationType="Server")
		Else 
			
			If ($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVLIcon___Path]#Null:C1517) && ($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVLIcon___Path]#"")
				var $RuntimeVLIconFile : 4D:C1709.File
				$RuntimeVLIconFile:=File:C1566($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVLIcon___Path]; fk platform path:K87:2)
				If ($RuntimeVLIconFile.exists)
					If (Is macOS:C1572)
						$targetIconFile:=$RuntimeVLIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources"); fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printPath($targetRuntimeVLIconFile)
						$targetIconFile:=$RuntimeVLIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources").folder("Images").folder("WindowIcons"); "windowIcon_205.icns"; fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printPath($targetRuntimeVLIconFile)
						$info.CFBundleIconFile:=$RuntimeVLIconFile.fullName
						$keys.push("CFBundleIconFile")
					Else 
						$info.WinIcon:=$RuntimeVLIconFile.platformPath
						$keys.push("WinIcon")
					End if 
				End if 
			End if 
			
	End case 
	
	Case of 
		: ($buildApplicationType="Client")
			$Version:=$CLI._getVersioning($BuildApp; "Version"; "Client")
			$Copyright:=$CLI._getVersioning($BuildApp; "Copyright"; "Client")
			$Version:=$CLI._getVersioning($BuildApp; "Version"; "Client")
			$Copyright:=$CLI._getVersioning($BuildApp; "Copyright"; "Client")
			$Creator:=$CLI._getVersioning($BuildApp; "Creator"; "Client")
			$Comment:=$CLI._getVersioning($BuildApp; "Comment"; "Client")
			$CompanyName:=$CLI._getVersioning($BuildApp; "CompanyName"; "Client")
			$FileDescription:=$CLI._getVersioning($BuildApp; "FileDescription"; "Client")
			$FileInternalName:=$CLI._getVersioning($BuildApp; "InternalName"; "Client")
			$LegalTrademark:=$CLI._getVersioning($BuildApp; "LegalTrademark"; "Client")
			$PrivateBuild:=$CLI._getVersioning($BuildApp; "PrivateBuild"; "Client")
			$SpecialBuild:=$CLI._getVersioning($BuildApp; "SpecialBuild"; "Client")
		: ($buildApplicationType="Server")
			$Version:=$CLI._getVersioning($BuildApp; "Version"; "Server")
			$Copyright:=$CLI._getVersioning($BuildApp; "Copyright"; "Server")
			$Version:=$CLI._getVersioning($BuildApp; "Version"; "Server")
			$Copyright:=$CLI._getVersioning($BuildApp; "Copyright"; "Server")
			$Creator:=$CLI._getVersioning($BuildApp; "Creator"; "Server")
			$Comment:=$CLI._getVersioning($BuildApp; "Comment"; "Server")
			$CompanyName:=$CLI._getVersioning($BuildApp; "CompanyName"; "Server")
			$FileDescription:=$CLI._getVersioning($BuildApp; "FileDescription"; "Server")
			$FileInternalName:=$CLI._getVersioning($BuildApp; "InternalName"; "Server")
			$LegalTrademark:=$CLI._getVersioning($BuildApp; "LegalTrademark"; "Server")
			$PrivateBuild:=$CLI._getVersioning($BuildApp; "PrivateBuild"; "Server")
			$SpecialBuild:=$CLI._getVersioning($BuildApp; "SpecialBuild"; "Server")
		Else 
			$Version:=$CLI._getVersioning($BuildApp; "Version"; "RuntimeVL")
			$Copyright:=$CLI._getVersioning($BuildApp; "Copyright"; "RuntimeVL")
			$Creator:=$CLI._getVersioning($BuildApp; "Creator"; "RuntimeVL")
			$Comment:=$CLI._getVersioning($BuildApp; "Comment"; "RuntimeVL")
			$CompanyName:=$CLI._getVersioning($BuildApp; "CompanyName"; "RuntimeVL")
			$FileDescription:=$CLI._getVersioning($BuildApp; "FileDescription"; "RuntimeVL")
			$FileInternalName:=$CLI._getVersioning($BuildApp; "InternalName"; "RuntimeVL")
			$LegalTrademark:=$CLI._getVersioning($BuildApp; "LegalTrademark"; "RuntimeVL")
			$PrivateBuild:=$CLI._getVersioning($BuildApp; "PrivateBuild"; "RuntimeVL")
			$SpecialBuild:=$CLI._getVersioning($BuildApp; "SpecialBuild"; "RuntimeVL")
	End case 
	
	If ($Version#"")
		$info.CFBundleVersion:=$Version
		$info.CFBundleShortVersionString:=$info.CFBundleVersion
		$keys.push("CFBundleVersion")
		$keys.push("CFBundleShortVersionString")
	End if 
	
	If ($Copyright#"")
		$info.CFBundleGetInfoString:=$Copyright
		$info.NSHumanReadableCopyright:=$info.CFBundleGetInfoString
		$keys.push("CFBundleVersion")
		$keys.push("CFBundleShortVersionString")
	End if 
	
	If ($Creator#"")
		$keys.push("Creator")
	End if 
	
	If ($Comment#"")
		$keys.push("Comment")
	End if 
	
	If ($CompanyName#"")
		$keys.push("CompanyName")
	End if 
	
	If ($FileDescription#"")
		$keys.push("FileDescription")
	End if 
	
	If ($FileInternalName#"")
		$keys.push("FileInternalName")
	End if 
	
	If ($PrivateBuild#"")
		$keys.push("PrivateBuild")
	End if 
	
	If ($SpecialBuild#"")
		$keys.push("SpecialBuild")
	End if 
	
	$CLI._printTask("Update property list")
	$CLI._printPath($propertyListFile)
	$CLI._printList($keys)
	
	$propertyListFile.setAppInfo($info)
	
	//This._updatePropertyStrings($CLI; $appFolder; $info)
	