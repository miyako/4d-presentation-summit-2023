Class constructor
	
	//MARK:-public methods
	
Function escape($in : Text)->$out : Text
	
	$out:=$in
	
	var $i; $len : Integer
	
	Case of 
		: (Is Windows:C1573)
			
/*
argument escape for cmd.exe; other programs may be incompatible
*/
			
			$shoudQuote:=False:C215
			
			$metacharacters:="&|<>()%^\" "
			
			$len:=Length:C16($metacharacters)
			
			For ($i; 1; $len)
				$metacharacter:=Substring:C12($metacharacters; $i; 1)
				$shoudQuote:=$shoudQuote | (Position:C15($metacharacter; $out; *)#0)
				If ($shoudQuote)
					$i:=$len
				End if 
			End for 
			
			If ($shoudQuote)
				If (Substring:C12($out; Length:C16($out))="\\")
					$out:="\""+$out+"\\\""
				Else 
					$out:="\""+$out+"\""
				End if 
			End if 
			
		: (Is macOS:C1572)
			
/*
argument escape for bash or zsh; other programs may be incompatible
*/
			
			$metacharacters:="\\!\"#$%&'()=~|<>?;*`[] "
			
			For ($i; 1; Length:C16($metacharacters))
				$metacharacter:=Substring:C12($metacharacters; $i; 1)
				$out:=Replace string:C233($out; $metacharacter; "\\"+$metacharacter; *)
			End for 
			
	End case 
	
Function quote($in : Text)->$out : Text
	
	$out:="\""+$in+"\""
	
	//MARK:-private methods
	
Function _chmod($file : 4D:C1709.File)
	
	If (Is macOS:C1572)
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $file.parent.platformPath)
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true")
		LAUNCH EXTERNAL PROCESS:C811("chmod +x "+This:C1470.escape($file.fullName))
	End if 
	
Function launch($buildProject : 4D:C1709.File; $compileProject : 4D:C1709.File)
	
	$tool4d:=Folder:C1567(fk applications folder:K87:20).folder("4D v20.1").folder("100755").folder("tool4d.app").folder("Contents").folder("MacOS").file("tool4d")
	
	$command:=This:C1470.escape($tool4d.path)
	$command:=$command+" /Users/miyako/Documents/GitHub/4d-presentation-summit-2023/Advanced\\ Options\\ for\\ the\\ Application\\ Builder/build-application/Project/build-application.4DProject"
	$command:=$command+" "+This:C1470.escape($compileProject.path)
	$command:=$command+" --startup-method=build"
	$command:=$command+" --user-param="+This:C1470.escape($buildProject.path)+","+This:C1470.escape($compileProject.path)
	
	$command:="osascript"+" -e 'tell application \"Terminal\" to activate\r' -e 'tell application \"Terminal\" to do script \""+Replace string:C233($command; "\\"; "\\\\"; *)+"\"'"
	
	$folder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
	$folder.create()
	
	$folder:=Folder:C1567(fk desktop folder:K87:19)
	
	$file:=$folder.file("tool4d.sh")
	$file.setText($command)
	
	LAUNCH EXTERNAL PROCESS:C811("/bin/sh "+This:C1470.escape($file.path))
	