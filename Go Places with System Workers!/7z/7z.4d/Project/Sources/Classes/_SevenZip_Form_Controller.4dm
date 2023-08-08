Class extends _Form_Controller

property _progressIndicatorName : Text
property _progress : Integer

Class constructor()
	
	Super:C1705()
	
Function get progress()->$progress : Integer
	
	$progress:=This:C1470._progress
	
	//MARK:-polymorphism
	
Function bind($options : Object)
	
	If ($options#Null:C1517)
		var $option : Text
		For each ($option; $options)
			Case of 
				: ($option="startButton") && (Value type:C1509($options[$option])=Is text:K8:3)
					This:C1470._startButtonName:=$options[$option]
				: ($option="stopButton") && (Value type:C1509($options[$option])=Is text:K8:3)
					This:C1470._stopButtonName:=$options[$option]
				: ($option="progressIndicator") && (Value type:C1509($options[$option])=Is text:K8:3)
					This:C1470._progressIndicatorName:=$options[$option]
			End case 
		End for each 
	End if 
	
Function start()
	
	This:C1470._clear()
	
	OBJECT SET ENABLED:C1123(*; This:C1470._startButtonName; False:C215)
	OBJECT SET ENABLED:C1123(*; This:C1470._stopButtonName; True:C214)
	OBJECT SET VISIBLE:C603(*; This:C1470._progressIndicatorName; True:C214)
	
Function stop()
	
	This:C1470._clear()
	
	OBJECT SET ENABLED:C1123(*; This:C1470._startButtonName; True:C214)
	OBJECT SET ENABLED:C1123(*; This:C1470._stopButtonName; False:C215)
	OBJECT SET VISIBLE:C603(*; This:C1470._progressIndicatorName; False:C215)
	
Function onDataError($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is an instance of the view
	//This is an instance of the controller
	
	If (Form:C1466#Null:C1517)
		
		Case of 
			: ($worker.dataType="text")
				
				This:C1470._stdErrBuffer+=$params.data
				
			: ($worker.dataType="blob")
				
				This:C1470._stdErrBuffer+=Convert to text:C1012($params.data; This:C1470.encoding)
				
		End case 
		
		$data:=This:C1470._stdErrBuffer
		
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
				This:C1470._stdErr:=String:C10($progress; "^^0")+"%"+" "+$info
				This:C1470._stdErrBuffer:=""
				This:C1470._progress:=$progress
				
			: (Match regex:C1019("\\s*(\\d+)%[\\u0020]+(\\S+)[\\u0020]+(.+)"; $data; 1; $pos; $len))
				
				$progress:=Num:C11(Substring:C12($data; $pos{1}; $len{1}))
				$flag:=Substring:C12($data; $pos{2}; $len{2})
				$info:=Substring:C12($data; $pos{3}; $len{3})
				This:C1470._stdErr:=String:C10($progress; "^^0")+"%"+" "+$info
				This:C1470._stdErrBuffer:=""
				This:C1470._progress:=$progress
		End case 
		
		This:C1470._onDataErrorCount+=1
		
	End if 
	
Function onTerminate($worker : 4D:C1709.SystemWorker; $params : Object)
	
	//Form is an instance of the view
	//This is an instance of the controller
	
	If (Form:C1466#Null:C1517)
		
		This:C1470._progress:=0
		This:C1470._onTerminateCount+=1
		
		If (This:C1470.complete)
			//end of the queue
			OBJECT SET ENABLED:C1123(*; This:C1470._stopButtonName; False:C215)
			OBJECT SET ENABLED:C1123(*; This:C1470._startButtonName; True:C214)
			OBJECT SET VISIBLE:C603(*; This:C1470._progressIndicatorName; False:C215)
			//Form.stdOut:=""
			//Form.stdErr:=""
		End if 
		
	End if 