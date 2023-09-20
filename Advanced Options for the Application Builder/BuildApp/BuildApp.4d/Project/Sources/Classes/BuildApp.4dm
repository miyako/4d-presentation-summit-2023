property _settingsFile : 4D:C1709.File
property _templateFile : 4D:C1709.File
property _settings : Object

Class constructor($settingsFile : 4D:C1709.File)
	
	This:C1470._settingsFile:=Null:C1517
	This:C1470._templateFile:=Folder:C1567(fk resources folder:K87:11).file("BuildApp-Template.4DSettings")
	
	This:C1470._refresh($settingsFile)
	
Function get settings()->$settings : Object
	
	$settings:=This:C1470._settings
	
	For each ($setting; $settings)
		$settings[$setting]:=This:C1470[$setting]
	End for each 
	
	//MARK:-public methods
	
Function findLicenses($licenseTypes : Collection)->$BuildApp : cs:C1710.BuildApp
	
	$BuildApp:=This:C1470
	
	If (Count parameters:C259=0)
		$licenseTypes:=$BuildApp._serverLicenses()
	End if 
	
	var $build : Integer
	var $version; $prefix : Text
	
	$version:=Application version:C493($build)
	
	If (Substring:C12($version; 3; 1)#"0")
		$prefix:="R-"
	Else 
		$prefix:=""
	End if 
	
	$params:=New object:C1471("parameters"; New object:C1471)
	$params.parameters.licenseTypes:=New collection:C1472
	$params.parameters.license4D:=".license4D"
	$versionCode:=Substring:C12($version; 1; 2)+"0"
	For each ($licenseType; $licenseTypes)
		$params.parameters.licenseTypes.push($prefix+$licenseType+$versionCode+"@")
	End for each 
	
	var $files : Collection
	var $file : Object
	
	$files:=Folder:C1567(fk licenses folder:K87:16).files(fk ignore invisible:K87:22).query("name in :licenseTypes and  extension == :license4D"; $params)
	
	Case of 
		: (Is macOS:C1572)
			
			For each ($file; $files)
				$BuildApp.Licenses.ArrayLicenseMac.Item.push(Get 4D folder:C485(Licenses folder:K5:11)+$file.fullName)
			End for each 
			
		: (Is Windows:C1573)
			
			For each ($file; $files)
				$BuildApp.Licenses.ArrayLicenseWin.Item.push(Get 4D folder:C485(Licenses folder:K5:11)+$file.fullName)
			End for each 
			
	End case 
	
	$isOEM:=($BuildApp.Licenses["ArrayLicense"+(Is macOS:C1572 ? "Mac" : "Win")].Item.includes("@4DOM@"))
	$BuildApp.SourcesFiles.CS.IsOEM:=$isOEM
	
	$isOEM:=($BuildApp.Licenses["ArrayLicense"+(Is macOS:C1572 ? "Mac" : "Win")].Item.includes("@4UOE@"))
	$BuildApp.SourcesFiles.RuntimeVL.IsOEM:=$isOEM
	
Function loadFromHost()->$BuildApp : cs:C1710.BuildApp
	
	$BuildApp:=This:C1470
	
	$BuildApp._refresh($BuildApp._getDefaultSettingsFile())
	
Function toFile($file : 4D:C1709.File)->$BuildApp : cs:C1710.BuildApp
	
	$BuildApp:=This:C1470
	
	If (OB Instance of:C1731($file; 4D:C1709.File))
		$file.setText($BuildApp.toString(); "utf-8"; Document with CR:K24:21)
	End if 
	
Function toString()->$XML : Text
	
	$BuildApp:=This:C1470
	
	If ($BuildApp._templateFile.exists)
		$template:=$BuildApp._templateFile.getText("utf-8"; Document with CR:K24:21)
		PROCESS 4D TAGS:C816($template; $XML; $BuildApp.settings)
	End if 
	
Function parseFile($settingsFile : 4D:C1709.File)->$BuildApp : cs:C1710.BuildApp
	
	$BuildApp:=This:C1470
	
	$_BuildApp:=New object:C1471(\
		"BuildApplicationName"; Null:C1517; \
		"BuildWinDestFolder"; Null:C1517; \
		"BuildMacDestFolder"; Null:C1517; \
		"DataFilePath"; Null:C1517; \
		"BuildApplicationSerialized"; False:C215; \
		"BuildApplicationLight"; False:C215; \
		"IncludeAssociatedFolders"; False:C215; \
		"BuildComponent"; False:C215; \
		"BuildCompiled"; False:C215; \
		"ArrayExcludedPluginName"; New object:C1471("ItemsCount"; Formula:C1597(This:C1470.Item.length); "Item"; New collection:C1472); \
		"ArrayExcludedPluginID"; New object:C1471("ItemsCount"; Formula:C1597(This:C1470.Item.length); "Item"; New collection:C1472); \
		"ArrayExcludedComponentName"; New object:C1471("ItemsCount"; Formula:C1597(This:C1470.Item.length); "Item"; New collection:C1472); \
		"ArrayExcludedModuleName"; New object:C1471("ItemsCount"; Formula:C1597(This:C1470.Item.length); "Item"; New collection:C1472); \
		"UseStandardZipFormat"; False:C215; \
		"PackProject"; True:C214)
	
	$_BuildApp.AutoUpdate:=New object:C1471(\
		"CS"; \
		New object:C1471(\
		"Client"; New object:C1471("StartElevated"; Null:C1517); \
		"ClientUpdateWin"; New object:C1471("StartElevated"; Null:C1517); \
		"Server"; New object:C1471("StartElevated"; Null:C1517)); \
		"RuntimeVL"; New object:C1471("StartElevated"; Null:C1517))
	
	$_BuildApp.CS:=New object:C1471(\
		"BuildServerApplication"; False:C215; \
		"BuildCSUpgradeable"; False:C215; \
		"BuildV13ClientUpgrades"; False:C215; \
		"IPAddress"; Null:C1517; \
		"PortNumber"; Null:C1517; \
		"HardLink"; Null:C1517; \
		"RangeVersMin"; 1; \
		"RangeVersMax"; 1; \
		"CurrentVers"; 1; \
		"LastDataPathLookup"; Null:C1517; \
		"ServerSelectionAllowed"; False:C215; \
		"ServerStructureFolderName"; Null:C1517; \
		"ClientWinSingleInstance"; True:C214; \
		"ClientServerSystemFolderName"; Null:C1517; \
		"ClientWinSingleInstance"; False:C215; \
		"ServerEmbedsProjectDirectoryFile"; False:C215; \
		"ServerDataCollection"; False:C215; \
		"HideDataExplorerMenuItem"; False:C215; \
		"HideRuntimeExplorerMenuItem"; False:C215; \
		"ClientUserPreferencesFolderByPath"; False:C215; \
		"ShareLocalResourcesOnWindowsClient"; False:C215; \
		"MacCompiledDatabaseToWin"; Null:C1517; \
		"MacCompiledDatabaseToWinIncludeIt"; False:C215; \
		"HideAdministrationMenuItem"; False:C215)
	
	$_BuildApp.Licenses:=New object:C1471(\
		"ArrayLicenseWin"; New object:C1471("ItemsCount"; Formula:C1597(This:C1470.Item.length); "Item"; New collection:C1472); \
		"ArrayLicenseMac"; New object:C1471("ItemsCount"; Formula:C1597(This:C1470.Item.length); "Item"; New collection:C1472))
	
	$_BuildApp.RuntimeVL:=New object:C1471("LastDataPathLookup"; "ByAppName")
	
	$_BuildApp.SignApplication:=New object:C1471("MacSignature"; Null:C1517; "MacCertificate"; Null:C1517; "AdHocSign"; Null:C1517)
	
	$_BuildApp.SourcesFiles:=New object:C1471(\
		"RuntimeVL"; New object:C1471(\
		"RuntimeVLIncludeIt"; False:C215; \
		"RuntimeVLWinFolder"; Null:C1517; \
		"RuntimeVLMacFolder"; Null:C1517; \
		"RuntimeVLIconWinPath"; Null:C1517; \
		"RuntimeVLIconMacPath"; Null:C1517; \
		"IsOEM"; False:C215); \
		"CS"; New object:C1471(\
		"ServerIncludeIt"; False:C215; \
		"ServerWinFolder"; Null:C1517; \
		"ServerMacFolder"; Null:C1517; \
		"ClientWinIncludeIt"; False:C215; \
		"ClientWinFolderToWin"; Null:C1517; \
		"ClientWinFolderToMac"; Null:C1517; \
		"ClientMacIncludeIt"; False:C215; \
		"ClientMacFolderToWin"; Null:C1517; \
		"ClientMacFolderToMac"; Null:C1517; \
		"ServerIconWinPath"; Null:C1517; \
		"ServerIconMacPath"; Null:C1517; \
		"ClientMacIconForMacPath"; Null:C1517; \
		"ClientWinIconForMacPath"; Null:C1517; \
		"ClientMacIconForWinPath"; Null:C1517; \
		"ClientWinIconForWinPath"; Null:C1517; \
		"DatabaseToEmbedInClientWinFolder"; Null:C1517; \
		"DatabaseToEmbedInClientMacFolder"; Null:C1517; \
		"IsOEM"; False:C215))
	
	$_BuildApp.Versioning:=New object:C1471(\
		"Common"; New object:C1471(\
		"CommonVersion"; Null:C1517; \
		"CommonCopyright"; Null:C1517; \
		"CommonCreator"; Null:C1517; \
		"CommonComment"; Null:C1517; \
		"CommonCompanyName"; Null:C1517; \
		"CommonFileDescription"; Null:C1517; \
		"CommonInternalName"; Null:C1517; \
		"CommonLegalTrademark"; Null:C1517; \
		"CommonPrivateBuild"; Null:C1517; \
		"CommonSpecialBuild"; Null:C1517); \
		"RuntimeVL"; New object:C1471(\
		"RuntimeVLVersion"; Null:C1517; \
		"RuntimeVLCopyright"; Null:C1517; \
		"RuntimeVLCreator"; Null:C1517; \
		"RuntimeVLComment"; Null:C1517; \
		"RuntimeVLCompanyName"; Null:C1517; \
		"RuntimeVLFileDescription"; Null:C1517; \
		"RuntimeVLInternalName"; Null:C1517; \
		"RuntimeVLLegalTrademark"; Null:C1517; \
		"RuntimeVLPrivateBuild"; Null:C1517; \
		"RuntimeVLSpecialBuild"; Null:C1517); \
		"Server"; New object:C1471(\
		"ServerVersion"; Null:C1517; \
		"ServerCopyright"; Null:C1517; \
		"ServerCreator"; Null:C1517; \
		"ServerComment"; Null:C1517; \
		"ServerCompanyName"; Null:C1517; \
		"ServerFileDescription"; Null:C1517; \
		"ServerInternalName"; Null:C1517; \
		"ServerLegalTrademark"; Null:C1517; \
		"ServerPrivateBuild"; Null:C1517; \
		"ServerSpecialBuild"; Null:C1517); \
		"Client"; New object:C1471(\
		"ClientVersion"; Null:C1517; \
		"ClientCopyright"; Null:C1517; \
		"ClientCreator"; Null:C1517; \
		"ClientComment"; Null:C1517; \
		"ClientCompanyName"; Null:C1517; \
		"ClientFileDescription"; Null:C1517; \
		"ClientInternalName"; Null:C1517; \
		"ClientLegalTrademark"; Null:C1517; \
		"ClientPrivateBuild"; Null:C1517; \
		"ClientSpecialBuild"; Null:C1517))
	
	$_BuildApp._settingsFile:=$settingsFile
	
	If ($_BuildApp._settingsFile#Null:C1517) && (OB Instance of:C1731($_BuildApp._settingsFile; 4D:C1709.File))
		
		If ($_BuildApp._settingsFile.exists)
			
			$path:=$_BuildApp._settingsFile.platformPath
			
			C_LONGINT:C283($intValue)
			C_TEXT:C284($stringValue)
			C_BOOLEAN:C305($boolValue)
			
			ARRAY TEXT:C222($linkModes; 3)
			$linkModes{1}:="InDbStruct"
			$linkModes{2}:="ByAppName"
			$linkModes{3}:="ByAppPath"
			
			$dom:=DOM Parse XML source:C719($path)
			
			If (OK=1)
				
				$BuildApplicationName:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/BuildApplicationName")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($BuildApplicationName; $stringValue)
					$_BuildApp.BuildApplicationName:=$stringValue
				End if 
				
				$BuildCompiled:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/BuildCompiled")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($BuildCompiled; $boolValue)
					$_BuildApp.BuildCompiled:=$boolValue
				End if 
				
				$IncludeAssociatedFolders:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/IncludeAssociatedFolders")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($IncludeAssociatedFolders; $boolValue)
					$_BuildApp.IncludeAssociatedFolders:=$boolValue
				End if 
				
				$BuildComponent:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/BuildComponent")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($BuildComponent; $boolValue)
					$_BuildApp.BuildComponent:=$boolValue
				End if 
				
				$BuildApplicationSerialized:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/BuildApplicationSerialized")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($BuildApplicationSerialized; $boolValue)
					$_BuildApp.BuildApplicationSerialized:=$boolValue
				End if 
				
				$BuildApplicationLight:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/BuildApplicationLight")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($BuildApplicationLight; $boolValue)
					$_BuildApp.BuildApplicationLight:=$boolValue
				End if 
				
				$BuildMacDestFolder:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/BuildMacDestFolder")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($BuildMacDestFolder; $stringValue)
					$_BuildApp.BuildMacDestFolder:=$stringValue
				End if 
				
				$PackProject:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/PackProject")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($PackProject; $boolValue)
					$_BuildApp.PackProject:=$boolValue
				End if 
				
				$UseStandardZipFormat:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/UseStandardZipFormat")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($UseStandardZipFormat; $boolValue)
					$_BuildApp.UseStandardZipFormat:=$boolValue
				End if 
				
				$BuildWinDestFolder:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/BuildWinDestFolder")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($BuildWinDestFolder; $stringValue)
					$_BuildApp.BuildWinDestFolder:=$stringValue
				End if 
				
				$RuntimeVLIncludeIt:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLIncludeIt")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($RuntimeVLIncludeIt; $boolValue)
					$_BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=$boolValue
				End if 
				
				$RuntimeVLMacFolder:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLMacFolder")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($RuntimeVLMacFolder; $stringValue)
					$_BuildApp.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=$stringValue
				End if 
				
				$RuntimeVLWinFolder:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLWinFolder")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($RuntimeVLWinFolder; $stringValue)
					$_BuildApp.SourcesFiles.RuntimeVL.RuntimeVLWinFolder:=$stringValue
				End if 
				
				$RuntimeVLIconWinPath:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLIconWinPath")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($RuntimeVLIconWinPath; $stringValue)
					$_BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIconWinPath:=$stringValue
				End if 
				
				$RuntimeVLIconMacPath:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/RuntimeVLIconMacPath")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($RuntimeVLIconMacPath; $stringValue)
					$_BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIconMacPath:=$stringValue
				End if 
				
				$IsOEM:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/IsOEM")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($IsOEM; $boolValue)
					$_BuildApp.SourcesFiles.RuntimeVL.IsOEM:=$boolValue
				End if 
				
				$IsOEM:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/RuntimeVL/IsOEM")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($IsOEM; $boolValue)
					$_BuildApp.SourcesFiles.RuntimeVL.IsOEM:=$boolValue
				End if 
				
				$ServerIncludeIt:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerIncludeIt")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ServerIncludeIt; $boolValue)
					$_BuildApp.SourcesFiles.CS.ServerIncludeIt:=$boolValue
				End if 
				
				$ClientMacIncludeIt:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacIncludeIt")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ClientMacIncludeIt; $boolValue)
					$_BuildApp.SourcesFiles.CS.ClientMacIncludeIt:=$boolValue
				End if 
				
				$ClientWinIncludeIt:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinIncludeIt")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ClientWinIncludeIt; $boolValue)
					$_BuildApp.SourcesFiles.CS.ClientWinIncludeIt:=$boolValue
				End if 
				
				$ServerMacFolder:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerMacFolder")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ServerMacFolder; $stringValue)
					$_BuildApp.SourcesFiles.CS.ServerMacFolder:=$stringValue
				End if 
				
				$ServerWinFolder:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerWinFolder")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ServerWinFolder; $stringValue)
					$_BuildApp.SourcesFiles.CS.ServerWinFolder:=$stringValue
				End if 
				
				$ClientWinFolderToWin:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinFolderToWin")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ClientWinFolderToWin; $stringValue)
					$_BuildApp.SourcesFiles.CS.ClientWinFolderToWin:=$stringValue
				End if 
				
				$ClientWinFolderToMac:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinFolderToMac")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ClientWinFolderToMac; $stringValue)
					$_BuildApp.SourcesFiles.CS.ClientWinFolderToMac:=$stringValue
				End if 
				
				$ClientMacFolderToWin:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacFolderToWin")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ClientMacFolderToWin; $stringValue)
					$_BuildApp.SourcesFiles.CS.ClientMacFolderToWin:=$stringValue
				End if 
				
				$ClientMacFolderToMac:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacFolderToMac")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ClientMacFolderToMac; $stringValue)
					$_BuildApp.SourcesFiles.CS.ClientMacFolderToMac:=$stringValue
				End if 
				
				$ServerIconWinPath:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerIconWinPath")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ServerIconWinPath; $stringValue)
					$_BuildApp.SourcesFiles.CS.ServerIconWinPath:=$stringValue
				End if 
				
				$ServerIconMacPath:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ServerIconMacPath")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ServerIconMacPath; $stringValue)
					$_BuildApp.SourcesFiles.CS.ServerIconMacPath:=$stringValue
				End if 
				
				$ClientMacIconForMacPath:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacIconForMacPath")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ClientMacIconForMacPath; $stringValue)
					$_BuildApp.SourcesFiles.CS.ClientMacIconForMacPath:=$stringValue
				End if 
				
				$ClientWinIconForMacPath:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinIconForMacPath")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ClientWinIconForMacPath; $stringValue)
					$_BuildApp.SourcesFiles.CS.ClientWinIconForMacPath:=$stringValue
				End if 
				
				$ClientMacIconForWinPath:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientMacIconForWinPath")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ClientMacIconForWinPath; $stringValue)
					$_BuildApp.SourcesFiles.CS.ClientMacIconForWinPath:=$stringValue
				End if 
				
				$ClientWinIconForWinPath:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/ClientWinIconForWinPath")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ClientWinIconForWinPath; $stringValue)
					$_BuildApp.SourcesFiles.CS.ClientWinIconForWinPath:=$stringValue
				End if 
				
				$ToEmbedInClientMacFolder:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/DatabaseToEmbedInClientMacFolder")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ToEmbedInClientMacFolder; $stringValue)
					$_BuildApp.SourcesFiles.CS.DatabaseToEmbedInClientMacFolder:=$stringValue
				End if 
				
				$ToEmbedInClientWinFolder:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/DatabaseToEmbedInClientWinFolder")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ToEmbedInClientWinFolder; $stringValue)
					$_BuildApp.SourcesFiles.CS.DatabaseToEmbedInClientWinFolder:=$stringValue
				End if 
				
				$IsOEM:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SourcesFiles/CS/IsOEM")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($IsOEM; $boolValue)
					$_BuildApp.SourcesFiles.RuntimeVL.IsOEM:=$boolValue
				End if 
				
				$BuildServerApplication:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/BuildServerApplication")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($BuildServerApplication; $boolValue)
					$_BuildApp.CS.BuildServerApplication:=$boolValue
				End if 
				
				$LastDataPathLookup:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/LastDataPathLookup")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($LastDataPathLookup; $stringValue)
					If (Find in array:C230($linkModes; $stringValue)#-1)
						$_BuildApp.CS.LastDataPathLookup:=$stringValue
					End if 
				End if 
				
				$BuildCSUpgradeable:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/BuildCSUpgradeable")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($BuildCSUpgradeable; $boolValue)
					$_BuildApp.CS.BuildCSUpgradeable:=$boolValue
				End if 
				
				$CurrentVers:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/CurrentVers")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($CurrentVers; $intValue)
					If ($intValue>0)
						$_BuildApp.CS.CurrentVers:=$intValue
					End if 
				End if 
				
				$HardLink:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/HardLink")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($HardLink; $stringValue)
					$_BuildApp.CS.HardLink:=$stringValue
				End if 
				
				$BuildV13ClientUpgrades:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/BuildV13ClientUpgrades")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($BuildV13ClientUpgrades; $boolValue)
					$_BuildApp.CS.BuildV13ClientUpgrades:=$boolValue
				End if 
				
				$IPAddress:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/IPAddress")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($IPAddress; $stringValue)
					$_BuildApp.CS.IPAddress:=$stringValue
				End if 
				
				$PortNumber:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/PortNumber")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($PortNumber; $intValue)
					If ($intValue#0)
						$_BuildApp.CS.PortNumber:=$intValue
					End if 
				End if 
				
				$RangeVersMin:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/RangeVersMin")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($RangeVersMin; $intValue)
					If ($intValue>0)
						$_BuildApp.CS.RangeVersMin:=$intValue
					End if 
				End if 
				
				$RangeVersMax:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/RangeVersMax")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($RangeVersMax; $intValue)
					If ($intValue>0)
						$_BuildApp.CS.RangeVersMax:=$intValue
					End if 
				End if 
				
				$ServerSelectionAllowed:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/ServerSelectionAllowed")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($ServerSelectionAllowed; $boolValue)
					$_BuildApp.CS.ServerSelectionAllowed:=$boolValue
				End if 
				
				$MacCompiledDatabaseToWin:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/MacCompiledDatabaseToWin")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($MacCompiledDatabaseToWin; $stringValue)
					$_BuildApp.CS.MacCompiledDatabaseToWin:=$stringValue
				End if 
				
				$MacCompiledDatabaseToWinInclude:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/CS/MacCompiledDatabaseToWinIncludeIt")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($MacCompiledDatabaseToWinInclude; $boolValue)
					$_BuildApp.CS.MacCompiledDatabaseToWinIncludeIt:=$boolValue
				End if 
				
				$MacSignature:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SignApplication/MacSignature")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($MacSignature; $boolValue)
					$_BuildApp.SignApplication.MacSignature:=$boolValue
				End if 
				
				$MacCertificate:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SignApplication/MacCertificate")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($MacCertificate; $stringValue)
					$_BuildApp.SignApplication.MacCertificate:=$stringValue
				End if 
				
				$AdHocSign:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/SignApplication/AdHocSign")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($AdHocSign; $boolValue)
					$_BuildApp.SignApplication.AdHocSign:=$boolValue
				End if 
				
				$LastDataPathLookup:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/RuntimeVL/LastDataPathLookup")
				
				If (OK=1)
					DOM GET XML ELEMENT VALUE:C731($LastDataPathLookup; $stringValue)
					If (Find in array:C230($linkModes; $stringValue)#-1)
						$_BuildApp.RuntimeVL.LastDataPathLookup:=$stringValue
					End if 
				End if 
				
				ARRAY TEXT:C222($names; 0)
				OB GET PROPERTY NAMES:C1232($_BuildApp.Licenses; $names)
				
				For ($i; 1; Size of array:C274($names))
					$name:=$names{$i}
					$ItemsCount:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/Licenses/"+$name+"/ItemsCount")
					If (OK=1)
						DOM GET XML ELEMENT VALUE:C731($ItemsCount; $intValue)
						ARRAY OBJECT:C1221($DatabaseNames; $intValue)
						//$_BuildApp.Licenses[$name].ItemsCount:=$intValue
						$Item:=DOM Get next sibling XML element:C724($ItemsCount)
						For ($j; 0; $intValue-1)  //0 based index
							DOM GET XML ELEMENT VALUE:C731($Item; $stringValue)
							$_BuildApp.Licenses[$name].Item[$j]:=Choose:C955($stringValue=""; Null:C1517; $stringValue)
							$Item:=DOM Get next sibling XML element:C724($Item)
						End for 
					End if 
				End for 
				
				ARRAY TEXT:C222($names; 3)
				
				$names{1}:="ArrayExcludedPluginName"
				$names{2}:="ArrayExcludedPluginID"
				$names{3}:="ArrayExcludedComponentName"
				
				For ($i; 1; Size of array:C274($names))
					$name:=$names{$i}
					$ItemsCount:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/"+$name+"/ItemsCount")
					If (OK=1)
						DOM GET XML ELEMENT VALUE:C731($ItemsCount; $intValue)
						ARRAY OBJECT:C1221($DatabaseNames; $intValue)
						$Item:=DOM Get next sibling XML element:C724($ItemsCount)
						For ($j; 0; $intValue-1)  //0 based index
							DOM GET XML ELEMENT VALUE:C731($Item; $stringValue)
							$_BuildApp[$name].Item[$j]:=Choose:C955($stringValue=""; Null:C1517; $stringValue)
							$Item:=DOM Get next sibling XML element:C724($Item)
						End for 
					End if 
				End for 
				
				OB GET PROPERTY NAMES:C1232($_BuildApp.Versioning; $names)
				$Versioning:=DOM Find XML element:C864($dom; "/Preferences4D/BuildApp/Versioning")
				
				If (OK=1)
					
					For ($i; 1; Size of array:C274($names))
						$name:=$names{$i}
						$parent:=DOM Find XML element:C864($Versioning; $name)
						ARRAY TEXT:C222($itemNames; 0)
						OB GET PROPERTY NAMES:C1232($_BuildApp.Versioning[$name]; $itemNames)
						For ($j; 1; Size of array:C274($itemNames))
							$itemName:=$itemNames{$j}
							$child:=DOM Find XML element:C864($parent; $itemName)
							If (OK=1)
								DOM GET XML ELEMENT VALUE:C731($child; $stringValue)
								$_BuildApp.Versioning[$name][$itemName]:=$stringValue
							End if 
							
						End for 
						
					End for 
					
				End if 
				
				DOM CLOSE XML:C722($dom)
				
			End if 
			
		End if 
		
	End if 
	
	$BuildApp._settings:=$_BuildApp
	
	For each ($setting; $BuildApp._settings)
		$BuildApp[$setting]:=$BuildApp._settings[$setting]
	End for each 
	
	//MARK:-private methods
	
Function _desktopLicenses()->$licenses : Collection
	
	$licenses:=New collection:C1472("4UOE"; "4UUD")
	
/*
4UOE:Desktop
4UOE:OEM Desktop
4DDP:Developer
4DOE:OEM Developer
*/
	
Function _getDefaultSettingsFile()->$settingsFile : 4D:C1709.File
	
	var $build_settingsFilePath : Text
	
	$build_settingsFilePath:=Get 4D file:C1418(Build application settings file:K5:60; *)
	
	If ($build_settingsFilePath#"")
		var $file : 4D:C1709.File
		$file:=File:C1566($build_settingsFilePath; fk platform path:K87:2)
		If ($file.exists)
			$settingsFile:=$file
		End if 
	End if 
	
Function _refresh($settingsFile : 4D:C1709.File)
	
	This:C1470.parseFile($settingsFile)
	
Function _serverLicenses()->$licenses : Collection
	
	$licenses:=New collection:C1472("4UOE"; "4UUD"; "4UOS"; "4DOM")
	
/*
4UOE:Desktop
4UOE:OEM Desktop
4DDP:Developer
4DOE:OEM Developer
4DTD:Team Developer
4DOT:OEM Team Developer
4USE:Server
4UOS:OEM Server
4DOM:OEM XML Keys
*/
	