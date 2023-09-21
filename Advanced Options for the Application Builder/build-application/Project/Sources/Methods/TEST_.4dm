//%attributes = {}
var $BuildApp : cs:C1710.BuildApp

$BuildApp:=cs:C1710.BuildApp.new()

$compileProject:=File:C1566("/Users/miyako/Desktop/aaaaa/Project/BuildApp.4DProject")

$pp:=$BuildApp.findPlugins($compileProject).extract("folder")