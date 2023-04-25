$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)

$tar:=Folder:C1567(fk desktop folder:K87:19).file("abc.tar")

//If ($tar.exists)
//$tar.delete()
//End if 

Form:C1466.clear()

$zip:=Folder:C1567(fk desktop folder:K87:19).file("abc.7z")

Form:C1466.sevenZip.add($tar; New collection:C1472($app)).add($zip; New collection:C1472($tar))

OBJECT SET ENABLED:C1123(*; "button^stop"; True:C214)
OBJECT SET ENABLED:C1123(*; "button^TEST"; False:C215)