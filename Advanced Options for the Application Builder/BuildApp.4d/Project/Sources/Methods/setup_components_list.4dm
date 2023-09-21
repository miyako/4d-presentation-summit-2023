//%attributes = {"invisible":true}
#DECLARE($BuildApp : cs:C1710.BuildApp; $form : Object)->$icon : Picture

$components:=New collection:C1472

For each ($item; $BuildApp.findComponents($form.compileProject))
	
	$name:=$item.name
	
	$component:=New object:C1471("name"; $name; "selected"; Null:C1517)
	
	If ($BuildApp.ArrayExcludedComponentName.Item.includes($name))
		$component.selected:=True:C214
	Else 
		$component.selected:=False:C215
	End if 
	$components.push($component)
End for each 

$form.components:=$components