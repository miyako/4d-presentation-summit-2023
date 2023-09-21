//%attributes = {"invisible":true}
#DECLARE($form : Object)->$icon : Picture

var $item : Object

$item:=$form.plugin

If ($item#Null:C1517)
	
	//$item.selected:=Not($item.selected)
	$name:=$item.name
	$id:=$item.id
	
	$items:=$form.BuildApp.ArrayExcludedPluginName.Item
	
	If ($item.selected)
		
		If (Not:C34($items.includes($name)))
			$form.BuildApp.ArrayExcludedPluginName.Item.push($name)
		End if 
		
	Else 
		
		$_items:=New collection:C1472
		
		For each ($_name; $items)
			If ($name#$_name)
				$_items.push($_name)
				break
			End if 
		End for each 
		
		$form.BuildApp.ArrayExcludedPluginName.Item:=$_items
		
	End if 
	
	$items:=$form.BuildApp.ArrayExcludedPluginID.Item
	
	$_items:=New collection:C1472
	
	For each ($_id; $items)
		If ($id#$_id)
			$_items.push($_id)
			break
		End if 
	End for each 
	
	$form.BuildApp.ArrayExcludedPluginID.Item:=$_items
	
End if 