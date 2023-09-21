Class extends CLI

Function clean($compileProject : 4D:C1709.File)
	
	$CLI:=This:C1470
	
	$packageFolder:=$compileProject.parent.parent
	
	$folders:=New collection:C1472
	
	For each ($folder; $packageFolder.folders(fk ignore invisible:K87:22))
		If ($folder.fullName="userPreferences.@")
			$_folder:=$folder.folder("CompilerIntermediateFiles")
			If ($_folder.exists)
				$folders.push($_folder)
			End if 
		End if 
	End for each 
	
	If ($folders.length#0)
		$CLI._printTask("Delete compiler intermediate files").LF()
		For each ($folder; $folders)
			$CLI._printPath($folder)
			$folder.delete(Delete with contents:K24:24)
		End for each 
	End if 
	
	$DerivedDataFolder:=$packageFolder.folder("Project").folder("DerivedData")
	If ($DerivedDataFolder.exists)
		$CLI._printTask("Delete derived data").LF()
		$CLI._printPath($DerivedDataFolder)
		$DerivedDataFolder.delete(Delete with contents:K24:24)
	End if 
	
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
	
Function _printItem($item : Text)->$CLI : cs:C1710.BuildApp_CLI
	
	$CLI:=This:C1470
	
	$CLI.print($item; "39").LF()
	
Function _printItemToList($item : Text; $count : Integer)->$CLI : cs:C1710.BuildApp_CLI
	
	If ($count#0)
		$CLI.print(","+$item; "39")
	Else 
		$CLI.print($item; "39")
	End if 
	
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
	
	$localProjectFile:=File:C1566(Structure file:C489; fk platform path:K87:2)
	
	If ($compileProject.path=$localProjectFile.path) && (Is compiled mode:C492)
		
		$success:=True:C214  //skip compilation
		
	Else 
		
		$CLI.clean($compileProject)
		
		$options:=New object:C1471
		$options.generateSymbols:=False:C215
		$options.generateSyntaxFile:=True:C214
		
		$BuildApp:=cs:C1710.BuildApp.new()
		
		$options.plugins:=$BuildApp.findPluginsFolder($compileProject)
		
		If ($options.plugins#Null:C1517)
			$CLI._printTask("Use plugins")
			$plugins:=$BuildApp.findPlugins($compileProject)
			$CLI._printList($plugins.extract("folder.name"))
			$CLI._printPath($options.plugins)
		End if 
		
		$options.components:=$BuildApp.findComponents($compileProject; True:C214)
		
		If ($options.components.length#0)
			$CLI._printTask("Use components")
			$CLI._printList($options.components.extract("name"))
			For each ($component; $BuildApp.findComponents($compileProject))
				$CLI._printPath($component)
			End for each 
		End if 
		
		If (Is macOS:C1572)
			$options.targets:=New collection:C1472("arm64_macOS_lib"; "x86_64_generic")
		End if 
		
		$CLI._printTask("Compile project")
		
		$status:=Compile project:C1760($compileProject; $options)
		
		$success:=$status.success
		
		For each ($error; $status.errors)
			If ($error.isError)
				$CLI.print($error.message; "177;bold")
			Else 
				$CLI.print($error.message; "166;bold")
			End if 
			If ($error.code#Null:C1517)
				$CLI.print("…").print($error.code.path+"#"+String:C10($error.lineInFile); "244").LF()
			End if 
		End for each 
		
	End if 
	
	$CLI._printStatus($success)
	$CLI._printPath($compileProject)
	
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
	If (Bool:C1537($BuildApp.BuildCompiled))
		$targets.push("Compiled")
	End if 
	
	$CLI._printTask("Set targets")
	$CLI._printList($targets)
	
	var $xmlParser : cs:C1710._SettingsXmlParser
	
	$xmlParser:=cs:C1710._SettingsXmlParser.new()
	
	$settings:=$xmlParser.parse($compileProject)
	
	For each ($target; $targets)
		
		Case of 
			: ($target="Serialized") | ($target="Light")
				
				var $BuildDestFolder : 4D:C1709.Folder
				
				If ($BuildApp[$Build___DestFolder]#Null:C1517) && ($BuildApp[$Build___DestFolder]#"")
					$BuildDestFolder:=Folder:C1567($BuildApp[$Build___DestFolder]; fk platform path:K87:2).folder("Final Application")
					$BuildDestFolder.create()
				End if 
				
				$CLI._printTask("Set destination folder")
				$CLI._printStatus($BuildDestFolder#Null:C1517)
				$CLI._printPath($BuildDestFolder)
				
				$RuntimeVL___Folder:="RuntimeVL"+$platform+"Folder"
				
				If ($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVL___Folder]#Null:C1517) && ($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVL___Folder]#"")
					
					var $RuntimeVLFolder : 4D:C1709.Folder
					$RuntimeVLFolder:=Folder:C1567($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVL___Folder]; fk platform path:K87:2)
					
					$CLI._printTask("Check runtime folder")
					$CLI._printStatus($RuntimeVLFolder.exists)
					$CLI._printPath($RuntimeVLFolder)
					
					If ($RuntimeVLFolder.exists)
						
						$targetRuntimeVLFolder:=$CLI._copyRuntime($BuildApp; $RuntimeVLFolder; $BuildDestFolder; $BuildApplicationName)
						
						$CLI._copyPlugins($BuildApp; $targetRuntimeVLFolder; $compileProject)
						
						$CLI._copyComponents($BuildApp; $targetRuntimeVLFolder; $compileProject)
						
						$CLI._updateProperty($BuildApp; $targetRuntimeVLFolder; $CompanyName; $BuildApplicationName; $settings.sdi_application)
						
						$CLI._copyDatabase($BuildApp; $targetRuntimeVLFolder; $compileProject)
						
						If ($target="Serialized")
							$CLI._generateLicense($BuildApp; $targetRuntimeVLFolder)
						End if 
						
						$CLI.quickSign($targetRuntimeVLFolder)
						
						$success:=True:C214
						
					End if 
					
				End if 
				
			: ($target="Server")
				
				var $BuildDestFolder : 4D:C1709.Folder
				
				If ($BuildApp[$Build___DestFolder]#Null:C1517) && ($BuildApp[$Build___DestFolder]#"")
					$BuildDestFolder:=Folder:C1567($BuildApp[$Build___DestFolder]; fk platform path:K87:2).folder("Client Server executable")
					$BuildDestFolder.create()
				End if 
				
				$CLI._printTask("Set destination folder")
				$CLI._printStatus($BuildDestFolder#Null:C1517)
				$CLI._printPath($BuildDestFolder)
				
				$Server___Folder:="Server"+$platform+"Folder"
				
				If ($BuildApp.SourcesFiles.CS[$Server___Folder]#Null:C1517) && ($BuildApp.SourcesFiles.CS[$Server___Folder]#"")
					
					var $ServerFolder : 4D:C1709.Folder
					$ServerFolder:=Folder:C1567($BuildApp.SourcesFiles.CS[$Server___Folder]; fk platform path:K87:2)
					
					$CLI._printTask("Check server runtime folder")
					$CLI._printStatus($ServerFolder.exists)
					$CLI._printPath($ServerFolder)
					
					If ($ServerFolder.exists)
						
						$targetServerFolder:=$CLI._copyRuntime($BuildApp; $ServerFolder; $BuildDestFolder; $BuildApplicationName; $target)
						
						$CLI._copyPlugins($BuildApp; $targetServerFolder; $compileProject)
						
						$CLI._copyComponents($BuildApp; $targetServerFolder; $compileProject)
						
						$CLI._updateProperty($BuildApp; $targetServerFolder; $CompanyName; $BuildApplicationName; $settings.sdi_application; $target)
						
						$CLI._copyDatabase($BuildApp; $targetServerFolder; $compileProject; $target)
						
						If ($BuildApp.SourcesFiles.CS.IsOEM)
							$CLI._generateLicense($BuildApp; $targetServerFolder)
						End if 
						
						$CLI.quickSign($targetServerFolder)
						
						$success:=True:C214
						
					End if 
					
				End if 
				
			: ($target="Compiled")
				
			: ($target="Component")
				
			: ($target="ClientMac") | ($target="ClientWin")
				
				var $BuildDestFolder : 4D:C1709.Folder
				
				If ($BuildApp[$Build___DestFolder]#Null:C1517) && ($BuildApp[$Build___DestFolder]#"")
					$BuildDestFolder:=Folder:C1567($BuildApp[$Build___DestFolder]; fk platform path:K87:2).folder("Client Server executable")
					$BuildDestFolder.create()
				End if 
				
				$CLI._printTask("Set destination folder")
				$CLI._printStatus($BuildDestFolder#Null:C1517)
				$CLI._printPath($BuildDestFolder)
				
		End case 
		
	End for each 
	
Function quickSign($RuntimeFolder : 4D:C1709.Folder)->$success : Boolean
	
	$CLI:=This:C1470
	
	If (Is macOS:C1572)
		
		$CLI._printTask("Sign app")
		$CLI._printPath($RuntimeFolder)
		
		quickSign($RuntimeFolder)
		
		$success:=True:C214
		
	End if 
	
Function _copyComponents($BuildApp : cs:C1710.BuildApp; \
$RuntimeFolder : 4D:C1709.Folder; \
$compileProject : 4D:C1709.File)
	
	$CLI:=This:C1470
	
	$components:=$BuildApp.findComponents($compileProject)
	$targetComponentsFolder:=$RuntimeFolder.folder("Contents").folder("Components")
	
	var $component : Object
	
	For each ($component; $components)
		
		Case of 
			: ($BuildApp.ArrayExcludedComponentName.Item.includes($component.name))
				
			Else 
				
				$targetComponentsFolder.create()
				$targetComponent:=$component.copyTo($targetComponentsFolder; fk overwrite:K87:5)
				
				$CLI._printTask("Copy component")
				$CLI._printItem($component.name)
				$CLI._printPath($targetComponent)
				
		End case 
		
	End for each 
	
Function _copyDatabase($BuildApp : cs:C1710.BuildApp; \
$targetFolder : 4D:C1709.Folder; \
$sourceProjectFile : 4D:C1709.File; $buildApplicationType : Text)
	
	$CLI:=This:C1470
	
	$ProjectFolder:=$sourceProjectFile.parent
	
	var $ContentsFolder : 4D:C1709.Folder
	
	Case of 
		: ($buildApplicationType="Client@")
		: ($buildApplicationType="Server")
			$ContentsFolder:=$targetFolder.folder("Contents").folder("Server Database")
		Else 
			$ContentsFolder:=$targetFolder.folder("Contents").folder("Database")
	End case 
	
	If ($ContentsFolder#Null:C1517)
		
		$ContentsFolder.create()
		$targetProjectFolder:=$ProjectFolder.copyTo($ContentsFolder)
		
		$CLI._printTask("Set database folder")
		$CLI._printStatus($targetProjectFolder.exists)
		$CLI._printPath($targetProjectFolder)
		
		$localProjectFolder:=File:C1566(Structure file:C489; fk platform path:K87:2).parent
		
		If ($targetProjectFolder.path#($localProjectFolder.path+"@"))
			
			$folders:=New collection:C1472($targetProjectFolder.folder("Trash"))
			$folders.push($targetProjectFolder.folder("Sources").folder("DatabaseMethods"))
			$folders.push($targetProjectFolder.folder("Sources").folder("TableForms"))
			$folders.push($targetProjectFolder.folder("Sources").folder("Triggers"))
			$folders.push($targetProjectFolder.folder("Sources").folder("Classes"))
			$folders.push($targetProjectFolder.folder("Sources").folder("Methods"))
			$folders.push($targetProjectFolder.folder("Sources").folder("Forms"))
			
			$files:=New collection:C1472
			
			For each ($folder; $folders)
				$files.combine($folder.files(fk ignore invisible:K87:22).query("extension == :1"; ".4dm"))
			End for each 
			
			For each ($file; $files)
				$file.delete()
			End for each 
			
			$Forms:=$folders.pop()
			
			For each ($folder; $folders)
				$folder.delete()
			End for each 
			
		End if 
		
		$files:=$ContentsFolder.folder("Project").files(fk ignore invisible:K87:22).query("extension == :1"; ".4DProject")
		
		If ($files.length#0)
			
			$targetProjectFile:=$files[0]
			
			$CLI._printTask("Rename project")
			$targetProjectFile:=$targetProjectFile.rename($BuildApp.BuildApplicationName+".4DProject")
			$CLI._printStatus($targetProjectFile.exists)
			$CLI._printPath($targetProjectFile)
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
	
	$folders:=$ProjectFolder.parent.folders(fk ignore invisible:K87:22).query("name in :1"; New collection:C1472("Resources"; "Libraries"; "Documentation"; "Default Data"; "Extras"))
	
	$CLI._printTask("Copy database folders").LF()
	For each ($folder; $folders)
		$CLI._printPath($folder.copyTo($ContentsFolder))
	End for each 
	
Function _copyPlugins($BuildApp : cs:C1710.BuildApp; \
$RuntimeFolder : 4D:C1709.Folder; \
$compileProject : 4D:C1709.File)
	
	$CLI:=This:C1470
	
	var $plugins : Collection
	
	$plugins:=$BuildApp.findPlugins($compileProject)
	$targetPluginsFolder:=$RuntimeFolder.folder("Contents").folder("Plugins")
	
	var $plugin : Object
	
	For each ($plugin; $plugins)
		
		Case of 
			: ($BuildApp.ArrayExcludedPluginID.Item.includes($plugin.manifest.id))
				
			: ($BuildApp.ArrayExcludedPluginName.Item.includes($plugin.manifest.name))
				
			Else 
				
				$targetPluginsFolder.create()
				$targetPlugin:=$plugin.folder.copyTo($targetPluginsFolder; fk overwrite:K87:5)
				
				$CLI._printTask("Copy plugin")
				$CLI._printItem($plugin.manifest.name)
				$CLI._printPath($targetPlugin)
				
		End case 
		
	End for each 
	
Function _copyRuntime($BuildApp : cs:C1710.BuildApp; \
$RuntimeFolder : 4D:C1709.Folder; \
$BuildDestFolder : 4D:C1709.Folder; $BuildApplicationName : Text; $buildApplicationType : Text)->$targetFolder : 4D:C1709.Folder
	
	$CLI:=This:C1470
	
	Case of 
		: ($buildApplicationType="Server")
			$targetName:=$BuildApplicationName+" Server"
		: ($buildApplicationType="Client@")
			$targetName:=$BuildApplicationName+" Client"
		Else 
			$targetName:=$BuildApplicationName
	End case 
	
	If (Is macOS:C1572)
		$targetName:=$targetName+".app"
	End if 
	
	$targetFolder:=$BuildDestFolder.folder($targetName)
	
	If ($targetFolder.exists)
		
		$localProjectFolder:=File:C1566(Structure file:C489; fk platform path:K87:2).parent
		
		If ($targetFolder.path#($localProjectFolder.path+"@"))
			$targetFolder.delete(Delete with contents:K24:24)
		End if 
		
	End if 
	
	$targetFolder:=$RuntimeFolder.copyTo($BuildDestFolder; $targetName; fk overwrite:K87:5)
	
	$CLI._printTask("Copy runtime folder")
	$CLI._printStatus($targetFolder.exists)
	$CLI._printPath($targetFolder)
	
	Case of 
		: ($buildApplicationType="Server")
			$RuntimeExecutableName:="4D Server"
		Else 
			$RuntimeExecutableName:="4D Volume Desktop"
	End case 
	
	If (Is macOS:C1572)
		$executableFile:=$targetFolder.folder("Contents").folder("MacOS").file($RuntimeExecutableName)
		$executableName:=$BuildApplicationName
	Else 
		Case of 
			: ($buildApplicationType="Server")
				$executableFile:=$targetFolder.file($RuntimeExecutableName+".exe")
			Else 
				$executableFile:=$targetFolder.file($RuntimeExecutableName+".4DE")
		End case 
		$executableName:=$BuildApplicationName+".exe"
	End if 
	
	$targetExecutableFile:=$executableFile.rename($executableName)
	
	$CLI._printTask("Rename executable file")
	$CLI._printStatus($targetExecutableFile.exists)
	$CLI._printPath($targetExecutableFile)
	
	If (Is Windows:C1573)
		$resourceFile:=$targetFolder.file($RuntimeExecutableName+".rsr")
		$targetResourceFile:=$resourceFile.rename($BuildApplicationName+".rsr")
	Else 
		$resourceFile:=$targetFolder.folder("Contents").folder("Resources").file($RuntimeExecutableName+".rsrc")
		$targetResourceFile:=$resourceFile.rename($BuildApplicationName+".rsrc")
	End if 
	
	$CLI._printTask("Rename resource file")
	$CLI._printStatus($targetResourceFile.exists)
	$CLI._printPath($targetResourceFile)
	
	If ($BuildApp.ArrayExcludedModuleName.Item.includes("PHP"))
		
		$moduleFolder:=$targetFolder.folder("Contents").folder("Resources").folder("php")
		
		$CLI._printTask("Delete PHP module")
		$CLI._printStatus($moduleFolder.exists)
		$CLI._printPath($moduleFolder)
		
		$moduleFolder.delete(Delete with contents:K24:24)
		
	End if 
	
	If ($BuildApp.ArrayExcludedModuleName.Item.includes("MeCab"))
		
		$moduleFolder:=$targetFolder.folder("Contents").folder("Resources").folder("mecab")
		
		$CLI._printTask("Delete MeCab module")
		$CLI._printStatus($moduleFolder.exists)
		$CLI._printPath($moduleFolder)
		
		$moduleFolder.delete(Delete with contents:K24:24)
		
	End if 
	
	If ($BuildApp.ArrayExcludedModuleName.Item.includes("4D Updater"))
		
		$moduleFolder:=$targetFolder.folder("Contents").folder("Resources").folder("Updater")
		
		$CLI._printTask("Delete 4D Updater module")
		$CLI._printStatus($moduleFolder.exists)
		$CLI._printPath($moduleFolder)
		
		$moduleFolder.delete(Delete with contents:K24:24)
		
	End if 
	
	If ($BuildApp.ArrayExcludedModuleName.Item.includes("SpellChecker"))
		
		$moduleFolder:=$targetFolder.folder("Contents").folder("Resources").folder("Spellcheck")
		
		$CLI._printTask("Delete SpellChecker module")
		$CLI._printStatus($moduleFolder.exists)
		$CLI._printPath($moduleFolder)
		
		$moduleFolder.delete(Delete with contents:K24:24)
		
	End if 
	
	If ($BuildApp.ArrayExcludedModuleName.Item.includes("CEF"))
		
		$moduleFolder:=$targetFolder.folder("Contents").folder("Native Components").folder("WebViewerCEF.bundle")
		
		$CLI._printTask("Delete CEF module")
		$CLI._printStatus($moduleFolder.exists)
		$CLI._printPath($moduleFolder)
		
		$moduleFolder.delete(Delete with contents:K24:24)
		
		//symlink
		$file:=$targetFolder.folder("Contents").folder("Frameworks").file("Chromium Embedded Framework.framework")
		$CLI._printPath($file)
		$file.delete()
		
	End if 
	
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
		$info.BuildName:=$BuildApp.BuildApplicationName
		$info.PublishName:=$BuildApp.BuildApplicationName
		
		Case of 
			: ($buildApplicationType="Server")
				$info.CFBundleIdentifier:=New collection:C1472($CompanyName; $BuildApplicationName; "server").join("."; ck ignore null or empty:K85:5)
			: ($buildApplicationType="Client@")
				$info.CFBundleIdentifier:=New collection:C1472($CompanyName; $BuildApplicationName; "client").join("."; ck ignore null or empty:K85:5)
			Else 
				$info.CFBundleIdentifier:=New collection:C1472($CompanyName; $BuildApplicationName).join("."; ck ignore null or empty:K85:5)
		End case 
		
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
	
	If ($BuildApp.CS.ClientWinSingleInstance)
		$info["4D_SingleInstance"]:="1"
	End if 
	
	If ($BuildApp.CS.ClientServerSystemFolderName#Null:C1517) && ($BuildApp.CS.ClientServerSystemFolderName#"")
		$info["com.4d.ServerCacheFolderName"]:=$BuildApp.CS.ClientServerSystemFolderName
	End if 
	
	If ($BuildApp.CS.HideDataExplorerMenuItem)
		$info["com.4D.HideDataExplorerMenuItem"]:="true"
	End if 
	
	If ($BuildApp.CS.ServerDataCollection)
		$info["com.4d.dataCollection"]:="true"
		$info["DataCollection"]:="true"
	End if 
	
	If ($BuildApp.CS.HideAdministrationMenuItem)
		$info["com.4D.HideAdministrationWindowMenuItem"]:="true"
	End if 
	
	If ($BuildApp.CS.HideRuntimeExplorerMenuItem)
		$info["com.4D.HideRuntimeExplorerMenuItem"]:="true"
	End if 
	
	If ($BuildApp.CS.HardLink#Null:C1517) && ($BuildApp.CS.HardLink#"")
		$info["BuildHardLink"]:=$BuildApp.CS.HardLink
	End if 
	
	If ($BuildApp.CS.RangeVersMin#Null:C1517) && ($BuildApp.CS.RangeVersMin#0)
		$info["BuildRangeVersMin"]:=String:C10($BuildApp.CS.RangeVersMin)
	End if 
	
	If ($BuildApp.CS.RangeVersMax#Null:C1517) && ($BuildApp.CS.RangeVersMax#0)
		$info["BuildRangeVersMax"]:=String:C10($BuildApp.CS.RangeVersMax)
	End if 
	
	If ($BuildApp.CS.CurrentVers#Null:C1517) && ($BuildApp.CS.CurrentVers#0)
		$info["BuildCurrentVers"]:=String:C10($BuildApp.CS.CurrentVers)
	End if 
	
	Case of 
		: ($buildApplicationType="Client@")
			//
		: ($buildApplicationType="Server")
			$info["com.4D.BuildApp.LastDataPathLookup"]:=$BuildApp.CS.LastDataPathLookup
			$keys.push("com.4D.BuildApp.LastDataPathLookup")
		Else 
			$info["com.4D.BuildApp.LastDataPathLookup"]:=$BuildApp.RuntimeVL.LastDataPathLookup
			$keys.push("com.4D.BuildApp.LastDataPathLookup")
	End case 
	
	var $platform; $RuntimeVLIcon___Path : Text
	
	$platform:=(Is macOS:C1572 ? "Mac" : "Win")
	
	Case of 
		: ($buildApplicationType="ClientMac")
			
			$ClientMacIconFor___Path:="ClientMacIconFor"+$platform+"Path"
			
			If ($BuildApp.SourcesFiles.CS[$ClientMacIconFor___Path]#Null:C1517) && ($BuildApp.SourcesFiles.CS[$ClientMacIconFor___Path]#"")
				var $ClientIconFile : 4D:C1709.File
				$ClientIconFile:=File:C1566($BuildApp.SourcesFiles.CS[$ClientMacIconFor___Path]; fk platform path:K87:2)
				If ($ClientIconFile.exists)
					If (Is macOS:C1572)
						$targetIconFile:=$ClientIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources"); fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$targetIconFile:=$ClientIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources").folder("Images").folder("WindowIcons"); "windowIcon_205.icns"; fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$info.CFBundleIconFile:=$ClientIconFile.fullName
						$keys.push("CFBundleIconFile")
					Else 
						$info.WinIcon:=$ServerIconFile.platformPath
						$keys.push("WinIcon")
					End if 
				End if 
			End if 
			
		: ($buildApplicationType="ClientWin")
			
			$ClientWinIconFor___Path:="ClientWinIconFor"+$platform+"Path"
			
			If ($BuildApp.SourcesFiles.CS[$ClientWinIconFor___Path]#Null:C1517) && ($BuildApp.SourcesFiles.CS[$ClientWinIconFor___Path]#"")
				var $ClientIconFile : 4D:C1709.File
				$ClientIconFile:=File:C1566($BuildApp.SourcesFiles.CS[$ClientWinIconFor___Path]; fk platform path:K87:2)
				If ($ClientIconFile.exists)
					If (Is macOS:C1572)
						$targetIconFile:=$ClientIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources"); fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$targetIconFile:=$ClientIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources").folder("Images").folder("WindowIcons"); "windowIcon_205.icns"; fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$info.CFBundleIconFile:=$ClientIconFile.fullName
						$keys.push("CFBundleIconFile")
					Else 
						$info.WinIcon:=$ServerIconFile.platformPath
						$keys.push("WinIcon")
					End if 
				End if 
			End if 
			
		: ($buildApplicationType="Server")
			
			$ServerIcon___Path:="ServerIcon"+$platform+"Path"
			
			If ($BuildApp.SourcesFiles.CS[$ServerIcon___Path]#Null:C1517) && ($BuildApp.SourcesFiles.CS[$ServerIcon___Path]#"")
				var $ServerIconFile : 4D:C1709.File
				$ServerIconFile:=File:C1566($BuildApp.SourcesFiles.CS[$ServerIcon___Path]; fk platform path:K87:2)
				If ($ServerIconFile.exists)
					If (Is macOS:C1572)
						$targetIconFile:=$ServerIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources"); fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$targetIconFile:=$ServerIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources").folder("Images").folder("WindowIcons"); "windowIcon_205.icns"; fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$info.CFBundleIconFile:=$ServerIconFile.fullName
						$keys.push("CFBundleIconFile")
					Else 
						$info.WinIcon:=$ServerIconFile.platformPath
						$keys.push("WinIcon")
					End if 
				End if 
			End if 
			
		Else 
			
			$RuntimeVLIcon___Path:="RuntimeVLIcon"+$platform+"Path"
			
			If ($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVLIcon___Path]#Null:C1517) && ($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVLIcon___Path]#"")
				var $RuntimeVLIconFile : 4D:C1709.File
				$RuntimeVLIconFile:=File:C1566($BuildApp.SourcesFiles.RuntimeVL[$RuntimeVLIcon___Path]; fk platform path:K87:2)
				If ($RuntimeVLIconFile.exists)
					If (Is macOS:C1572)
						$targetIconFile:=$RuntimeVLIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources"); fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
						$CLI._printPath($targetIconFile)
						$targetIconFile:=$RuntimeVLIconFile.copyTo($targetRuntimeFolder.folder("Contents").folder("Resources").folder("Images").folder("WindowIcons"); "windowIcon_205.icns"; fk overwrite:K87:5)
						$CLI._printTask("Copy icon file")
						$CLI._printStatus($targetIconFile.exists)
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
		: ($buildApplicationType="Client@")
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
			: ($buildApplicationType="Client@")
				
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
	$CLI._printList($keys)
	$CLI._printPath($propertyListFile)
	
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
			$changed:=False:C215
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
							$changed:=True:C214
						End if 
					End if 
				End for 
			End for each 
			If ($changed)
				$file.setText($lines.join("\n"); "utf-16le"; Document with LF:K24:22)
				$lproj.push($file)
			End if 
		End for each 
	End for each 
	
	If ($lproj.length#0)
		$CLI._printTask("Update strings")
		$CLI._printList($keys.distinct())
		For each ($file; $lproj)
			$CLI._printPath($file)
		End for each 
	End if 
	
	