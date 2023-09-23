//%attributes = {"invisible":true}
#DECLARE($BuildApp : cs:C1710.BuildApp)->$path : Text

If (Is macOS:C1572)
	$certificates:=$BuildApp.findCertificates()
	$certificates:=$certificates.query("name == :1 and kind == :2"; "@miyako@"; "Developer ID Application")
	If ($certificates.length#0)
		$path:=$certificates[0].name
	End if 
End if 