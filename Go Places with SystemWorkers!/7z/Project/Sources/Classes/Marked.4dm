property url; area : Text  //option for <span style="font-weight:bold;color:royalblue;">WA Run offscreen area</span>
property result : 4D:C1709.File  //result from <span style="font-weight:bold;color:royalblue;">WA Run offscreen area</span>

Class constructor
	
	Case of 
		: (Is macOS:C1572)
			This:C1470._platform:="macOS"
			This:C1470._contentsFolder:=Folder:C1567(Application file:C491; fk platform path:K87:2).folder("Contents")
		: (Is Windows:C1573)
			This:C1470._platform:="Windows"
			This:C1470._contentsFolder:=File:C1566(Application file:C491; fk platform path:K87:2).parent.folder("Contents")
	End case 
	
	This:C1470._rootFolderName:="documentation"
	This:C1470._indexPageName:="index.html"
	
	This:C1470._libraryRootFolder:=This:C1470._contentsFolder\
		.folder("Resources")\
		.folder("Internal Components")\
		.folder("development.4dbase")\
		.folder("Resources")\
		.folder(This:C1470._rootFolderName)
	
	This:C1470.url:=This:C1470._getIndexPage()
	This:C1470.area:="Marked"
	This:C1470.onEvent:=This:C1470._onEvent
	
	//MARK:-private
	
Function _getIndexPage()->$indexPage : 4D:C1709.File
	
	$indexPage:=This:C1470._libraryRootFolder.file(This:C1470._indexPageName)
	
Function _createTempFolder()->$folder : 4D:C1709.Folder
	
	var $tempFolder : 4D:C1709.Folder
	
	$tempFolder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
	$tempFolder.create()
	
	This:C1470._libraryRootFolder.copyTo($tempFolder)
	
	$folder:=$tempFolder.folder(This:C1470._rootFolderName)
	
Function _onEvent()
	
	var $event : Object
	
	$event:=FORM Event:C1606
	
	Case of 
		: ($event.code=On Load:K2:1)
			
			This:C1470._html:=""
			
		: ($event.code=On End URL Loading:K2:47)
			
			WA EXECUTE JAVASCRIPT FUNCTION:C1043(*; This:C1470.area; "refresh"; *; This:C1470._md)
			
			This:C1470._html:=WA Get page content:C1038(*; This:C1470.area)
			
			This:C1470.result:=This:C1470._createTempFolder().file("index.html")
			
			This:C1470.result.setText(This:C1470._html)
			
		: ($event.code=On Unload:K2:2)
			
			This:C1470._html:=""
			
	End case 
	
	//MARK:-public
	
Function parse($mdFile : 4D:C1709.File)->$htmlFile : 4D:C1709.File
	
	This:C1470._md:=$mdFile.getText()
	
	$htmlFile:=WA Run offscreen area:C1727(This:C1470)
	
Function getClassDocumentationFile($className : Text)->$file : 4D:C1709.File
	
	$file:=Folder:C1567(fk database folder:K87:14).folder("Documentation").folder("Classes").file($className+".md")
	
Function parseClassDocumentationFile($className : Text)->$htmlFile : 4D:C1709.File
	
	var $mdFile : 4D:C1709.File
	
	$mdFile:=This:C1470.getClassDocumentationFile($className)
	
	If ($mdFile.exists)
		
		$htmlFile:=This:C1470.parse($mdFile)
		
	End if 