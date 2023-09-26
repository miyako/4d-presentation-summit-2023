//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($windowNumber : Integer; $daemonParams : Object; $callback : 4D:C1709.Function)

$params:=New object:C1471

var $servers : Collection

$servers:=New collection:C1472

If ($daemonParams.ports#Null:C1517) && (Value type:C1509($daemonParams.ports)=Is collection:K8:32)
	
	var $port : Integer
	
	If ($daemonParams.ports.length#0)
		For each ($port; $daemonParams.ports)
			If (Is macOS:C1572)
				$options:=New object:C1471("wait"; 1; "port"; $port)
				$list:=UDP Get server list($options)
				For each ($item; $list)
					$item.port:=$port
				End for each 
				$servers.combine($list)
			End if 
		End for each 
	End if 
End if 

$params.servers:=$servers

CALL FORM:C1391($windowNumber; $callback; $params)

DELAY PROCESS:C323(Current process:C322; 120)