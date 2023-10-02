//%attributes = {"invisible":true}
var $BuildApp : cs:C1710.BuildApp

$BuildApp:=cs:C1710.BuildApp.new()

$BuildApp.BuildApplicationName:="TEST"
$BuildApp.BuildMacDestFolder:=System folder:C487(Desktop:K41:16)

$BuildApp.SourcesFiles.CS.ServerIncludeIt:=True:C214
$BuildApp.SourcesFiles.CS.ServerMacFolder:=demo_server_path
$BuildApp.SourcesFiles.CS.ClientMacIncludeIt:=True:C214
$BuildApp.SourcesFiles.CS.ClientMacFolderToMac:=demo_runtimevl_path

$BuildApp.Versioning.Common.CommonVersion:="1.0.0"

$BuildApp.CS.BuildServerApplication:=True:C214
$BuildApp.CS.ServerStructureFolderName:="GEORGIA"
$BuildApp.CS.ClientServerSystemFolderName:="ATLANTA"

$name:="BuildApp-"+Replace string:C233(String:C10(Current date:C33; ISO date:K1:8; Current time:C178); ":"; "-"; *)

$buildProject:=File:C1566(File:C1566("/LOGS/"+$name+".4DSettings").platformPath; fk platform path:K87:2)

$BuildApp.findLicenses().toFile($buildProject)

BUILD APPLICATION:C871($buildProject.platformPath)