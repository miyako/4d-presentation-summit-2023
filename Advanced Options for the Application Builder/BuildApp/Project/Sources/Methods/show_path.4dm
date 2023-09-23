//%attributes = {"invisible":true}
#DECLARE($form : Object; $name : Text; $suffix : Text)->$icon : Picture

$index:=$form[$name][$name+$suffix].index
$length:=$form[$name][$name+$suffix].values.length
$path:=$form[$name][$name+$suffix].values.reverse().slice(0; $length-$index).join(Folder separator:K24:12)
$form[$name][$name+$suffix].index:=0

SHOW ON DISK:C922($path)