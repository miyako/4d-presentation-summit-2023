//%attributes = {}
var $CLI : cs:C1710.BuildApp_CLI

$CLI:=cs:C1710.BuildApp_CLI.new()

$buildProject:=File:C1566("Macintosh HD:Users:miyako:Desktop:buildApp.4DSettings"; fk platform path:K87:2)

$compileProject:=File:C1566("/Users/miyako/Desktop/aaaaa/Project/BuildApp.4DProject")

$built:=$CLI.build($buildProject; $compileProject)