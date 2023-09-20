//%attributes = {}
#DECLARE($BuildApp : cs:C1710.BuildApp)

If (Count parameters:C259=0)
	
	$BuildApp:=cs:C1710.BuildApp.new()
	
	$BuildApp.BuildApplicationName:="TEST"
	$BuildApp.BuildMacDestFolder:=System folder:C487(Desktop:K41:16)
	
	$BuildApp.BuildCompiled:=False:C215
	$BuildApp.IncludeAssociatedFolders:=True:C214
	$BuildApp.BuildComponent:=False:C215
	$BuildApp.BuildApplicationSerialized:=True:C214
	$BuildApp.BuildApplicationLight:=False:C215
	$BuildApp.UseStandardZipFormat:=False:C215
	$BuildApp.PackProject:=False:C215
	$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=True:C214
	$BuildApp.SourcesFiles.RuntimeVL.IsOEM:=True:C214
	
	$BuildApp.CS.ServerSelectionAllowed:=True:C214
	$BuildApp.CS.ClientWinSingleInstance:=True:C214
	$BuildApp.CS.ClientUserPreferencesFolderByPath:=True:C214
	$BuildApp.CS.HideDataExplorerMenuItem:=True:C214
	$BuildApp.CS.HideRuntimeExplorerMenuItem:=True:C214
	$BuildApp.CS.ServerEmbedsProjectDirectoryFile:=True:C214
	$BuildApp.CS.ServerDataCollection:=True:C214
	$BuildApp.CS.ShareLocalResourcesOnWindowsClient:=False:C215
	$BuildApp.CS.MacCompiledDatabaseToWinIncludeIt:=False:C215
	$BuildApp.CS.HideAdministrationMenuItem:=True:C214
	
	$BuildApp.ArrayExcludedModuleName.Item[0]:="CEF"
	$BuildApp.ArrayExcludedModuleName.Item[1]:="MeCab"
	$BuildApp.ArrayExcludedModuleName.Item[2]:="PHP"
	$BuildApp.ArrayExcludedModuleName.Item[3]:="SpellChecker"
	$BuildApp.ArrayExcludedModuleName.Item[4]:="4D Updater"
	
	//$BuildApp.CS.PortNumber:=19813
	
	$BuildApp.CS.ServerStructureFolderName:=$BuildApp.BuildApplicationName
	$BuildApp.CS.ClientServerSystemFolderName:=$BuildApp.BuildApplicationName
	
	//$BuildApp.CS.DatabaseToEmbedInClientWinFolder:=System folder(Desktop)
	//$BuildApp.CS.DatabaseToEmbedInClientMacFolder:=System folder(Desktop)
	//$BuildApp.CS.MacCompiledDatabaseToWin:=System folder(Desktop)
	
	$BuildApp.RuntimeVL.LastDataPathLookup:="ByAppName"
	$BuildApp.CS.LastDataPathLookup:="ByAppName"
	
	$RuntimeVLMac:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("4D Volume Desktop.app").platformPath
	$RuntimeVLWin:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("4D Volume Desktop").platformPath
	$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=$RuntimeVLMac
	$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLWinFolder:=$RuntimeVLWin
	
	$RuntimeVLIconMac:=Folder:C1567(fk resources folder:K87:11).file("BuildApp.icns").platformPath
	$RuntimeVLIconWin:=Folder:C1567(fk resources folder:K87:11).file("BuildApp.ico").platformPath
	$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIconMacPath:=$RuntimeVLIconMac
	$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIconWinPath:=$RuntimeVLIconWin
	
	$BuildApp.SourcesFiles.CS.ServerIconMacPath:=$RuntimeVLIconMac
	$BuildApp.SourcesFiles.CS.ServerIconWinPath:=$RuntimeVLIconWin
	$BuildApp.SourcesFiles.CS.ClientMacIconForMacPath:=$RuntimeVLIconMac
	$BuildApp.SourcesFiles.CS.ClientWinIconForMacPath:=$RuntimeVLIconWin
	$BuildApp.SourcesFiles.CS.ClientMacIconForWinPath:=$RuntimeVLIconMac
	$BuildApp.SourcesFiles.CS.ClientWinIconForWinPath:=$RuntimeVLIconWin
	
	$ServerMac:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("4D Server.app").platformPath
	$ServerWin:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("4D Server").platformPath
	$BuildApp.SourcesFiles.CS.ServerMacFolder:=$ServerMac
	$BuildApp.SourcesFiles.CS.ServerWinFolder:=$ServerWin
	
	$BuildApp.Versioning.Common.CommonVersion:="1.0.0"
	$BuildApp.Versioning.Common.CommonCopyright:="©︎K.MIYAKO"
	$BuildApp.Versioning.Common.CommonCompanyName:="com.4d.miyako"
	
	$BuildApp["Build"+(Is macOS:C1572 ? "Mac" : "Win")+"DestFolder"]:=Folder:C1567(fk desktop folder:K87:19).platformPath
	
	CALL WORKER:C1389(1; Current method name:C684; $BuildApp)
	
