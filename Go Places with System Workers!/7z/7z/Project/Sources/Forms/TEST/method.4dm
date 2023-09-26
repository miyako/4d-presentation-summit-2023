$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		If (OB Instance of:C1731(Form:C1466.controller; cs:C1710._CLI_Controller))
			
			Form:C1466.controller.bind(New object:C1471(\
				"startButton"; "button-start"; \
				"stopButton"; "button-stop"; \
				"progressIndicator"; "thermo-progress"))
			
			Form:C1466.controller.stop()
		Else 
			ARRAY LONGINT:C221($events; 1)
			$events{1}:=On Unload:K2:2
			OBJECT SET EVENTS:C1239(*; ""; $events; Disable events others unchanged:K42:39)
			OBJECT SET VISIBLE:C603(*; "@"; False:C215)
			OBJECT SET VISIBLE:C603(*; "button-warning"; True:C214)
		End if 
		
	: ($event.code=On Unload:K2:2)
		
		Form:C1466.controller.terminate()
		
End case 