If (Form event code:C388=On Unload:K2:2)
	
	If (Version type:C495 ?? Merged application:K5:28) && (Is Windows:C1573) && (Get application info:C1599.SDIMode)
		QUIT 4D:C291
	End if 
	
End if 