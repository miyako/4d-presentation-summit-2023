$event:=FORM Event:C1606

Case of 
	: ($event.code=On Drag Over:K2:13)
		
		$path:=Get file from pasteboard:C976(1)
		
		If ($path#"") && (Test path name:C476($path)>=0)
			$0:=0
		Else 
			$0:=-1
		End if 
		
	: ($event.code=On Drop:K2:12)
		
		$path:=Get file from pasteboard:C976(1)
		
		var $class : 4D:C1709.Class
		
		$class:=(Test path name:C476($path)=Is a folder:K24:2) ? 4D:C1709.Folder : 4D:C1709.File
		
		Form:C1466.src:=$class.new($path; fk platform path:K87:2)
		
		Form:C1466.srcIcon:=Form:C1466.src.getIcon()
		
		Form:C1466.controller.stop()
		
End case 