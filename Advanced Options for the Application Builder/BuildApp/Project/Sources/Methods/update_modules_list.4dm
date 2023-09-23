//%attributes = {"invisible":true}
#DECLARE($form : Object; $item : Object)->$icon : Picture

$modules:=New collection:C1472

For each ($module; Form:C1466.modules)
	If (Not:C34($module.selected))
		$modules.push($module.name)
	End if 
End for each 

$form.BuildApp.ArrayExcludedModuleName.Item:=$modules