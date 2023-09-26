$event:=FORM Event:C1606

If ($event.code=On Clicked:K2:4)
	
	$src:=Form:C1466.controller.setInput()
	
	$option:=New object:C1471("src"; $src; "pretty"; True:C214; "separator"; "comma")
	
	Form:C1466.controller.start()
	
	Form:C1466.execute($option)
	
End if 