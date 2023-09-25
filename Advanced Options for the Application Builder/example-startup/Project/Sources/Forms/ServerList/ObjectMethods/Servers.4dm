$event:=FORM Event:C1606

Case of 
	: ($event.code=On Selection Change:K2:29)
		
		var $item : Object
		
		$item:=Form:C1466.servers.item
		
		If ($item#Null:C1517)
			Form:C1466.link:=Form:C1466.controller.linkForServer($item.name; $item.addr; $item.port)
			OBJECT SET ENABLED:C1123(*; "btn.OK"; True:C214)
			Form:C1466.servers.col:=Form:C1466.servers.col
		Else 
			Form:C1466.link:=""
			OBJECT SET ENABLED:C1123(*; "btn.OK"; False:C215)
			Form:C1466.servers.col:=Form:C1466.servers.col
			LISTBOX SELECT ROW:C912(*; "Servers"; 0; lk remove from selection:K53:3)
		End if 
		
	: ($event.code=On Double Clicked:K2:5)
		
		Form:C1466.controller.connect(Form:C1466.link)
		
End case 