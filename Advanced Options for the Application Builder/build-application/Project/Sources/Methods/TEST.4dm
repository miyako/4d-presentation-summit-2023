//%attributes = {}
$compileProject:=File:C1566("Macintosh HD:Users:miyako:Desktop:aaaaa:Project:aaaaa.4DProject"; fk platform path:K87:2)

$s:=cs:C1710._SettingsXmlParser.new().parse($compileProject)

var $CLI : cs:C1710.BuildApp_CLI

$CLI:=cs:C1710.BuildApp_CLI.new()

$buildProject:=File:C1566("/Users/miyako/Desktop/buildApp.4DSettings")

$compileProject:=File:C1566("/Users/miyako/Documents/GitHub/4d-presentation-summit-2023/Advanced Options for the Application Builder/BuildApp/BuildApp.4d/Project/BuildApp.4DProject")

$built:=$CLI.build($buildProject; $compileProject)