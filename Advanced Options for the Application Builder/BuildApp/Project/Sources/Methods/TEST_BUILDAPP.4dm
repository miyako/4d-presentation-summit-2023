//%attributes = {}
var $BuildApp : cs:C1710.BuildApp

$BuildApp:=cs:C1710.BuildApp.new()

$BuildApp.BuildApplicationName:="TEST"
$BuildApp.BuildMacDestFolder:=System folder:C487(Desktop:K41:16)
$BuildApp.BuildApplicationSerialized:=True:C214

$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=True:C214
$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=demo_runtimevl_path
$BuildApp.Versioning.Common.CommonVersion:="1.0.0"
$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIconMacPath:=Folder:C1567(fk resources folder:K87:11).file("BuildApp.icns").platformPath

$name:="BuildApp-"+Replace string:C233(String:C10(Current date:C33; ISO date:K1:8; Current time:C178); ":"; "-"; *)

$buildProject:=File:C1566(File:C1566("/LOGS/"+$name+".4DSettings").platformPath; fk platform path:K87:2)

$BuildApp.findLicenses().toFile($buildProject)

BUILD APPLICATION:C871($file.platformPath)