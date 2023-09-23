//%attributes = {}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1; Current method name:C684; New object:C1471)
	
Else 
	
	$form:=cs:C1710.Lipo.new(cs:C1710._Lipo_Form_Controller)
	
	$window:=Open form window:C675("TEST-Lipo")
	DIALOG:C40("TEST-Lipo"; $form; *)
	
End if 