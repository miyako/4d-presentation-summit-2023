property _linkTemplate : Text
property workerName : Text
property workerFunction; workerCallbackFunction : 4D:C1709.Function
property windowNumber : Integer
property daemonParams : Object

Class constructor($workerFunction : 4D:C1709.Function; $workerCallbackFunction : 4D:C1709.Function)
	
	This:C1470.workerFunction:=$workerFunction
	This:C1470.workerCallbackFunction:=$workerCallbackFunction
	
Function get formIdentifier()->$formIdentifier : Text
	
	var $table : Pointer
	var $name : Text
	
	If (Not:C34(This:C1470.processIsPreemtive()))
		//%T-
		$table:=Current form table:C627
		$name:=Current form name:C1298
		//%T+
	End if 
	
	If (Is nil pointer:C315($table))
		$formIdentifier:=$name
	Else 
		$formIdentifier:="["+Table name:C256($table)+"]"+$name
	End if 
	
	//MARK:-public methods
	
Function callWorker()->$this : cs:C1710._Dialog
	
	$this:=This:C1470
	
	$this.workerName:=New collection:C1472(OB Class:C1730(This:C1470).name; "#"; $this.windowNumber).join("")
	
	$callback:=$this.update
	
	If (OB Instance of:C1731($this.workerFunction; 4D:C1709.Function)) && (OB Instance of:C1731($this.workerCallbackFunction; 4D:C1709.Function))
		CALL WORKER:C1389($this.workerName; $this.workerFunction; $this.windowNumber; $this.daemonParams; $this.workerCallbackFunction)
	End if 
	
