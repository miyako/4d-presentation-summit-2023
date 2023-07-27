//%attributes = {}
$marked:=cs:C1710.Marked.new()

$mdFile:=$marked.getClassDocumentationFile("_CLI")

If ($mdFile.exists)
	
	$htmlFile:=$marked.parse($mdFile)
	
	OPEN URL:C673($htmlFile.platformPath)
	
End if 