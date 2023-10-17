//%attributes = {"invisible":true}
#DECLARE($form : Object; $name : Text)->$icon : Picture

$path:=Get file from pasteboard:C976(1)

Case of 
	: ($name="DatabaseToEmbedInClientMac") || ($name="DatabaseToEmbedInClientWin")
		$form.BuildApp.SourcesFiles.CS[$name+"Folder"]:=$path
	: ($name="MacCompiledDatabaseToWin")
		$form.BuildApp.CS[$name]:=$path
	: ($name="Server")
		$form.BuildApp.SourcesFiles.CS[$name+(Is macOS:C1572 ? "Mac" : "Win")+"Folder"]:=$path
	Else 
		$form.BuildApp.SourcesFiles[$name][$name+(Is macOS:C1572 ? "Mac" : "Win")+"Folder"]:=$path
		If ($name="RuntimeVL")
			If (Is macOS:C1572)
				$form.BuildApp.SourcesFiles.CS.ClientMacFolderToMac:=$path
			Else 
				$form.BuildApp.SourcesFiles.CS.ClientWinFolderToWin:=$path
			End if 
		End if 
End case 

$form[$name+"ApplicationIcon"]:=setup_application_path($form.BuildApp; $form; $name)
