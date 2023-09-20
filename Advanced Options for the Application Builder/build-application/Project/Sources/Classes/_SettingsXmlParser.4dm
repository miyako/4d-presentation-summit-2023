Class extends _XmlParser

Class constructor
	
	Super:C1705()
	
Function _parse($settingsFile : 4D:C1709.File)->$status : Object
	
	$status:=New object:C1471("sdi_application"; Null:C1517; "allow_user_settings"; Null:C1517)
	
	$dom:=DOM Parse XML source:C719($settingsFile.platformPath)
	
	If (OK=1)
		
		$status.sdi_application:=This:C1470.getBoolValue($dom; "/preferences/com.4d/interface/user@sdi_application")
		$status.allow_user_settings:=This:C1470.getBoolValue($dom; "/preferences/com.4d/general@allow_user_settings")
		
		DOM CLOSE XML:C722($dom)
		
	End if 
	
Function parse($projectFile : 4D:C1709.File)->$status : Object
	
	$status:=New object:C1471("sdi_application"; False:C215; "allow_user_settings"; False:C215)
	
	If ($projectFile#Null:C1517) && (OB Instance of:C1731($projectFile; 4D:C1709.File)) && ($projectFile.exists)
		
		$projectSettingsFile:=$projectFile.parent.folder("Sources").file("settings.4DSettings")
		
		$projectStatus:=This:C1470._parse($projectSettingsFile)
		
		$status.sdi_application:=Bool:C1537($projectStatus.sdi_application)
		$status.allow_user_settings:=Bool:C1537($projectStatus.allow_user_settings)
		
		If ($status.allow_user_settings)
			
			$userSettingsFile:=$projectFile.parent.parent.folder("Settings").file("settings.4DSettings")
			
			$userStatus:=This:C1470._parse($projectSettingsFile)
			
			If ($userStatus.sdi_application#Null:C1517)
				$status.sdi_application:=$userStatus.sdi_application
			End if 
			
		End if 
		
	End if 