//%attributes = {}
var $CLI : cs:C1710.BuildApp_CLI

$CLI:=cs:C1710.BuildApp_CLI.new()

$buildProject:=File:C1566("/Users/miyako/Desktop/buildApp.4DSettings")

$built:=$CLI.build($buildProject)