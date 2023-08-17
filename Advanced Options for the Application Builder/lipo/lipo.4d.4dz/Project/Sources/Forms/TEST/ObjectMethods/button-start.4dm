$event:=FORM Event:C1606

If ($event.code=On Clicked:K2:4)
	
	$archs:=New collection:C1472("arm64"; "x86_64")
	var $arch : Text
	
	Case of 
		: (OB Instance of:C1731(Form:C1466.src; 4D:C1709.File))
			
			Form:C1466.controller.start()
			
			$options:=New collection:C1472
			
			var $srcFile; $dstFile : 4D:C1709.File
			
			$srcFile:=Form:C1466.src
			
			For each ($arch; $archs)
				$dstFile:=$srcFile.parent.folder($arch).file($srcFile.fullName)
				$options.push(New object:C1471("src"; $srcFile; "dst"; $dstFile; "arch"; $arch))
			End for each 
			
			Form:C1466.thin($options)
			
		: (OB Instance of:C1731(Form:C1466.src; 4D:C1709.Folder)) && (Form:C1466.src.isPackage)
			
			Form:C1466.controller.start()
			
			$options:=New collection:C1472
			
			var $srcFolder; $dstFolder : 4D:C1709.Folder
			
			$srcFolder:=Form:C1466.src
			
			For each ($arch; $archs)
				$dstFolder:=$srcFolder.parent.folder($arch)
				$options.push(New object:C1471("src"; $srcFolder; "dst"; $dstFolder; "arch"; $arch))
			End for each 
			
			Form:C1466.thin($options)
			
	End case 
	
End if 