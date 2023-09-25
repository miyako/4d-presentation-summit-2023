//%attributes = {}
//MARK:test projects contain absolute paths

$buildProject:=Folder:C1567(fk database folder:K87:14).file("tests/BuildCSUpgradeable.4DSettings")
$compileProject:=File:C1566(Structure file:C489; fk platform path:K87:2).parent.parent.parent.parent.file("Advanced Options for the Application Builder/example/Project/example.4DProject")

var $CLI : cs:C1710.BuildApp_CLI

$CLI:=cs:C1710.BuildApp_CLI.new()

var $BuildApp : cs:C1710.BuildApp

$BuildApp:=cs:C1710.BuildApp.new($buildProject)

$CLI.compile($compileProject)

$CLI.build($buildProject; $compileProject)