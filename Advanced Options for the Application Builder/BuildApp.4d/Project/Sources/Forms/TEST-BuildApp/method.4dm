$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		LISTBOX SELECT ROW:C912(*; "lb.pages"; 1; lk replace selection:K53:1)
		GOTO OBJECT:C206(*; "BuildApp.BuildApplicationName")
		
		OBJECT SET VISIBLE:C603(*; "BuildApp.BuildMacDestFolder"; Is macOS:C1572)
		OBJECT SET VISIBLE:C603(*; "BuildApp.BuildWinDestFolder"; Is Windows:C1573)
		
		OBJECT SET ENABLED:C1123(*; "BuildApp.SourcesFiles.RuntimeVL.IsOEM"; False:C215)
		OBJECT SET ENABLED:C1123(*; "BuildApp.SourcesFiles.CS.IsOEM"; False:C215)
		
		OBJECT SET VISIBLE:C603(*; "Hint for Mac@"; Is macOS:C1572)
		OBJECT SET VISIBLE:C603(*; "Hint for Win@"; Is Windows:C1573)
		
		//enabled won't work because of associated standard action 
		//OBJECT SET VISIBLE(*; "copy to pasteboard@"; Form.BuildApp#Null)
		
	: ($event.code=On Page Change:K2:54)
		
		LISTBOX SELECT ROW:C912(*; "lb.pages"; FORM Get current page:C276; lk replace selection:K53:1)
		
End case 