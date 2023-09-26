//%attributes = {"invisible":true}
$name:="BuildApp-"+Replace string:C233(String:C10(Current date:C33; ISO date:K1:8; Current time:C178); ":"; "-"; *)

$buildProject:=File:C1566(File:C1566("/LOGS/"+$name+".4DSettings").platformPath; fk platform path:K87:2)

$BuildApp:=cs:C1710.BuildApp.new()

$BuildApp.BuildApplicationName:="TEST"
$BuildApp.BuildMacDestFolder:=System folder:C487(Desktop:K41:16)

$BuildApp.BuildCompiled:=False:C215
$BuildApp.IncludeAssociatedFolders:=True:C214
$BuildApp.BuildComponent:=False:C215
$BuildApp.BuildApplicationSerialized:=True:C214
$BuildApp.PackProject:=True:C214
$BuildApp.UseStandardZipFormat:=True:C214

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

$BuildApp.AutoUpdate.RuntimeVL.StartElevated:=True:C214
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

$path:=demo_certificate_path($BuildApp)

If ($path#"")
	$BuildApp.SignApplication.AdHocSign:=False:C215
	$BuildApp.SignApplication.MacSignature:=True:C214
	$BuildApp.SignApplication.MacCertificate:=$path
Else 
	$BuildApp.SignApplication.AdHocSign:=True:C214
	$BuildApp.SignApplication.MacSignature:=False:C215
	$BuildApp.SignApplication.MacCertificate:=""
End if 

If (Is macOS:C1572)
	$BuildApp.CS.DatabaseToEmbedInClientMacFolder:=demo_startup_project_path
Else 
	$BuildApp.CS.DatabaseToEmbedInClientWinFolder:=demo_startup_project_path
End if 

$BuildApp.CS.MacCompiledDatabaseToWin:=demo_compiled_mac_project

$BuildApp.RuntimeVL.LastDataPathLookup:="ByAppName"
$BuildApp.CS.LastDataPathLookup:="ByAppName"

If (Is macOS:C1572)
	$RuntimeVLMac:=demo_runtimevl_path
	$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=$RuntimeVLMac
Else 
	$RuntimeVLWin:=demo_runtimevl_path
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
	$ServerMac:=demo_server_path
Else 
	$ServerWin:=demo_server_path
End if 

$BuildApp.SourcesFiles.CS.ServerMacFolder:=$ServerMac
$BuildApp.SourcesFiles.CS.ServerWinFolder:=$ServerWin

$BuildApp.Versioning.Common.CommonVersion:="1.0.0"
$BuildApp.Versioning.Common.CommonCopyright:="©︎K.MIYAKO"
$BuildApp.Versioning.Common.CommonCompanyName:="com.4d.miyako"

$BuildApp["Build"+(Is macOS:C1572 ? "Mac" : "Win")+"DestFolder"]:=Folder:C1567(fk desktop folder:K87:19).platformPath

$BuildApp.toFile($buildProject)

$CLI:=cs:C1710._Terminal.new()

$compileProject:=File:C1566(Structure file:C489; fk platform path:K87:2).parent.parent.parent.folder("example").folder("Project").file("example.4DProject")

$CLI.launch($buildProject; $compileProject)
