Class constructor
	
Function getBoolValue($dom : Text; $path : Text)->$boolValue : Variant
	
	var $stringValue : Text
	var $nodes : Collection
	
	$nodes:=Split string:C1554($path; "@")
	
	If ($nodes.length>1)
		
		$attribute:=DOM Find XML element:C864($dom; $nodes[0]+"[@"+$nodes[1]+"]")
		
		If (OK=1)
			DOM GET XML ATTRIBUTE BY NAME:C728($attribute; $nodes[1]; $stringValue)
			$boolValue:=($stringValue="true")
		End if 
		
	End if 
	