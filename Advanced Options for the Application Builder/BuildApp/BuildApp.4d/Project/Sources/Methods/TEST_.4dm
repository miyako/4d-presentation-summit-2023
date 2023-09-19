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

$file:=Folder:C1567(fk desktop folder:K87:19).file("buildApp.4DSettings")

$BuildApp.findLicenses().toFile($file)

//$BuildApp.buildApplication()

BUILD APPLICATION:C871($file.platformPath)