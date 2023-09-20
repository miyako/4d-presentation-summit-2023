//%attributes = {}
var $CLI : cs:C1710.BuildApp_CLI

$CLI:=cs:C1710.BuildApp_CLI.new()

$compileProject:=File:C1566("/Users/miyako/Desktop/aaaaa/Project/BuildApp.4DProject")

$built:=$CLI._findPlugins($compileProject)