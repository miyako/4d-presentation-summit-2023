//%attributes = {"invisible":true}
#DECLARE($form : Object; $name : Text)->$icon : Picture

$path:=Get file from pasteboard:C976(1)

$form.BuildApp["Build"+(Is macOS:C1572 ? "Mac" : "Win")+"DestFolder"]:=$path

setup_destination_path($form.BuildApp; $form; "BuildDest")