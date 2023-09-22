//%attributes = {"invisible":true}
#DECLARE($BuildApp : Object)

//TODO:check ACI0104213

//page 1
$BuildApp.BuildApplicationName:=$BuildApp.BuildApplicationName=Null:C1517 ? "" : $BuildApp.BuildApplicationName

//page 2
$BuildApp.CS.HardLink:=$BuildApp.CS.HardLink=Null:C1517 ? "" : $BuildApp.CS.HardLink
$BuildApp.CS.IPAddress:=$BuildApp.CS.IPAddress=Null:C1517 ? "" : $BuildApp.CS.IPAddress
$BuildApp.CS.PortNumber:=$BuildApp.CS.PortNumber=Null:C1517 ? "" : $BuildApp.CS.PortNumber
$BuildApp.CS.ServerStructureFolderName:=$BuildApp.CS.ServerStructureFolderName=Null:C1517 ? "" : $BuildApp.CS.ServerStructureFolderName
$BuildApp.CS.ClientServerSystemFolderName:=$BuildApp.CS.ClientServerSystemFolderName=Null:C1517 ? "" : $BuildApp.CS.ClientServerSystemFolderName

//page 3
$BuildApp.CS.CurrentVers:=$BuildApp.CS.CurrentVers=Null:C1517 ? "" : $BuildApp.CS.CurrentVers
$BuildApp.CS.RangeVersMin:=$BuildApp.CS.RangeVersMin=Null:C1517 ? "" : $BuildApp.CS.RangeVersMin
$BuildApp.CS.RangeVersMax:=$BuildApp.CS.RangeVersMax=Null:C1517 ? "" : $BuildApp.CS.RangeVersMax

//page 4
$BuildApp.SignApplication.MacCertificate:=$BuildApp.SignApplication.MacCertificate=Null:C1517 ? "" : $BuildApp.SignApplication.MacCertificate

//page 5
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

//page 6
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

//page 7
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

//page 8
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

//page 9
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
