//%attributes = {}
$buildProject:=Folder:C1567(fk database folder:K87:14).folder("tests").file("SignApplication.4DSettings")
$compileProject:=File:C1566("Macintosh HD:Users:miyako:Documents:GitHub:4d-presentation-summit-2023:Advanced Options for the Application Builder:example:Project:example.4DProject"; fk platform path:K87:2)

var $CLI : cs:C1710.BuildApp_CLI

$CLI:=cs:C1710.BuildApp_CLI.new()

var $BuildApp : cs:C1710.BuildApp

$BuildApp:=cs:C1710.BuildApp.new($buildProject)

$compile:=$CLI.compile($compileProject)

$built:=$CLI.build($buildProject; $compileProject)