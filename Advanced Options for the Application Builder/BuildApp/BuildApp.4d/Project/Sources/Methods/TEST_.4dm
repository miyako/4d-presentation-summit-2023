//%attributes = {}
var $BuildApp : cs:C1710.BuildApp

$BuildApp:=cs:C1710.BuildApp.new()

$BuildApp.parseFile(Folder:C1567(fk desktop folder:K87:19).file("buildApp.4DSettings"))

$BuildApp.Versioning.Common.CommonComment:="Comment"
$BuildApp.Versioning.Common.CommonVersion:="1.0.0"
$BuildApp.Versioning.Common.CommonCompanyName:="CompanyName"
$BuildApp.Versioning.Common.CommonCopyright:="Copyright"
$BuildApp.Versioning.Common.CommonCreator:="Creator"
$BuildApp.Versioning.Common.CommonFileDescription:="FileDescription"
$BuildApp.Versioning.Common.CommonInternalName:="InternalName"
$BuildApp.Versioning.Common.CommonLegalTrademark:="LegalTrademark"
$BuildApp.Versioning.Common.CommonPrivateBuild:="PrivateBuild"
$BuildApp.Versioning.Common.CommonSpecialBuild:="SpecialBuild"

$BuildApp.SourcesFiles.RuntimeVL.RuntimeVLWinFolder:=""

$BuildApp.findLicenses().toFile(Folder:C1567(fk desktop folder:K87:19).file("buildApp.4DSettings"))
