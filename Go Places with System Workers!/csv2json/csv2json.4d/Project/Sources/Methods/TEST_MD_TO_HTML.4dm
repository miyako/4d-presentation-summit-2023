//%attributes = {"invisible":true}
var $marked : cs:C1710._Marked

$marked:=cs:C1710._Marked.new()

$path:=METHOD Get path:C1164(Path class:K72:19; "_CLI")

$htmlFile:=$marked.generate($path)

OPEN URL:C673($htmlFile.platformPath)