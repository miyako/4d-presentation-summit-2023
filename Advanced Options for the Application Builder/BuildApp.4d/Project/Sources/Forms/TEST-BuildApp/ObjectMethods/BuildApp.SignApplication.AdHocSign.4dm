If (Form event code:C388=On Clicked:K2:4)
	
	If (Form:C1466.BuildApp.SignApplication.AdHocSign)
		OBJECT SET ENABLED:C1123(*; "BuildApp.SignApplication.MacSignature"; False:C215)
		OBJECT SET ENTERABLE:C238(*; "BuildApp.SignApplication.MacCertificate"; False:C215)
	Else 
		OBJECT SET ENABLED:C1123(*; "BuildApp.SignApplication.MacSignature"; True:C214)
		
		If (Form:C1466.BuildApp.SignApplication.MacSignature)
			OBJECT SET ENTERABLE:C238(*; "BuildApp.SignApplication.MacCertificate"; True:C214)
			GOTO OBJECT:C206(*; "BuildApp.SignApplication.MacCertificate")
		Else 
			OBJECT SET ENTERABLE:C238(*; "BuildApp.SignApplication.MacCertificate"; False:C215)
		End if 
		
		OBJECT SET ENABLED:C1123(*; "BuildApp.SignApplication.AdHocSign"; False:C215)
	End if 
	
End if 