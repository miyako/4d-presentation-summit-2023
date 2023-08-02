//%attributes = {}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1; Current method name:C684; New object:C1471)
	
Else 
	
	$form:=cs:C1710.Csv2Json.new(cs:C1710._TEST_Form_Controller)
	
	$form.CSV:="COL1,COL2,COL3\n1,2,3\n4,5,6\n"
	$form.JSON:=""
	
	$window:=Open form window:C675("TEST")
	DIALOG:C40("TEST"; $form; *)
	
End if 