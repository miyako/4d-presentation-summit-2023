Class extends _CLI

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705("iconutil"; $controller)
	
Function onResponse($files : Collection; $parameters : Collection)
	
	var $srcFolder; $dstFolder : 4D:C1709.Folder
	
	$srcFolder:=$parameters.at(0)
	$dstFolder:=$parameters.at(1)
	
	$dstFolder.create()
	
	$srcFolder.copyTo($dstFolder; fk overwrite:K87:5)
	
	var $src; $dst : 4D:C1709.File
	
	var $arch : Text
	$arch:=$parameters.at(2)
	
	$options:=New collection:C1472
	
	$srcPath:=Split string:C1554($srcFolder.parent.path; "/"; sk ignore empty strings:K86:1)
	
	For each ($src; $files)
		
		$pathComponents:=Split string:C1554($src.path; "/"; sk ignore empty strings:K86:1)
		
		$dst:=$dstFolder.file($pathComponents.slice($srcPath.length).join("/"))
		
		$options.push(New object:C1471("src"; $src; "dst"; $dst; "arch"; $arch))
		
	End for each 
	
	This:C1470.thin($options)
	
Function terminate()
	
	This:C1470.controller.terminate()
	
Function convert($option : Variant)->$this : cs:C1710.Lipo
	
	$this:=This:C1470
	
	var $commands; $options : Collection
	$commands:=New collection:C1472
	
	Case of 
		: (Value type:C1509($option)=Is object:K8:27)
			$options:=New collection:C1472($option)
		: (Value type:C1509($option)=Is collection:K8:32)
			$options:=$option
	End case 
	
	var $sources : Collection
	var $source : Object
	
	For each ($option; $options)
		
		$sources:=Null:C1517
		
		Case of 
			: (Value type:C1509($option.src)=Is object:K8:27)
				$source:=$option.src
				If (OB Instance of:C1731($source; 4D:C1709.File))
					If ($source.extension=".png")
						$sources:=New collection:C1472($source)
					End if 
				End if 
			: (Value type:C1509($option.src)=Is collection:K8:32)
				For each ($source; $option.src)
					If (OB Instance of:C1731($source; 4D:C1709.File))
						If ($source.extension=".png")
							If ($sources=Null:C1517)
								$sources:=New collection:C1472($source)
							Else 
								$sources.push($source)
							End if 
						End if 
					End if 
				End for each 
		End case 
		
		Case of 
			: ($sources#Null:C1517) && (OB Instance of:C1731($option.dst; 4D:C1709.File)) && ($option.dst.extension=".icns")
/*
resolve filesystem path
*/
				$output:=File:C1566($option.dst.platformPath; fk platform path:K87:2)
				$output.parent.create()
				
				$command:=This:C1470.escape(This:C1470.executablePath)
				$command:=$command+" -c icns "  //convert
				
				$iconsetFolder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066).folder($output.name+".iconset")
				$iconsetFolder.create()
				
				$command:=$command+This:C1470.escape($iconsetFolder.path)
				
				For each ($src; $sources)
					$input:=File:C1566($src.platformPath; fk platform path:K87:2)
					$input.copyTo($iconsetFolder)
				End for each 
				
				$command:=$command+" -o "+This:C1470.escape($output.path)
				$commands.push($command)
				
		End case 
	End for each 
	
	This:C1470.controller.execute($commands)