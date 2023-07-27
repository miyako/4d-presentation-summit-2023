//%attributes = {}
var $marked : cs:C1710.Marked

$marked:=cs:C1710.Marked.new()

$htmlFile:=$marked.parseClassDocumentationFile("_CLI")

OPEN URL:C673($htmlFile.platformPath)