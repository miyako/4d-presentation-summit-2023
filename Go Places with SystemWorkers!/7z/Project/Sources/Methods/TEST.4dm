//%attributes = {}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1; Current method name:C684; New object:C1471)
	
	var $c : cs:C1710._CLI
	
Else 
	
	$form:=cs:C1710.TEST.new()
	$form.sevenZip:=cs:C1710.SevenZip.new()
	
	For each ($event; New collection:C1472("onData"; "onDataError"; "onResponse"; "onTerminate"))
		$form.sevenZip.controller[$event]:=$form[$event]
	End for each 
	
	$window:=Open form window:C675("TEST")
	DIALOG:C40("TEST"; $form; *)
	
End if 