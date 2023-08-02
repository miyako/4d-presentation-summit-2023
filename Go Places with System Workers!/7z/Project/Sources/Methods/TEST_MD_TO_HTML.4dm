//%attributes = {}
var $marked : cs:C1710.Marked

$marked:=cs:C1710.Marked.new()

$path:=METHOD Get path:C1164(Path class:K72:19; "_CLI")

$htmlFile:=$marked.generate($path)

OPEN URL:C673($htmlFile.platformPath)