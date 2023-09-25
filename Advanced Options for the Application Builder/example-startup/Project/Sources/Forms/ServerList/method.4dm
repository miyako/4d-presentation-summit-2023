$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		OBJECT SET ENABLED:C1123(*; "btn.OK"; False:C215)
		
		Form:C1466.servers:=New object:C1471("col"; New collection:C1472; "sel"; Null:C1517; "item"; Null:C1517; "pos"; Null:C1517)
		
		If (Is macOS:C1572)
			READ PICTURE FILE:C678(File:C1566("/RESOURCES/BuildApp.icns").platformPath; $icon)
		Else 
			READ PICTURE FILE:C678(File:C1566("/RESOURCES/BuildApp.ico").platformPath; $icon)
		End if 
		
		OBJECT SET VISIBLE:C603(*; "Hint for Mac@"; Is macOS:C1572)
		OBJECT SET VISIBLE:C603(*; "Hint for Win@"; Is Windows:C1573)
		
		Form:C1466.link:=""
		Form:C1466.icon:=$icon
		
		Form:C1466.controller.callWorker()
		
	: ($event.code=On Close Box:K2:21)
		
		CANCEL:C270
		
	: ($event.code=On Unload:K2:2)
		
		Form:C1466.controller.killWorker().setWindowBounds(Form:C1466.controller.formIdentifier)
		
End case 