Else 
	
	$form:=New object:C1471
	$form.pages:=New collection:C1472
	$form.pages.push(New object:C1471("page"; 1; "title"; "Application"))
	$form.pages.push(New object:C1471("page"; 2; "title"; "Runtime"))
	$form.pages.push(New object:C1471("page"; 3; "title"; "Server"))
	$form.pages.push(New object:C1471("page"; 4; "title"; "Client"))
	$form.pages.push(New object:C1471("page"; 5; "title"; "Sign"))
	$form.pages.push(New object:C1471("page"; 6; "title"; "Version/Common"))
	$form.pages.push(New object:C1471("page"; 7; "title"; "Version/RuntimeVL"))
	$form.pages.push(New object:C1471("page"; 8; "title"; "Version/Server"))
	$form.pages.push(New object:C1471("page"; 9; "title"; "Version/Client"))
	
	setup_destination_path($BuildApp; $form; "BuildDest")
	
	setup_data_path_lookup($BuildApp; $form; "RuntimeVL")
	setup_data_path_lookup($BuildApp; $form; "CS")
	
	$form["RuntimeVLIcon"]:=setup_icon_path($BuildApp; $form; "RuntimeVL")
	$form["RuntimeVLApplicationIcon"]:=setup_application_path($BuildApp; $form; "RuntimeVL")
	
	$form.Server:=New object:C1471
	$form["ServerIcon"]:=setup_icon_path($BuildApp; $form; "Server")
	$form["ServerApplicationIcon"]:=setup_application_path($BuildApp; $form; "Server")
	
	$form.ClientMac:=New object:C1471
	$form["ClientMacIcon"]:=setup_icon_path($BuildApp; $form; "ClientMac")
	
	$form.ClientWin:=New object:C1471
	$form["ClientWinIcon"]:=setup_icon_path($BuildApp; $form; "ClientWin")
	
	$form.DatabaseToEmbedInClientMac:=New object:C1471
	$form["DatabaseToEmbedInClientMacApplicationIcon"]:=setup_application_path($BuildApp; $form; "DatabaseToEmbedInClientMac")
	
	$form.DatabaseToEmbedInClientWin:=New object:C1471
	$form["DatabaseToEmbedInClientWinApplicationIcon"]:=setup_application_path($BuildApp; $form; "DatabaseToEmbedInClientWin")
	
	$form.MacCompiledDatabaseToWin:=New object:C1471
	$form["MacCompiledDatabaseToWinApplicationIcon"]:=setup_application_path($BuildApp; $form; "MacCompiledDatabaseToWin")
	
	$form.ExcludeCEF:=$BuildApp.ArrayExcludedModuleName.Item.includes("CEF")
	$form.ExcludeMeCab:=$BuildApp.ArrayExcludedModuleName.Item.includes("MeCab")
	$form.ExcludePHP:=$BuildApp.ArrayExcludedModuleName.Item.includes("PHP")
	$form.ExcludeSpellChecker:=$BuildApp.ArrayExcludedModuleName.Item.includes("SpellChecker")
	$form.ExcludeUpdater:=$BuildApp.ArrayExcludedModuleName.Item.includes("4D Updater")
	
	$form.BuildApp:=$BuildApp
	
	$window:=Open form window:C675("TEST-BuildApp")
	DIALOG:C40("TEST-BuildApp"; $form; *)
	
End if 