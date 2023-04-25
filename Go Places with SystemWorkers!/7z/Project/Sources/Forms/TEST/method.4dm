$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		OBJECT SET ENABLED:C1123(*; "@"; Form:C1466.sevenZip#Null:C1517)
		OBJECT SET ENABLED:C1123(*; "button^stop"; False:C215)
		
		Form:C1466.clear()
		
	: ($event.code=On Unload:K2:2)
		
		Form:C1466.sevenZip.terminate()
		
End case 