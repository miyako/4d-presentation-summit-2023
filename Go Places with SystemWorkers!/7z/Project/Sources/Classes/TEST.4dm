Class constructor
	
	//for display
	
	This:C1470.stdIn:=""
	This:C1470._stdErr:=""
	This:C1470._stdOut:=""
	This:C1470.progress:=0
	This:C1470.onDataCount:=0
	This:C1470.onDataErrorCount:=0
	This:C1470.onResponseCount:=0
	This:C1470.onTerminateCount:=0
	
	//for buffering
	
	This:C1470._stdIn:=""
	This:C1470._stdErr:=""
	This:C1470._stdOut:=""
	
Function clear()->$this : cs:C1710.TEST
	
	$this:=This:C1470
	
	Form:C1466.stdIn:=""
	Form:C1466.stdErr:=""
	Form:C1466.stdOut:=""
	Form:C1466.progress:=0
	Form:C1466.onDataCount:=0
	Form:C1466.onDataErrorCount:=0
	Form:C1466.onResponseCount:=0
	Form:C1466.onTerminateCount:=0
	Form:C1466._stdIn:=""
	Form:C1466._stdErr:=""
	Form:C1466._stdOut:=""
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	If (Form:C1466.isRunning)
		
		Case of 
			: ($worker.dataType="text")
				
				Form:C1466._stdErr+=$params.data
				
			: ($worker.dataType="blob")
				
				Form:C1466._stdErr+=Convert to text:C1012($params.data; Form:C1466.sevenZip.encoding)
				
		End case 
		
		$data:=Form:C1466._stdErr
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
		Case of 
			: (Match regex:C1019("\\s*(\\d+)%\\s+(\\d+)\\s+(\\S+)\\s+(.+)"; $data; 1; $pos; $len))
				$progress:=Num:C11(Substring:C12($data; $pos{1}; $len{1}))
				$size:=Num:C11(Substring:C12($data; $pos{2}; $len{2}))
				$flag:=Substring:C12($data; $pos{3}; $len{3})
				Form:C1466.stdErr:=String:C10($progress; "^^0")+"%"+" "+Substring:C12($data; $pos{4}; $len{4})
				Form:C1466._stdErr:=""
				Form:C1466.progress:=$progress
			: (Match regex:C1019("\\s*(\\d+)%\\s+(.+)"; $data; 1; $pos; $len))
				$progress:=Num:C11(Substring:C12($data; $pos{1}; $len{1}))
				Form:C1466.stdErr:=String:C10($progress; "^^0")+"%"+" "+Substring:C12($data; $pos{2}; $len{2})
				Form:C1466._stdErr:=""
				Form:C1466.progress:=$progress
		End case 
		
		Form:C1466.onDataErrorCount+=1
		
	End if 
	
Function onData($worker : 4D:C1709.SystemWorker; $params : Object)
	
	If (Form:C1466.isRunning)
		
		Case of 
			: ($worker.dataType="text")
				
				Form:C1466._stdOut+=$params.data
				
			: ($worker.dataType="blob")
				
				Form:C1466._stdOut+=Convert to text:C1012($params.data; Form:C1466.sevenZip.encoding)
				
		End case 
		
		$data:=Form:C1466._stdOut
		
		Form:C1466.stdOut+=Split string:C1554($data; Form:C1466.sevenZip.EOL; sk ignore empty strings:K86:1 | sk trim spaces:K86:2).join("\r")
		
		Form:C1466.onDataCount+=1
		
	End if 
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
	If (Form:C1466.isRunning)
		
		Form:C1466.onResponseCount+=1
		
		If (This:C1470.complete)
			//end of the queue
		End if 
		
	End if 
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	
	If (Form:C1466.isRunning)
		
		Form:C1466.progress:=0
		Form:C1466.onTerminateCount+=1
		
		If (This:C1470.complete)
			//end of the queue
			OBJECT SET ENABLED:C1123(*; "button^stop"; False:C215)
			OBJECT SET ENABLED:C1123(*; "button^TEST"; True:C214)
			Form:C1466.stdOut:=""
			Form:C1466.stdErr:=""
		End if 
		
	End if 
	
Function get isRunning()->$isRunning : Boolean
	
	$isRunning:=(Form:C1466#Null:C1517)