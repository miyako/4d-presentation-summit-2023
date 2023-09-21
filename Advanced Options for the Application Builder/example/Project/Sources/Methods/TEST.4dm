//%attributes = {}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1; Current method name:C684; New object:C1471)
	
Else 
	
	$window:=Open form window:C675("TEST")
	DIALOG:C40("TEST"; *)
	
End if 