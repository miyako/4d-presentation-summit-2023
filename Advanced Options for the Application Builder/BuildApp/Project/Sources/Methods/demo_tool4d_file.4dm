//%attributes = {"invisible":true}
#DECLARE()->$file : 4D:C1709.File

If (Is macOS:C1572)
	$file:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("tool4d.app").folder("Contents").folder("MacOS").file("tool4d")
Else 
	$file:=Folder:C1567(fk applications folder:K87:20).parent.folder("Program Files").folder("4D").folder("4D v20.1").folder("tool4d").file("tool4d.exe")
End if 