//%attributes = {"invisible":true}
#DECLARE($BuildApp : Object; $form : Object; $name : Text)->$icon : Picture

var $path : Variant

Case of 
	: ($name="MacCompiledDatabaseToWin")
		$path:=$BuildApp.CS[$name]
	: ($name="DatabaseToEmbedInClientMac") || ($name="DatabaseToEmbedInClientWin")
		$path:=$BuildApp.SourcesFiles.CS[$name+"Folder"]
	: ($name="Server")
		$path:=$BuildApp.SourcesFiles.CS[$name+(Is macOS:C1572 ? "Mac" : "Win")+"Folder"]
	Else 
		$path:=$BuildApp.SourcesFiles[$name][$name+(Is macOS:C1572 ? "Mac" : "Win")+"Folder"]
		If ($name="RuntimeVL")
			If (Is macOS:C1572)
				$BuildApp.SourcesFiles.CS.ClientMacFolderToMac:=$path
			Else 
				$BuildApp.SourcesFiles.CS.ClientWinFolderToWin:=$path
			End if 
		End if 
End case 

var $icon : Picture
$form[$name][$name+"Folder"]:=New object:C1471

If (Value type:C1509($path)=Is text:K8:3) && ($path#"") && (Test path name:C476($path)>=0)
	Case of 
		: (Test path name:C476($path)=Is a folder:K24:2)
			$icon:=Folder:C1567($path; fk platform path:K87:2).getIcon()
		: (Test path name:C476($path)=Is a document:K24:1)
			$icon:=File:C1566($path; fk platform path:K87:2).getIcon()
	End case 
	$form[$name][$name+"Folder"].values:=Split string:C1554($path; Folder separator:K24:12; sk ignore empty strings:K86:1).reverse()
Else 
	$form[$name][$name+"Folder"].values:=New collection:C1472
End if 

$form[$name][$name+"Folder"].currentValue:=$form[$name][$name+"Folder"].values.length=0 ? "" : $form[$name][$name+"Folder"].values[0]
$form[$name][$name+"Folder"].index:=-1

