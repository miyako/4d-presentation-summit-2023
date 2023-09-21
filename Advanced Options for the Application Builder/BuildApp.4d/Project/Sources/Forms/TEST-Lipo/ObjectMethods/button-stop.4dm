$event:=FORM Event:C1606

If ($event.code=On Clicked:K2:4)
	
	Form:C1466.controller.stop()
	Form:C1466.controller.terminate()
	
End if 