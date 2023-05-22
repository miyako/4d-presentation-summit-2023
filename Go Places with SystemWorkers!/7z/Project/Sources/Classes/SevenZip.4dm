Class extends _CLI

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705("7z"; $controller)
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function add($destination : 4D:C1709.File; $sources : Collection)->$this : cs:C1710.SevenZip
	
	$this:=This:C1470
	
	var $commands : Collection
	$commands:=New collection:C1472
	
	var $source : Object
	For each ($source; $sources)
/*
resolve filesystem path
*/
		Case of 
			: (OB Instance of:C1731($source; 4D:C1709.File))
				$source:=File:C1566($source.platformPath; fk platform path:K87:2)
			: (OB Instance of:C1731($source; 4D:C1709.Folder))
				$source:=Folder:C1567($source.platformPath; fk platform path:K87:2)
		End case 
		$command:=This:C1470.quote(This:C1470.executablePath)
		$command:=$command+" a -snl -bso1 -bsp2 -y "+This:C1470.quote($destination.path)+" "+This:C1470.quote($source.path)
/*
-snl : store synbolic links as links (tar)
-bsp2: redirect(b) stream(s) progress(p) stderr(2)
*/
		$commands.push($command)
	End for each 
	
	This:C1470.controller.execute($commands)