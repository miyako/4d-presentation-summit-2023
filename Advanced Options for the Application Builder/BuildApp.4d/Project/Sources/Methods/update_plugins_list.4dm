//%attributes = {"invisible":true}
#DECLARE($form : Object; $item : Object)->$icon : Picture

$names:=New collection:C1472
$excludes:=New collection:C1472
$includes:=New collection:C1472

For each ($plugin; Form:C1466.plugins)
	If (Not:C34($plugin.selected))
		$names.push($plugin.name)
		$excludes.push($plugin.id)
	Else 
		$includes.push($plugin.id)
	End if 
End for each 

$ids:=New collection:C1472
For each ($id; $excludes)
	If ($includes.includes($id))
		$ids.push($id)
	End if 
End for each 

$form.BuildApp.ArrayExcludedPluginName.Item:=$names
$form.BuildApp.ArrayExcludedPluginID.Item:=$ids