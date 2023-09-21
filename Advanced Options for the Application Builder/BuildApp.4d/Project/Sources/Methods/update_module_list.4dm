//%attributes = {"invisible":true}
#DECLARE($name : Text)->$icon : Picture

If (Form:C1466.ExcludeCEF) && (Not:C34(Form:C1466.BuildApp.ArrayExcludedModuleName.Item.includes($name)))
	Form:C1466.BuildApp.ArrayExcludedModuleName.Item.push($name)
Else 
	$formula:=Formula:C1597($1.result:=($1.value=$2 ? False:C215 : True:C214))
	$Item:=Form:C1466.BuildApp.ArrayExcludedModuleName.Item
	Form:C1466.BuildApp.ArrayExcludedModuleName.Item:=$Item.filter($formula; $name)
End if 