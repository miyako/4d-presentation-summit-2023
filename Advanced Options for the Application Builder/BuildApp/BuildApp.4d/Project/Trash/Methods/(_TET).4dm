//%attributes = {}
var $BuildApp : cs:C1710.BuildApp

$BuildApp:=cs:C1710.BuildApp.new()

$BuildApp.BuildApplicationName:="TEST"
$BuildApp.BuildMacDestFolder:=System folder:C487(Desktop:K41:16)
$BuildApp.BuildApplicationSerialized:=True:C214
$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=True:C214
$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("4D Volume Desktop.app").platformPath
$BuildApp.Versioning.Common.CommonVersion:="1.0.0"
$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLIconMacPath:=Folder:C1567(fk resources folder:K87:11).file("BuildApp.icns").platformPath

$buildProject:=Folder:C1567(fk desktop folder:K87:19).file("test.4DSettings")
$BuildApp.toFile($buildProject)

$CLI:=cs:C1710._Terminal.new()

$compileProject:=File:C1566("Macintosh HD:Users:miyako:Desktop:aaaaa:Project:BuildApp.4DProject"; fk platform path:K87:2)

$CLI.launch($buildProject; $compileProject)
