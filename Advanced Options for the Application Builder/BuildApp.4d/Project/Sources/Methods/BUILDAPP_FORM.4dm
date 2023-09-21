//%attributes = {}
#DECLARE($BuildApp : cs:C1710.BuildApp; $compileProject : 4D:C1709.File)

Case of 
	: (Count parameters:C259=0)
		
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
		//$BuildApp.CS.HideAdministrationMenuItem:=True
		
		$BuildApp.PackProject:=True:C214
		$BuildApp.UseStandardZipFormat:=True:C214
		
		$BuildApp.SignApplication.AdHocSign:=True:C214
		
		$BuildApp.AutoUpdate.RuntimeVL.StartElevated:=True:C214
		$BuildApp.AutoUpdate.CS.ClientUpdateWin.StartElevated:=True:C214
		$BuildApp.AutoUpdate.CS.Client.StartElevated:=True:C214
		$BuildApp.AutoUpdate.CS.Server.StartElevated:=True:C214
		
		$BuildApp.ArrayExcludedModuleName.Item[0]:="CEF"
		$BuildApp.ArrayExcludedModuleName.Item[1]:="MeCab"
		$BuildApp.ArrayExcludedModuleName.Item[2]:="PHP"
		$BuildApp.ArrayExcludedModuleName.Item[3]:="SpellChecker"
		$BuildApp.ArrayExcludedModuleName.Item[4]:="4D Updater"
		
		$BuildApp.ArrayExcludedComponentName.Item[0]:="4D SVG"
		$BuildApp.ArrayExcludedComponentName.Item[1]:="4D Progress"
		$BuildApp.ArrayExcludedComponentName.Item[2]:="4D ViewPro"
		$BuildApp.ArrayExcludedComponentName.Item[3]:="4D NetKit"
		$BuildApp.ArrayExcludedComponentName.Item[5]:="4D WritePro Interface"
		$BuildApp.ArrayExcludedComponentName.Item[6]:="4D Widgets"
		
		//$BuildApp.CS.DatabaseToEmbedInClientWinFolder:=System folder(Desktop)
		//$BuildApp.CS.DatabaseToEmbedInClientMacFolder:=System folder(Desktop)
		//$BuildApp.CS.MacCompiledDatabaseToWin:=System folder(Desktop)
		
		$BuildApp.RuntimeVL.LastDataPathLookup:="ByAppName"
		$BuildApp.CS.LastDataPathLookup:="ByAppName"
		
		If (Is macOS:C1572)
			$RuntimeVLMac:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("4D Volume Desktop.app").platformPath
			$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=$RuntimeVLMac
		Else 
			$RuntimeVLWin:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("4D Volume Desktop").platformPath
			$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLWinFolder:=$RuntimeVLWin
		End if 
		
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
		
		If (Is macOS:C1572)
			$ServerMac:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("4D Server.app").platformPath
		Else 
			$ServerWin:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("4D Server").platformPath
		End if 
		
		$BuildApp.SourcesFiles.CS.ServerMacFolder:=$ServerMac
		$BuildApp.SourcesFiles.CS.ServerWinFolder:=$ServerWin
		
		$BuildApp.Versioning.Common.CommonVersion:="1.0.0"
		$BuildApp.Versioning.Common.CommonCopyright:="©︎K.MIYAKO"
		$BuildApp.Versioning.Common.CommonCompanyName:="com.4d.miyako"
		
		$BuildApp["Build"+(Is macOS:C1572 ? "Mac" : "Win")+"DestFolder"]:=Folder:C1567(fk desktop folder:K87:19).platformPath
		
		$compileProject:=File:C1566(Structure file:C489; fk platform path:K87:2).parent.parent.parent.folder("example").folder("Project").file("example.4DProject")
		
		CALL WORKER:C1389(1; Current method name:C684; $BuildApp; $compileProject)
		
	: (Count parameters:C259=2)
		
		$form:=New object:C1471
		
		$form.compileProject:=$compileProject
		
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
		
		setup_plugins_list($BuildApp; $form)
		setup_components_list($BuildApp; $form)
		setup_destination_path($BuildApp; $form; "BuildDest")
		setup_data_path_lookup($BuildApp; $form; "RuntimeVL")
		setup_data_path_lookup($BuildApp; $form; "CS")
		
		//inputs:1
		$BuildApp.BuildApplicationName:=$BuildApp.BuildApplicationName=Null:C1517 ? "" : $BuildApp.BuildApplicationName
		//inputs:2
		$BuildApp.CS.HardLink:=$BuildApp.CS.HardLink=Null:C1517 ? "" : $BuildApp.CS.HardLink
		$BuildApp.CS.IPAddress:=$BuildApp.CS.IPAddress=Null:C1517 ? "" : $BuildApp.CS.IPAddress
		$BuildApp.CS.PortNumber:=$BuildApp.CS.PortNumber=Null:C1517 ? "" : $BuildApp.CS.PortNumber
		$BuildApp.CS.ServerStructureFolderName:=$BuildApp.CS.ServerStructureFolderName=Null:C1517 ? "" : $BuildApp.CS.ServerStructureFolderName
		$BuildApp.CS.ClientServerSystemFolderName:=$BuildApp.CS.ClientServerSystemFolderName=Null:C1517 ? "" : $BuildApp.CS.ClientServerSystemFolderName
		
		//inputs:3
		$BuildApp.CS.CurrentVers:=$BuildApp.CS.CurrentVers=Null:C1517 ? "" : $BuildApp.CS.CurrentVers
		$BuildApp.CS.RangeVersMin:=$BuildApp.CS.RangeVersMin=Null:C1517 ? "" : $BuildApp.CS.RangeVersMin
		$BuildApp.CS.RangeVersMax:=$BuildApp.CS.RangeVersMax=Null:C1517 ? "" : $BuildApp.CS.RangeVersMax
		//inputs:4
		$BuildApp.SignApplication.MacCertificate:=$BuildApp.SignApplication.MacCertificate=Null:C1517 ? "" : $BuildApp.SignApplication.MacCertificate
		
		//inputs:5
		$BuildApp.Versioning.Common.CommonVersion:=$BuildApp.Versioning.Common.CommonVersion=Null:C1517 ? "" : $BuildApp.Versioning.Common.CommonVersion
		$BuildApp.Versioning.Common.CommonCopyright:=$BuildApp.Versioning.Common.CommonCopyright=Null:C1517 ? "" : $BuildApp.Versioning.Common.CommonCopyright
		$BuildApp.Versioning.Common.CommonCreator:=$BuildApp.Versioning.Common.CommonCreator=Null:C1517 ? "" : $BuildApp.Versioning.Common.CommonCreator
		$BuildApp.Versioning.Common.CommonComment:=$BuildApp.Versioning.Common.CommonComment=Null:C1517 ? "" : $BuildApp.Versioning.Common.CommonComment
		$BuildApp.Versioning.Common.CommonCompanyName:=$BuildApp.Versioning.Common.CommonCompanyName=Null:C1517 ? "" : $BuildApp.Versioning.Common.CommonCompanyName
		$BuildApp.Versioning.Common.CommonFileDescription:=$BuildApp.Versioning.Common.CommonFileDescription=Null:C1517 ? "" : $BuildApp.Versioning.Common.CommonFileDescription
		$BuildApp.Versioning.Common.CommonInternalName:=$BuildApp.Versioning.Common.CommonInternalName=Null:C1517 ? "" : $BuildApp.Versioning.Common.CommonInternalName
		$BuildApp.Versioning.Common.CommonLegalTrademark:=$BuildApp.Versioning.Common.CommonLegalTrademark=Null:C1517 ? "" : $BuildApp.Versioning.Common.CommonLegalTrademark
		$BuildApp.Versioning.Common.CommonPrivateBuild:=$BuildApp.Versioning.Common.CommonPrivateBuild=Null:C1517 ? "" : $BuildApp.Versioning.Common.CommonPrivateBuild
		$BuildApp.Versioning.Common.CommonSpecialBuild:=$BuildApp.Versioning.Common.CommonSpecialBuild=Null:C1517 ? "" : $BuildApp.Versioning.Common.CommonSpecialBuild
		
		//inputs:6
		$BuildApp.Versioning.RuntimeVL.RuntimeVLVersion:=$BuildApp.Versioning.RuntimeVL.RuntimeVLVersion=Null:C1517 ? "" : $BuildApp.Versioning.RuntimeVL.RuntimeVLVersion
		$BuildApp.Versioning.RuntimeVL.RuntimeVLCopyright:=$BuildApp.Versioning.RuntimeVL.RuntimeVLCopyright=Null:C1517 ? "" : $BuildApp.Versioning.RuntimeVL.RuntimeVLCopyright
		$BuildApp.Versioning.RuntimeVL.RuntimeVLCreator:=$BuildApp.Versioning.RuntimeVL.RuntimeVLCreator=Null:C1517 ? "" : $BuildApp.Versioning.RuntimeVL.RuntimeVLCreator
		$BuildApp.Versioning.RuntimeVL.RuntimeVLComment:=$BuildApp.Versioning.RuntimeVL.RuntimeVLComment=Null:C1517 ? "" : $BuildApp.Versioning.RuntimeVL.RuntimeVLComment
		$BuildApp.Versioning.RuntimeVL.RuntimeVLCompanyName:=$BuildApp.Versioning.RuntimeVL.RuntimeVLCompanyName=Null:C1517 ? "" : $BuildApp.Versioning.RuntimeVL.RuntimeVLCompanyName
		$BuildApp.Versioning.RuntimeVL.RuntimeVLFileDescription:=$BuildApp.Versioning.RuntimeVL.RuntimeVLFileDescription=Null:C1517 ? "" : $BuildApp.Versioning.RuntimeVL.RuntimeVLFileDescription
		$BuildApp.Versioning.RuntimeVL.RuntimeVLInternalName:=$BuildApp.Versioning.RuntimeVL.RuntimeVLInternalName=Null:C1517 ? "" : $BuildApp.Versioning.RuntimeVL.RuntimeVLInternalName
		$BuildApp.Versioning.RuntimeVL.RuntimeVLLegalTrademark:=$BuildApp.Versioning.RuntimeVL.RuntimeVLLegalTrademark=Null:C1517 ? "" : $BuildApp.Versioning.RuntimeVL.RuntimeVLLegalTrademark
		$BuildApp.Versioning.RuntimeVL.RuntimeVLPrivateBuild:=$BuildApp.Versioning.RuntimeVL.RuntimeVLPrivateBuild=Null:C1517 ? "" : $BuildApp.Versioning.RuntimeVL.RuntimeVLPrivateBuild
		$BuildApp.Versioning.RuntimeVL.RuntimeVLSpecialBuild:=$BuildApp.Versioning.RuntimeVL.RuntimeVLSpecialBuild=Null:C1517 ? "" : $BuildApp.Versioning.RuntimeVL.RuntimeVLSpecialBuild
		
		//inputs:7
		$BuildApp.Versioning.Server.ServerVersion:=$BuildApp.Versioning.Server.ServerVersion=Null:C1517 ? "" : $BuildApp.Versioning.Server.ServerVersion
		$BuildApp.Versioning.Server.ServerCopyright:=$BuildApp.Versioning.Server.ServerCopyright=Null:C1517 ? "" : $BuildApp.Versioning.Server.ServerCopyright
		$BuildApp.Versioning.Server.ServerCreator:=$BuildApp.Versioning.Server.ServerCreator=Null:C1517 ? "" : $BuildApp.Versioning.Server.ServerCreator
		$BuildApp.Versioning.Server.ServerComment:=$BuildApp.Versioning.Server.ServerComment=Null:C1517 ? "" : $BuildApp.Versioning.Server.ServerComment
		$BuildApp.Versioning.Server.ServerCompanyName:=$BuildApp.Versioning.Server.ServerCompanyName=Null:C1517 ? "" : $BuildApp.Versioning.Server.ServerCompanyName
		$BuildApp.Versioning.Server.ServerFileDescription:=$BuildApp.Versioning.Server.ServerFileDescription=Null:C1517 ? "" : $BuildApp.Versioning.Server.ServerFileDescription
		$BuildApp.Versioning.Server.ServerInternalName:=$BuildApp.Versioning.Server.ServerInternalName=Null:C1517 ? "" : $BuildApp.Versioning.Server.ServerInternalName
		$BuildApp.Versioning.Server.ServerLegalTrademark:=$BuildApp.Versioning.Server.ServerLegalTrademark=Null:C1517 ? "" : $BuildApp.Versioning.Server.ServerLegalTrademark
		$BuildApp.Versioning.Server.ServerPrivateBuild:=$BuildApp.Versioning.Server.ServerPrivateBuild=Null:C1517 ? "" : $BuildApp.Versioning.Server.ServerPrivateBuild
		$BuildApp.Versioning.Server.ServerSpecialBuild:=$BuildApp.Versioning.Server.ServerSpecialBuild=Null:C1517 ? "" : $BuildApp.Versioning.Server.ServerSpecialBuild
		
		//inputs:8
		$BuildApp.Versioning.Client.ServerVersion:=$BuildApp.Versioning.Client.ServerVersion=Null:C1517 ? "" : $BuildApp.Versioning.Client.ServerVersion
		$BuildApp.Versioning.Client.ServerCopyright:=$BuildApp.Versioning.Client.ServerCopyright=Null:C1517 ? "" : $BuildApp.Versioning.Client.ServerCopyright
		$BuildApp.Versioning.Client.ServerCreator:=$BuildApp.Versioning.Client.ServerCreator=Null:C1517 ? "" : $BuildApp.Versioning.Client.ServerCreator
		$BuildApp.Versioning.Client.ServerComment:=$BuildApp.Versioning.Client.ServerComment=Null:C1517 ? "" : $BuildApp.Versioning.Client.ServerComment
		$BuildApp.Versioning.Client.ServerCompanyName:=$BuildApp.Versioning.Client.ServerCompanyName=Null:C1517 ? "" : $BuildApp.Versioning.Client.ServerCompanyName
		$BuildApp.Versioning.Client.ServerFileDescription:=$BuildApp.Versioning.Client.ServerFileDescription=Null:C1517 ? "" : $BuildApp.Versioning.Client.ServerFileDescription
		$BuildApp.Versioning.Client.ServerInternalName:=$BuildApp.Versioning.Client.ServerInternalName=Null:C1517 ? "" : $BuildApp.Versioning.Client.ServerInternalName
		$BuildApp.Versioning.Client.ServerLegalTrademark:=$BuildApp.Versioning.Client.ServerLegalTrademark=Null:C1517 ? "" : $BuildApp.Versioning.Client.ServerLegalTrademark
		$BuildApp.Versioning.Client.ServerPrivateBuild:=$BuildApp.Versioning.Client.ServerPrivateBuild=Null:C1517 ? "" : $BuildApp.Versioning.Client.ServerPrivateBuild
		$BuildApp.Versioning.Client.ServerSpecialBuild:=$BuildApp.Versioning.Client.ServerSpecialBuild=Null:C1517 ? "" : $BuildApp.Versioning.Client.ServerSpecialBuild
		
		//inputs:9
		$BuildApp.Versioning.Client.ClientVersion:=$BuildApp.Versioning.Client.ClientVersion=Null:C1517 ? "" : $BuildApp.Versioning.Client.ClientVersion
		$BuildApp.Versioning.Client.ClientCopyright:=$BuildApp.Versioning.Client.ClientCopyright=Null:C1517 ? "" : $BuildApp.Versioning.Client.ClientCopyright
		$BuildApp.Versioning.Client.ClientCreator:=$BuildApp.Versioning.Client.ClientCreator=Null:C1517 ? "" : $BuildApp.Versioning.Client.ClientCreator
		$BuildApp.Versioning.Client.ClientComment:=$BuildApp.Versioning.Client.ClientComment=Null:C1517 ? "" : $BuildApp.Versioning.Client.ClientComment
		$BuildApp.Versioning.Client.ClientCompanyName:=$BuildApp.Versioning.Client.ClientCompanyName=Null:C1517 ? "" : $BuildApp.Versioning.Client.ClientCompanyName
		$BuildApp.Versioning.Client.ClientFileDescription:=$BuildApp.Versioning.Client.ClientFileDescription=Null:C1517 ? "" : $BuildApp.Versioning.Client.ClientFileDescription
		$BuildApp.Versioning.Client.ClientInternalName:=$BuildApp.Versioning.Client.ClientInternalName=Null:C1517 ? "" : $BuildApp.Versioning.Client.ClientInternalName
		$BuildApp.Versioning.Client.ClientLegalTrademark:=$BuildApp.Versioning.Client.ClientLegalTrademark=Null:C1517 ? "" : $BuildApp.Versioning.Client.ClientLegalTrademark
		$BuildApp.Versioning.Client.ClientPrivateBuild:=$BuildApp.Versioning.Client.ClientPrivateBuild=Null:C1517 ? "" : $BuildApp.Versioning.Client.ClientPrivateBuild
		$BuildApp.Versioning.Client.ClientSpecialBuild:=$BuildApp.Versioning.Client.ClientSpecialBuild=Null:C1517 ? "" : $BuildApp.Versioning.Client.ClientSpecialBuild
		
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
		
End case 