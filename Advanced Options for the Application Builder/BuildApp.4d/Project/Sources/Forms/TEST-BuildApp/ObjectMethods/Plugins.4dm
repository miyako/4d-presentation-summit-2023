Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15) && (FORM Event:C1606.row#Null:C1517)
		
		//checkbox
		
		update_plugins_list(Form:C1466)
		
	: (FORM Event:C1606.code=On Clicked:K2:4) && (FORM Event:C1606.row#Null:C1517)
		
		//other
		
		Form:C1466.plugin.selected:=Not:C34(Form:C1466.plugin.selected)
		Form:C1466.plugins:=Form:C1466.plugins  //redraw
		
		update_plugins_list(Form:C1466)
		
End case 