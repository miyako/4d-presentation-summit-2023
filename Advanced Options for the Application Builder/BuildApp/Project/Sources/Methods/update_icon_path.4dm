//%attributes = {"invisible":true}
#DECLARE($form : Object; $name : Text)->$icon : Picture

$path:=Get file from pasteboard:C976(1)

Case of 
	: ($name="ClientMac") || ($name="ClientWin")
		$form.BuildApp.SourcesFiles.CS[$name+"IconForMac"]:=$path
		$form.BuildApp.SourcesFiles.CS[$name+"IconForWin"]:=$path
	: ($name="Server")
		$form.BuildApp.SourcesFiles.CS[$name+"Icon"+(Is macOS:C1572 ? "Mac" : "Win")+"Path"]:=$path
	Else 
		$form.BuildApp.SourcesFiles[$name][$name+"Icon"+(Is macOS:C1572 ? "Mac" : "Win")+"Path"]:=$path
End case 

$form[$name+"Icon"]:=setup_icon_path($form.BuildApp; $form; $name)