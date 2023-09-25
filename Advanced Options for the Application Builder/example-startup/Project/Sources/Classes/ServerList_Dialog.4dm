Class extends _Dialog

Class constructor
	
	Super:C1705(Formula:C1597(daemon); Formula:C1597(daemon_callback))
	
Function connect($link : Text)
	
	If ($link#"")
		
		$folder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
		$folder.create()
		$file:=$folder.file("connect.4dlink")
		
		If (Not:C34(This:C1470.processIsPreemtive()))
			//%T-
			
			$file.setText(Form:C1466.link)
			
			ACCEPT:C269
			
			OPEN DATABASE:C1321($file.platformPath)
			
			//%T+
		End if 
		
	End if 
	
Function linkForServer($name : Text; $addr : Text; $port : Integer)->$linkForServer : Text
	
	$linkTemplate:=This:C1470._linkTemplate
	
	$params:=New object:C1471("name"; $name; "addr"; $addr; "port"; $port)
	
	PROCESS 4D TAGS:C816($linkTemplate; $linkForServer; $params)
	
Function run($ports : Collection)
	
	If ($ports=Null:C1517) || ($ports.length=0)
		$ports:=New collection:C1472(19813)
	End if 
	
	$params:=New object:C1471
	
	$params.title:="Connect to Server"
	$params.type:=Plain window:K34:13
	$params.name:="ServerList"
	$params.daemonParams:=New object:C1471("ports"; $ports)
	
	This:C1470._run($params)
	