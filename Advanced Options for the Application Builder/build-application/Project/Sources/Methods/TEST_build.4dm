//%attributes = {}
var $CLI : cs:C1710.BuildApp_CLI

$CLI:=cs:C1710.BuildApp_CLI.new()

$buildProject:=File:C1566("Macintosh HD:Users:miyako:Desktop:buildApp.4DSettings"; fk platform path:K87:2)

$compileProject:=File:C1566("Macintosh HD:Users:miyako:Documents:GitHub:4d-presentation-summit-2023:Advanced Options for the Application Builder:example:Project:example.4DProject"; fk platform path:K87:2)

var $BuildApp : cs:C1710.BuildApp

$BuildApp:=cs:C1710.BuildApp.new($buildProject)

//$CLI._getIntValue($BuildApp; "CS.RangeVersMin")

$compile:=$CLI.compile($compileProject)

$built:=$CLI.build($buildProject; $compileProject)