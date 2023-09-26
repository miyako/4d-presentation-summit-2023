//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(Current method name:C684; Current method name:C684; New object:C1471)
	
Else 
	
	$csv:="COL1,COL2,COL3\n1,2,3\n4,5,6\n"
	
	$desktopFolder:=Folder:C1567(fk desktop folder:K87:19)
	
	$firstFile:=$desktopFolder.file("pretty.csv")
	$secondFile:=$desktopFolder.file("compact.csv")
	
	$firstFile.setText($csv; "utf-8"; Document unchanged:K24:18)
	$secondFile.setText($csv; "utf-8"; Document unchanged:K24:18)
	
	$one:=New object:C1471("src"; $firstFile; "pretty"; True:C214; "separator"; "comma")
	$two:=New object:C1471("src"; $secondFile; "pretty"; False:C215; "separator"; "comma")
	
	$csv2Json:=cs:C1710.Csv2Json.new(cs:C1710._Worker_Controller)  //the controller will intercept callbacks
	
	$csv2Json.execute($one).execute($two)  //chaining syntax
	
End if 