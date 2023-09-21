//%attributes = {"invisible":true}
#DECLARE($BuildApp : cs:C1710.BuildApp; $form : Object)->$icon : Picture

$plugins:=New collection:C1472

For each ($item; $BuildApp.findPlugins($form.compileProject))
	
	$name:=$item.folder.name
	$id:=$item.manifest.id
	
	$plugin:=New object:C1471("name"; $name; "id"; $id; "selected"; Null:C1517)
	
	If ($BuildApp.ArrayExcludedPluginName.Item.includes($name))
		$plugin.selected:=True:C214
	Else 
		
		If ($BuildApp.ArrayExcludedPluginID.Item.includes($id))
			$plugin.selected:=True:C214
		Else 
			$plugin.selected:=False:C215
		End if 
	End if 
	$plugins.push($plugin)
End for each 

$form.plugins:=$plugins