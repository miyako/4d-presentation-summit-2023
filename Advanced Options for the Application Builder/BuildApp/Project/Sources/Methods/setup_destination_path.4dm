//%attributes = {"invisible":true}
#DECLARE($BuildApp : Object; $form : Object; $name : Text)

$form[$name]:=New object:C1471
$form[$name][$name+"Folder"]:=New object:C1471

var $path : Variant

$path:=$BuildApp["Build"+(Is macOS:C1572 ? "Mac" : "Win")+"DestFolder"]

var $icon : Picture
$form[$name][$name+"Folder"]:=New object:C1471

If (Value type:C1509($path)=Is text:K8:3) && ($path#"")
	$icon:=Folder:C1567($path; fk platform path:K87:2).getIcon()
	$form[$name][$name+"Folder"].values:=Split string:C1554($path; Folder separator:K24:12; sk ignore empty strings:K86:1).reverse()
Else 
	$form[$name][$name+"Folder"].values:=New collection:C1472
End if 

$form[$name][$name+"Folder"].currentValue:=$form[$name][$name+"Folder"].values.length=0 ? "" : $form[$name][$name+"Folder"].values[0]
$form[$name][$name+"Folder"].index:=-1

$form[$name+"Icon"]:=$icon