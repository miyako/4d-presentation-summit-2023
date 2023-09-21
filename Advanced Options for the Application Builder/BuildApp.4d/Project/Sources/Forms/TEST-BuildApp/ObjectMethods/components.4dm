var $component : Object

If (FORM Event:C1606.row#Null:C1517)
	$component:=Form:C1466.components[FORM Event:C1606.row-1]
End if 

Case of 
	: (FORM Event:C1606.code=On Data Change:K2:15)
		
		//checkbox
		
		update_components_list(Form:C1466; $component)
		
	: (FORM Event:C1606.code=On Clicked:K2:4)
		
		//other
		
		$component.selected:=Not:C34($component.selected)
		
		update_components_list(Form:C1466; $component)
		
		Form:C1466.components:=Form:C1466.components  //redraw
		
End case 