//%attributes = {"invisible":true}
#DECLARE($BuildApp : Object; $form : Object; $name : Text)

$form[$name]:=New object:C1471
$form[$name].LastDataPathLookup:=New object:C1471
$form[$name].LastDataPathLookup.values:=New collection:C1472("InDbStruct"; "ByAppName"; "ByAppPath")
$form[$name].LastDataPathLookup.currentValue:=$BuildApp[$name].LastDataPathLookup
$form[$name].LastDataPathLookup.index:=$form[$name].LastDataPathLookup.values.indexOf($BuildApp[$name].LastDataPathLookup)
