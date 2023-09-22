//%attributes = {"invisible":true}
#DECLARE($form : Object; $item : Object)->$icon : Picture

$components:=New collection:C1472

For each ($component; Form:C1466.components)
	If (Not:C34($component.selected))
		$components.push($component.name)
	End if 
End for each 

$form.BuildApp.ArrayExcludedComponentName.Item:=$components