Function killWorker()->$this : cs:C1710._Dialog
	
	$this:=This:C1470
	
	If ($this.worker#Null:C1517)
		KILL WORKER:C1390($this.worker)
		$this.worker:=Null:C1517
	End if 
	
Function openWindow($formRect : Object; $windowType : Integer; $title : Text)->$windowNumber : Integer
	
	If (Not:C34(This:C1470.processIsPreemtive()))
		//%T-
		If ($formRect.x=0) & ($formRect.y=0)
			C_LONGINT:C283($left; $top; $right; $bottom; $screen)
			$screen:=Menu bar screen:C441
			SCREEN COORDINATES:C438($left; $top; $right; $bottom; $screen)
			$cx:=($right-$left)/2
			$cy:=($bottom-$top)/2
			$formRect.x:=$cx-($formRect.width/2)
			$formRect.y:=$cy-($formRect.height/2)
		End if 
		$method:=Formula:C1597(dialog_generic_close).source
		$windowNumber:=Open window:C153($formRect.x; $formRect.y; $formRect.x+$formRect.width; $formRect.y+$formRect.height; $windowType; $title; $method)
		//%T+
	End if 
	
Function processIsPreemtive($process : Integer)->$processIsPreemtive : Boolean
	
	var $state; $mode; $processNumber : Integer
	var $time : Real
	
	If (Count parameters:C259#0)
		$processNumber:=$process
	Else 
		$processNumber:=Current process:C322
	End if 
	
	PROCESS PROPERTIES:C336($processNumber; $name; $state; $time; $mode)
	
	$processIsPreemtive:=$mode ?? 1
	
Function setWindowBounds($formIdentifier : Text; $context : Variant)
	
	$status:=This:C1470._parseFormIdentifier($formIdentifier)
	
	If ($status#Null:C1517)
		
		var $tableName; $formName : Text
		$tableName:=$status.table
		$formName:=$status.form
		
		$formFile:=This:C1470._getWindowBoundsFile($tableName; $formName)
		
		var $formRect : Object
		
		If (Not:C34(This:C1470.processIsPreemtive()))
			//%T-
			$window:=Current form window:C827
			//%T+
			If ($window#0)
				
				var $left; $top : Real
				var $x; $y; $right; $bottom; $screen; $s : Integer
				
				//%T-
				GET WINDOW RECT:C443($x; $y; $right; $bottom; $window)
				var $sleft; $stop; $sright; $sbottom : Integer
				$screen:=Menu bar screen:C441
				SCREEN COORDINATES:C438($sleft; $stop; $sright; $sbottom; $screen)
				$left:=($x-$sleft)/($sright-$sleft)
				$top:=($y-$stop)/($sbottom-$stop)
				For ($s; 1; Count screens:C437)
					SCREEN COORDINATES:C438($sleft; $stop; $sright; $sbottom; $s)
					If ($x>=$sleft) & ($x<=$sright) & ($y>=$stop) & ($y<=$sbottom)
						$screen:=$s
						$left:=($x-$sleft)/($sright-$sleft)
						$top:=($y-$stop)/($sbottom-$stop)
					End if 
				End for 
				//%T+
				$formRect:=New object:C1471("x"; $x; "y"; $y; "width"; $right-$x; "height"; $bottom-$y; "screen"; $screen; "left"; $left; "top"; $top)
				
				If (Count parameters:C259>1)
					C_BLOB:C604($data)
					VARIABLE TO BLOB:C532($context; $data)
					$formRect.context:=Generate digest:C1147($data; SHA256 digest:K66:4)
				End if 
				
				$formFile.setText(JSON Stringify:C1217($formRect; *))
				
			End if 
			
		End if 
		
	End if 
	
Function getWindowBounds($formIdentifier : Text; $width : Integer; $height : Integer)->$formRect : Object
	
	$status:=This:C1470._parseFormIdentifier($formIdentifier)
	
	If ($status#Null:C1517)
		
		var $tableName; $formName : Text
		var $formFile : 4D:C1709.File
		
		$tableName:=$status.table
		$formName:=$status.form
		
		$formFile:=This:C1470._getWindowBoundsFile($tableName; $formName)
		
		var $left; $top; $right; $bottom : Integer
		
		If (Not:C34(This:C1470.processIsPreemtive()))
			//%T-
			$screen:=Menu bar screen:C441
			SCREEN COORDINATES:C438($left; $top; $right; $bottom; $screen; Screen work area:K27:10)
			//%T+
		End if 
		
		If ($formFile#Null:C1517) && ($formFile.exists)
			$json:=$formFile.getText("utf-8"; Document with CR:K24:21)
			$formRect:=JSON Parse:C1218($json; Is object:K8:27)
		Else 
			
			If (Not:C34(This:C1470.processIsPreemtive()))
				//%T-
				If (Count parameters:C259<3)
					If ($tableName="{projectForm}")
						FORM GET PROPERTIES:C674($formName; $width; $height)
					Else 
						$tableNumber:=ds:C1482[$tableName].getInfo().tableNumber
						C_POINTER:C301($table)
						$table:=Table:C252($tableNumber)
						FORM GET PROPERTIES:C674($table->; $formName; $width; $height)
					End if 
				End if 
				//%T+
				$formRect:=New object:C1471("x"; 0; "y"; 0; "width"; $width; "height"; $height; "screen"; $screen; "left"; 0; "top"; 0)
			End if 
			
		End if 
		
		If ($formRect#Null:C1517)
			
			var $x; $y; $s : Integer
			
			If (Not:C34(This:C1470.processIsPreemtive()))
				//%T-
				$s:=Menu bar screen:C441
				SCREEN COORDINATES:C438($sleft; $stop; $sright; $sbottom; $s)
				$x:=$formRect.left*($sright-$sleft)
				$y:=$formRect.top*($sbottom-$stop)
				If ($s#$formRect.screen)
					SCREEN COORDINATES:C438($sleft; $stop; $sright; $sbottom; $formRect.screen)
					If ($formRect.x>=$sleft) & ($formRect.x<=$sright) & ($formRect.y>=$stop) & ($formRect.y<=$sbottom)
						$x:=$formRect.x
						$y:=$formRect.y
					End if 
				End if 
				//%T+
			End if 
			
			$formRect.x:=$x
			$formRect.y:=$y
			
		End if 
		
	End if 
	
	//MARK:-private methods
	
Function _activateWindow($windowNumber : Integer)
	
	If (Not:C34(This:C1470.processIsPreemtive()))
		//%T-
		GET WINDOW RECT:C443($x; $y; $r; $b; $windowNumber)
		SET WINDOW RECT:C444($x; $y; $r; $b; $windowNumber)
		//%T+
	End if 
	
Function _dialog($params : Object)
	
	var $name; $title : Text
	
	$name:=$params.name
	$title:=$params.title
	
	var $windowType : Integer
	
	$windowType:=$params.type
	
	var $formIdentifier : Object
	
	$formIdentifier:=$params.controller._parseFormIdentifier($name)
	
	$params.controller.daemonParams:=$params.daemonParams
	
	If (Not:C34($params.controller.processIsPreemtive()))
		//%T-
		If ($formIdentifier.table="{projectForm}")
			var $name : Text
			$name:=$params.name
			FORM GET PROPERTIES:C674($name; $width; $height)
			$formRect:=$params.controller.getWindowBounds($params.name; $width; $height)
			$params.controller.windowNumber:=$params.controller.openWindow($formRect; $windowType; $title)
			DIALOG:C40($params.name; $params; *)
		Else 
			$formRect:=$params.controller.getWindowBounds($params.name)
			$params.controller.windowNumber:=This:C1470.openWindow($formRect; $windowType; $title)
			$table:=Table:C252($formIdentifier.tableNumber)
			DIALOG:C40($table->; $formIdentifier.form; $params; *)
		End if 
		//%T+
	End if 
	
Function _findUserWindow()->$windowNumber : Integer
	
	C_TEXT:C284($1; $titleToSearch)
	C_LONGINT:C283($0; $match)
	
	$titleToSearch:=$1
	
	$windowNumbers:=This:C1470._userWindows()
	
	C_LONGINT:C283($window)
	
	If (Not:C34(This:C1470.processIsPreemtive()))
		//%T-
		For each ($window; $windowNumbers) Until ($match#0)
			$title:=Get window title:C450($window)
			If ($title=$titleToSearch)
				$windowNumber:=$window
			End if 
		End for each 
		//%T+
	End if 
	
Function _getWindowBoundsFile($tableName : Text; $formName : Text)->$file : 4D:C1709.File
	
	If ($tableName#"") && ($formName#"")
		
		$file:=Folder:C1567("/LOGS/").folder($tableName).file($formName+".json")
		
	End if 
	
Function _parseFormIdentifier($formIdentifier : Text)->$status : Object
	
	$status:=New object:C1471("table"; Null:C1517; "form"; Null:C1517; "tableNumber"; Null:C1517)
	
	ARRAY LONGINT:C221($pos; 0)
	ARRAY LONGINT:C221($len; 0)
	
	If (Match regex:C1019("\\[([^]]+)\\](.+)"; $formIdentifier; 1; $pos; $len))
		
		$status.table:=Substring:C12($formIdentifier; $pos{1}; $len{1})
		$status.form:=Substring:C12($formIdentifier; $pos{2}; $len{2})
		
		var $table : Text
		
		If (Not:C34(This:C1470.processIsPreemtive()))
			//%T-
			$table:=Parse formula:C1576("["+$status.table+"]"; Formula out with tokens:K88:3)
			//%T+
		End if 
		
		If (Match regex:C1019("\\[[^:]+:(\\d+)\\]"; $table; 1; $pos; $len))
			$status.tableNumber:=Num:C11(Substring:C12($table; $pos{1}; $len{1}))
		End if 
		
	Else 
		
		$status.table:="{projectForm}"
		$status.form:=$formIdentifier
		
	End if 
	
Function _run($params : Object)
	
	This:C1470._linkTemplate:=Folder:C1567(fk resources folder:K87:11).file("linkTemplate.4DLink").getText()
	
	$params.controller:=This:C1470
	
	var $title : Text
	
	$title:=$params.title
	
	var $windowNumber : Integer
	
	$windowNumber:=This:C1470._findUserWindow($title)
	
	If ($windowNumber#0)
		This:C1470._activateWindow($windowNumber)
	Else 
		
		CALL WORKER:C1389(1; This:C1470._dialog; $params)
		
	End if 
	
Function _userWindows()->$windowNumbers : Collection
	
	$windowNumbers:=New collection:C1472
	
	$processes:=Get process activity:C1495(Processes only:K5:35)
	$userInterfaceProcesses:=$processes.processes.query("type === :1"; Main process:K36:10)
	
	If ($userInterfaceProcesses.length#0)
		
		$userInterfaceProcess:=$userInterfaceProcesses[0]
		
		If (Not:C34(This:C1470.processIsPreemtive()))
			//%T-
			ARRAY LONGINT:C221($windows; 0)
			WINDOW LIST:C442($windows; *)
			For ($i; 1; Size of array:C274($windows))
				$windowNumber:=$windows{$i}
				If (Window process:C446($windowNumber)=$userInterfaceProcess.number)
					$windowNumbers.push($windowNumber)
				End if 
			End for 
			//%T+
		End if 
		
	End if 
	