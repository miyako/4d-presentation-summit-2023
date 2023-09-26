//%attributes = {"invisible":true}
#DECLARE()->$path : Text

If (Is macOS:C1572)
	$path:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("4D Volume Desktop.app").platformPath
Else 
	$path:=Folder:C1567(fk applications folder:K87:20).parent.folder("Program Files").folder("4D").folder("4D v20.1").folder("4D Volume Desktop").platformPath
End if 