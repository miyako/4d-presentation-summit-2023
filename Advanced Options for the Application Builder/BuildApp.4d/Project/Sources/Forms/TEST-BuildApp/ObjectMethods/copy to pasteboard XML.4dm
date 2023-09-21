If (Form event code:C388=On Clicked:K2:4)
	
	$XML:=cs:C1710.BuildApp.new(Form:C1466.BuildApp).toString()
	SET TEXT TO PASTEBOARD:C523($XML)
	
End if 