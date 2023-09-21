//%attributes = {"invisible":true}
#DECLARE($BuildApp : Object; $form : Object)->$icon : Picture



$plugins:=New collection:C1472
For each ($name; $BuildApp.ArrayExcludedPluginName.Item)
	$plugin:=New object:C1471("name"; $name; "selected"; True:C214)
	$plugins.push($plugin)
End for each 

$form.plugins:=$plugins