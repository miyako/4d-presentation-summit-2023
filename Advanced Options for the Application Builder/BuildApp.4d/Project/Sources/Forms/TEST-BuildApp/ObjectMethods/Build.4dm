If (Form event code:C388=On Clicked:K2:4)
	
	$name:="BuildApp-"+Replace string:C233(String:C10(Current date:C33; ISO date:K1:8; Current time:C178); Folder separator:K24:12; "-"; *)
	
	$buildProject:=File:C1566(File:C1566("/LOGS/"+$name+".4DSettings").platformPath; fk platform path:K87:2)
	
	Form:C1466.BuildApp.findLicenses().toFile($buildProject)
	
	BUILD APPLICATION:C871($buildProject.platformPath)
	
End if 