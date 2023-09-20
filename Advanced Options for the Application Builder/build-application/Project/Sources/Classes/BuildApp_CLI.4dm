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
	
	$CompanyName:=$CLI._getVersioning($BuildApp; "CompanyName")
	
	If ($CompanyName="")
		$CompanyName:="com.4d"
	End if 
	
	$CLI._printTask("Set identifier prefix")
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
			
			$CLI._copyDatabase($BuildApp; $targetRuntimeVLFolder; $compileProject)
			
			$CLI._generateLicense($BuildApp; $targetRuntimeVLFolder)
			
			$CLI._sign()
			
		End if 
		
	End if 
	
Function _adHocSign($BuildApp : cs:C1710.BuildApp)
	
	$CLI:=This:C1470
	
	If (Is macOS:C1572)
		
		//$MacSignature:=Bool($BuildApp.SignApplication.MacSignature)
		//$AdHocSign:=Bool($BuildApp.SignApplication.AdHocSign)
		
		//If ($BuildApp.SignApplication.MacCertificate#Null) && ($BuildApp.SignApplication.MacCertificate#"")
		//$MacCertificate:=$BuildApp.SignApplication.MacCertificate
		//End if 
		
		$MacCertificate:="-"
		
		$applicationFolder:=Folder:C1567(Application file:C491; fk platform path:K87:2)
		$applicationResourcesFolder:=$applicationFolder.folder("Contents").folder("Resources")
		
		$script:=$applicationResourcesFolder.file("SignApp.sh")
		$entitlements:=$applicationResourcesFolder.file("4D.entitlements")
		
		
		
		
		
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
		
		$localProjectFolder:=File:C1566(Structure file:C489; fk platform path:K87:2).parent
		
		If ($targetFolder.path#($localProjectFolder.path+"@"))
			$CLI._printTask("Delete target runtime folder")
			$CLI._printPath($targetFolder)
			$targetFolder.delete(Delete with contents:K24:24)
		End if 
		
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
		$info.CFBundleExecutable:=$BuildApp.BuildApplicationName
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
						$CLI._printPath($targetIconFile)
						$targetIconFile:=$RuntimeVLIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources").folder("Images").folder("WindowIcons"); "windowIcon_205.icns"; fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printPath($targetIconFile)
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
	
	If (Is Windows:C1573)
		
		$targetUpdatorFolder:=$targetRuntimeFolder.folder("Resources").folder("Updater")
		$elevatedManifestFile:=$targetUpdatorFolder.file("elevated.manifest")
		$normalManifestFile:=$targetUpdatorFolder.file("normal.manifest")
		
		var $targetMaifestFile : 4D:C1709.File
		
		Case of 
			: ($buildApplicationType="Client")
				
				If (Bool:C1537($BuildApp.AutoUpdate.CS.Client.StartElevated)) || (Bool:C1537($BuildApp.AutoUpdate.CS.ClientUpdateWin.StartElevated))
					$targetMaifestFile:=$elevatedManifestFile.copyTo($targetUpdatorFolder; "Updater.exe.manifest"; fk overwrite:K87:5)
				End if 
				
			: ($buildApplicationType="Server")
				
				If (Bool:C1537($BuildApp.AutoUpdate.CS.Server.StartElevated)) || (Bool:C1537($BuildApp.AutoUpdate.CS.Server.StartElevated))
					$targetMaifestFile:=$elevatedManifestFile.copyTo($targetUpdatorFolder; "Updater.exe.manifest"; fk overwrite:K87:5)
				End if 
				
			Else 
				
				If (Bool:C1537($BuildApp.AutoUpdate.RuntimeVL.StartElevated))
					$targetMaifestFile:=$elevatedManifestFile.copyTo($targetUpdatorFolder; "Updater.exe.manifest"; fk overwrite:K87:5)
				End if 
				
		End case 
		
		If ($targetMaifestFile#Null:C1517)
			$CLI._printTask("Set updater manifest")
			$CLI._printPath($targetMaifestFile)
		End if 
		
	End if 
	
	$CLI._printTask("Update property list")
	$CLI._printPath($propertyListFile)
	$CLI._printList($keys)
	
	$propertyListFile.setAppInfo($info)
	
	$CLI._updatePropertyStrings($BuildApp; $targetRuntimeFolder; $info)
	
Function _updatePropertyStrings($BuildApp : cs:C1710.BuildApp; \
$targetFolder : 4D:C1709.Folder; $info : Object)
	
	$CLI:=This:C1470
	
	$folders:=$targetFolder.folder("Contents").folder("Resources").folders(fk ignore invisible:K87:22).query("extension == :1"; ".lproj")
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	var $key : Text
	$keys:=New collection:C1472
	$lproj:=New collection:C1472
	
	For each ($folder; $folders)
		
		$files:=$folder.files().query("fullName == :1"; "InfoPlist.strings")
		
		For each ($file; $files)
			$strings:=$file.getText("utf-16le"; Document with LF:K24:22)
			$lines:=Split string:C1554($strings; "\n")
			For each ($key; $info)
				For ($i; 1; $lines.length)
					$line:=$lines[$i-1]
					If (Match regex:C1019("^(\\S+)(\\s*=\\s*)\"(.*)\"(.*)"; $line; 1; $pos; $len))
						If ($key=Substring:C12($line; $pos{1}; $len{1}))
							$oper:=Substring:C12($line; $pos{2}; $len{2})
							$term:=Substring:C12($line; $pos{4}; $len{4})
							$oldValue:=Substring:C12($line; $pos{3}; $len{3})
							$newValue:=$info[$key]
							$lines[$i-1]:=$key+$oper+"\""+$newValue+"\""+$term
							$keys.push($key)
						End if 
					End if 
				End for 
			End for each 
			$file.setText($lines.join("\n"); "utf-16le"; Document with LF:K24:22)
			$lproj.push($file)
		End for each 
	End for each 
	
	$CLI._printTask("Update strings")
	$CLI._printList($keys.distinct())
	
	For each ($file; $lproj)
		$CLI._printPath($file)
	End for each 
	
Function _copyDatabase($BuildApp : cs:C1710.BuildApp; \
$targetFolder : 4D:C1709.Folder; \
$sourceProjectFile : 4D:C1709.File; $buildApplicationType : Text)
	
	$CLI:=This:C1470
	
	$ProjectFolder:=$sourceProjectFile.parent
	
	var $ContentsFolder : 4D:C1709.Folder
	
	Case of 
		: ($buildApplicationType="Client")
		: ($buildApplicationType="Server")
			$ContentsFolder:=$targetFolder.folder("Contents").folder("Server Database")
		Else 
			$ContentsFolder:=$targetFolder.folder("Contents").folder("Database")
	End case 
	
	If ($ContentsFolder#Null:C1517)
		
		$ContentsFolder.create()
		$targetProjectFolder:=$ProjectFolder.copyTo($ContentsFolder)
		
		$CLI._printTask("Set database folder")
		$CLI._printPath($targetProjectFolder)
		
		$localProjectFolder:=File:C1566(Structure file:C489; fk platform path:K87:2).parent
		
		If ($targetProjectFolder.path#($localProjectFolder.path+"@"))
			
			$folders:=New collection:C1472($targetProjectFolder.folder("Trash"))
			$folders.push($targetProjectFolder.folder("Sources").folder("DatabaseMethods"))
			$folders.push($targetProjectFolder.folder("Sources").folder("TableForms"))
			$folders.push($targetProjectFolder.folder("Sources").folder("Triggers"))
			$folders.push($targetProjectFolder.folder("Sources").folder("Forms"))
			$folders.push($targetProjectFolder.folder("Sources").folder("Classes"))
			$folders.push($targetProjectFolder.folder("Sources").folder("Methods"))
			
			$files:=New collection:C1472
			
			For each ($folder; $folders)
				$files.combine($folder.files(fk ignore invisible:K87:22).query("extension == :1"; ".4dm"))
			End for each 
			
			For each ($file; $files)
				$file.delete()
			End for each 
		End if 
		
	End if 
	
	If ($BuildApp.PackProject#Null:C1517) && ($BuildApp.PackProject)
		
		$zip:=New object:C1471
		$zip.files:=New collection:C1472($targetProjectFolder)
		
		If ($BuildApp.UseStandardZipFormat#Null:C1517) && ($BuildApp.UseStandardZipFormat)
			$zip.encryption:=ZIP Encryption none:K91:3
		Else 
			$zip.encryption:=-1
		End if 
		
		$targetProjectFile:=$ContentsFolder.file($BuildApp.BuildApplicationName+".4DZ")
		
		$status:=ZIP Create archive:C1640($zip; $targetProjectFile)
		
		$CLI._printTask("Archive project folder")
		$CLI._printStatus($status.success)
		$CLI._printPath($targetProjectFile)
		
		If ($targetProjectFolder.path#$localProjectFolder.path)
			$targetProjectFolder.delete(Delete with contents:K24:24)
		End if 
		
	End if 
	
	$folders:=$ProjectFolder.parent.folders(fk ignore invisible:K87:22).query("name in :1"; New collection:C1472("Resources"; "Libraries"/*; "Documentation"*/; "Default Data"))
	
	$CLI._printTask("Copy database folders")
	
	For each ($folder; $folders)
		$CLI._printPath($folder.copyTo($ContentsFolder))
	End for each 
	
Function _generateLicense($BuildApp : cs:C1710.BuildApp; $targetFolder : 4D:C1709.Folder; $buildApplicationType : Text)
	
	$CLI:=This:C1470
	
	var $platform; $ArrayLicense___ : Text
	
	$platform:=(Is macOS:C1572 ? "Mac" : "Win")
	
	$ArrayLicense___:="ArrayLicense"+$platform
	
	$licenes:=$BuildApp.Licenses[$ArrayLicense___].Item
	
	$UUDs:=$licenes.filter(Formula:C1597($1.result:=Path to object:C1547($1.value).name="@4UUD@"))
	$UOEs:=$licenes.filter(Formula:C1597($1.result:=Path to object:C1547($1.value).name="@4UOE@"))
	$UOSs:=$licenes.filter(Formula:C1597($1.result:=Path to object:C1547($1.value).name="@4UOS@"))
	$DOMs:=$licenes.filter(Formula:C1597($1.result:=Path to object:C1547($1.value).name="@4DOM@"))
	
	var $status : Object
	
	Case of 
		: ($buildApplicationType="Server") && ($DOMs.length#0) && ($UOSs.length#0)
			
			$status:=Create deployment license:C1811($targetFolder; File:C1566($UOSs[0]; fk platform path:K87:2); File:C1566($DOMs[0]; fk platform path:K87:2))
			
		Else 
			
			Case of 
				: ($UOEs.length#0)
					
					$status:=Create deployment license:C1811($targetFolder; File:C1566($UOEs[0]; fk platform path:K87:2))
					
				: ($UUDs.length#0)
					
					$status:=Create deployment license:C1811($targetFolder; File:C1566($UUDs[0]; fk platform path:K87:2))
					
			End case 
			
	End case 
	
	If ($status#Null:C1517)
		
		$CLI._printTask("Generate license")
		$CLI._printStatus($status.success)
		If ($status.file#Null:C1517)
			$CLI._printPath(File:C1566($status.file))
		End if 
		For each ($error; $status.errors)
			$CLI.print($error.message; "177;bold")
		End for each 
	End if 
	