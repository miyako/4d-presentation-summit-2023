//%attributes = {"invisible":true}
#DECLARE($BuildApp : Object; $form : Object; $name : Text)->$icon : Picture

var $path : Variant

Case of 
	: ($name="ClientMac") || ($name="ClientWin")
		$path:=($BuildApp.SourcesFiles.CS[$name+"IconForMacPath"]) || ($BuildApp.SourcesFiles.CS[$name+"IconForWinPath"])
	: ($name="Server")
		$path:=$BuildApp.SourcesFiles.CS[$name+"Icon"+(Is macOS:C1572 ? "Mac" : "Win")+"Path"]
	Else 
		$path:=$BuildApp.SourcesFiles[$name][$name+"Icon"+(Is macOS:C1572 ? "Mac" : "Win")+"Path"]
End case 

var $icon : Picture
$form[$name][$name+"IconPath"]:=New object:C1471

If (Value type:C1509($path)=Is text:K8:3) && ($path#"")
	READ PICTURE FILE:C678($path; $icon)
	If (Is Windows:C1573)
		PICTURE PROPERTIES:C457($icon; $width; $height)
		TRANSFORM PICTURE:C988($icon; Scale:K61:2; 32/$width; 32/$height)
	End if 
	$form[$name][$name+"IconPath"].values:=Split string:C1554($path; Folder separator:K24:12; sk ignore empty strings:K86:1).reverse()
	$form[$name][$name+"IconPath"].currentValue:=$form[$name][$name+"IconPath"].values.length=0 ? "" : $form[$name][$name+"IconPath"].values[0]
	$form[$name][$name+"IconPath"].index:=-1
Else 
	$form[$name][$name+"IconPath"].values:=New collection:C1472
End if 