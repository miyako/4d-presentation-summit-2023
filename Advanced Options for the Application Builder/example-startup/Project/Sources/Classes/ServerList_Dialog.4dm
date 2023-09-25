Class extends _Dialog

Class constructor
	
	Super:C1705("daemon")
	
Function connect($link : Text)
	
	If ($link#"")
		
		$folder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
		$folder.create()
		$file:=$folder.file("connect.4dlink")
		$file.setText(Form:C1466.link)
		
		ACCEPT:C269
		
		OPEN DATABASE:C1321($file.platformPath)
		
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
	
Function update($params : Object)
	
	var $col : Collection
	var $current : Text
	
	$col:=Form:C1466.servers.col
	
	If (Form:C1466.servers.item#Null:C1517)
		$current:=Form:C1466.servers.item.id
	End if 
	
	For each ($server; $params.servers)
		If ($col.query("addr == :1 and name == :2 and host == :3"; $server.addr; $server.name; $server.host).length=0)
			$server.id:=Generate UUID:C1066
			$server.icon:=Form:C1466.icon
			$server.description:="<span style=\"font-size:14;font-weight:bold;\">"+$server.host+"</span><br />"+$server.addr+":"+String:C10($server.port)+" ("+$server.name+")"
			$col.push($server)
		End if 
	End for each 
	
	Form:C1466.servers.col:=$col.orderBy("host asc")
	
	If ($current#"")
		LISTBOX SELECT ROW:C912(*; "Servers"; $col.indexOf($col.query("id == :1"; $current)[0])+1; lk replace selection:K53:1)
	End if 
	
	Form:C1466.timestamp:=String:C10(Current time:C178; HH MM SS:K7:1)
	
	Form:C1466.controller.callWorker()
	