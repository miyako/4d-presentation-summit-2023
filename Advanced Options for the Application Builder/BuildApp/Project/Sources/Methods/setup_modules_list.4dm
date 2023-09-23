//%attributes = {"invisible":true}
#DECLARE($BuildApp : cs:C1710.BuildApp; $form : Object)->$icon : Picture

$modules:=New collection:C1472

For each ($name; New collection:C1472("CEF"; "MeCab"; "PHP"; "SpellChecker"; "4D Updater"))
	$module:=New object:C1471("name"; $name; "selected"; Null:C1517)
	If (Not:C34($BuildApp.ArrayExcludedModuleName.Item.includes($name)))
		$module.selected:=True:C214
	Else 
		$module.selected:=False:C215
	End if 
	$modules.push($module)
End for each 

$form.modules:=$modules