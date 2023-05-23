Class extends _CLI_Controller

property _startButtonName; _stopButtonName; _progressIndicatorName : Text
property _stdIn; _stdErr; _stdOut : Text

Class constructor
	
	Super:C1705()
	
	This:C1470._startButtonName:="button^start"
	This:C1470._stopButtonName:="button^stop"
	This:C1470._progressIndicatorName:="thermo^progress"
	
Function start()
	
	This:C1470.clear()
	
	OBJECT SET ENABLED:C1123(*; This:C1470._startButtonName; False:C215)
	OBJECT SET ENABLED:C1123(*; This:C1470._stopButtonName; True:C214)
	OBJECT SET VISIBLE:C603(*; This:C1470._progressIndicatorName; True:C214)
	
Function stop()
	
	This:C1470.clear()
	
	OBJECT SET ENABLED:C1123(*; This:C1470._startButtonName; True:C214)
	OBJECT SET ENABLED:C1123(*; This:C1470._stopButtonName; False:C215)
	OBJECT SET VISIBLE:C603(*; This:C1470._progressIndicatorName; False:C215)
	
Function clear()
	
	Form:C1466.stdIn:=""
	Form:C1466.stdErr:=""
	Form:C1466.stdOut:=""
	Form:C1466.progress:=0
	Form:C1466.onDataCount:=0
	Form:C1466.onDataErrorCount:=0
	Form:C1466.onResponseCount:=0
	Form:C1466.onTerminateCount:=0
	
	This:C1470._stdIn:=""
	This:C1470._stdErr:=""
	This:C1470._stdOut:=""
	
	//MARK: inherited from cs._CLI_Controller
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is and instance of cs.SevenZip
	//This is and instance of cs._TEST_Controller
	
	If (Form:C1466#Null:C1517)
		
		Case of 
			: ($worker.dataType="text")
				
				This:C1470._stdErr+=$params.data
				
			: ($worker.dataType="blob")
				
				This:C1470._stdErr+=Convert to text:C1012($params.data; This:C1470.encoding)
				
		End case 
		
		$data:=This:C1470._stdErr
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
/*
on Windows this stream is separated by CR, not CRLF. 
CR does not count as end of line in regex
so don't use "s" metacharacter here
*/
		
		Case of 
			: (Match regex:C1019("\\s*(\\d+)%[\\u0020]+(\\d+)[\\u0020]+(\\S+)[\\u0020]+(.+)"; $data; 1; $pos; $len))
				$progress:=Num:C11(Substring:C12($data; $pos{1}; $len{1}))
				$size:=Num:C11(Substring:C12($data; $pos{2}; $len{2}))
				$flag:=Substring:C12($data; $pos{3}; $len{3})
				$info:=Substring:C12($data; $pos{4}; $len{4})
				Form:C1466.stdErr:=String:C10($progress; "^^0")+"%"+" "+$info
				This:C1470._stdErr:=""
				Form:C1466.progress:=$progress
				
			: (Match regex:C1019("\\s*(\\d+)%[\\u0020]+(\\S+)[\\u0020]+(.+)"; $data; 1; $pos; $len))
				
				$progress:=Num:C11(Substring:C12($data; $pos{1}; $len{1}))
				$flag:=Substring:C12($data; $pos{2}; $len{2})
				$info:=Substring:C12($data; $pos{3}; $len{3})
				Form:C1466.stdErr:=String:C10($progress; "^^0")+"%"+" "+$info
				This:C1470._stdErr:=""
				Form:C1466.progress:=$progress
		End case 
		
		Form:C1466.onDataErrorCount+=1
		
	End if 
	
Function onData($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is and instance of cs.SevenZip
	//This is and instance of cs._TEST_Controller
	
	If (Form:C1466#Null:C1517)
		
		Case of 
			: ($worker.dataType="text")
				
				This:C1470._stdOut+=$params.data
				
			: ($worker.dataType="blob")
				
				This:C1470._stdOut+=Convert to text:C1012($params.data; This:C1470.encoding)
				
		End case 
		
		$data:=This:C1470._stdOut
		
		Form:C1466.stdOut+=Split string:C1554($data; Form:C1466.EOL; sk ignore empty strings:K86:1 | sk trim spaces:K86:2).join("\r")
		
		Form:C1466.onDataCount+=1
		
	End if 
	
Function onResponse($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is and instance of cs.SevenZip
	//This is and instance of cs._TEST_Controller
	
	If (Form:C1466#Null:C1517)
		
		Form:C1466.onResponseCount+=1
		
		If (This:C1470.complete)
			//end of the queue
		End if 
		
	End if 
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is and instance of cs.SevenZip
	//This is and instance of cs._TEST_Controller
	
	If (Form:C1466#Null:C1517)
		
		Form:C1466.progress:=0
		Form:C1466.onTerminateCount+=1
		
		If (This:C1470.complete)
			//end of the queue
			OBJECT SET ENABLED:C1123(*; This:C1470._stopButtonName; False:C215)
			OBJECT SET ENABLED:C1123(*; This:C1470._startButtonName; True:C214)
			OBJECT SET VISIBLE:C603(*; This:C1470._progressIndicatorName; False:C215)
			//don't .clear() to keep stats
			Form:C1466.stdOut:=""
			Form:C1466.stdErr:=""
		End if 
		
	End if 