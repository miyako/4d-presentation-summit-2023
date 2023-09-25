//%attributes = {"invisible":true}
#DECLARE($params : Object)

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