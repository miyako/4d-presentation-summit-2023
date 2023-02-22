# Advanced Options for the Application Builder

## Synopsis 

Present the benefits of building a server, client, desktop, or *hybrid*[^hybrid] app.

Explain how the basic options available in the [Build Application](https://developer.4d.com/docs/Desktop/building/) tool are just a subset of what is actually possible using the more advanced [`BUILD APPLICATION`](https://doc.4d.com/4Dv19/4D/19.5/BUILD-APPLICATION.301-6137056.en.html) command.

Show some of the powerful options that adds value to the product or enhances the user experience.

## Tool vs Command

The [Build Application](https://developer.4d.com/docs/Desktop/building/) tool allows the developer to quickly configure their build project with basic parameters. The tool automatically generates a *BuildApp.xml* project file and internally calls the [`BUILD APPLICATION`](https://doc.4d.com/4Dv19/4D/19.5/BUILD-APPLICATION.301-6137056.en.html) command.

The table below shows how the options available in the tool are just a subset of what is acutally defined in the specification.

xxx = Mac/Win xxxxx=Client/Common/RuntimeVL/Server

#### Branding

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
||BuildApplicationName|✓|✓||
||ServerIconxxxPath||✓||
||ClientxxxIconForxxxPath||✓||
||RuntimeVLIconxxxPath||✓||
||xxxxxVersion||✓||
||xxxxxCopyright||✓||
||xxxxxCreator||✓||
||xxxxxComment||✓||
||xxxxxCompanyName||✓||
||xxxxxFileDescription||✓||
||xxxxxInternalName||✓||
||xxxxxLegalTrademark||✓||
||xxxxxPrivateBuild||✓||
||xxxxxSpecialBuild||✓||

#### Setup

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
||BuildCompiled|✓|✓|build .4DC or .4DZ|
||BuildComponent|✓|✓||
||BuildApplicationSerialized|✓|✓|build desktop app|
||BuildCSUpgradeable|✓|✓||
||BuildServerApplication|✓|✓|build server and/or client app|
||BuildxxxDestFolder|✓|✓|relative or absolute patform path|
||ServerIncludeIt|✓|✓||
||ClientxxxIncludeIt|✓|✓||
||RuntimeVLIncludeIt|✓|✓||
||ServerxxxFolder|✓|✓||
||ClientxxxFolderToxxx|✓|✓||
||RuntimeVLxxxFolder|✓|✓||
||DataFilePath||✓|relative or absolute patform path|
||IPAddress||✓||
||PortNumber||✓||
|v18|DatabaseToEmbedInClientxxxFolder ||✓||
|v20|MacCompiledDatabaseToWinIncludeIt|✓|✓||
|v20|MacCompiledDatabaseToWin|✓|✓||

#### Packaging

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
||ArrayExcludedComponentName|✓|✓|removes 4D SVG, 4D Progress, 4D ViewPro, 4D NetKit, 4D WritePro Interface, 4D Mobile App Server, 4D Widgets, 3rd party components|
||ArrayExcludedPluginID|✓|✓|removes 4D authored plugins|
||ArrayExcludedPluginName|✓|✓|removes 3rd party plugins|
||IncludeAssociatedFolders|✓|✓|removes Plugins, Resources, Components, Extras|
|v20|ArrayExcludedModuleName|✓|✓|removes CEF, MeCab, PHP, SpellChecker, 4D Updater|

#### Installation

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
|v16|LastDataPathLookup|✓|✓||
|v18|ClientWinSingleInstance||✓||
|v19|ServerStructureFolderName||✓||
|v19|ClientServerSystemFolderName||✓||
|v20|ShareLocalResourcesOnWindowsClient||✓||
|v20|ClientUserPreferencesFolderByPath||✓||

#### Client Auto Update

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
||CurrentVers|✓|✓||
||RangeVersMin||✓||
||RangeVersMax||✓||
|v14|StartElevated||✓|request admin privileges|

#### Miscellaneous

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
|v20|ServerDataCollection||✓||

#### Licensing

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
||ArrayLicensexxx|✓|✓||
||IsOEM||✓||

#### Security

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
||HardLink||✓||
|v14|MacSignature|✓|✓||
|v14|MacCertificate|✓|✓||
|v16|ServerSelectionAllowed||✓||
|v19|AdHocSign|✓|✓||
|v19|PackProject||✓|generates alterable project|
|v20|HideDataExplorerMenuItem||✓||
|v20|HideRuntimeExplorerMenuItem||✓||
|v20|ServerEmbedsProjectDirectoryFile||✓||
|v20|UseStandardZipFormat||✓|generates scrambled and encrypted .4DZ|

## Branding

#### Legacy Instructions

The 4D logo on the user login dialog can be replaced by an image file named *LoginImage.png*[^loginimage] placed in the project folder. The file must be a `.png` image and its size must be `80x80`.

The 4D application icon[^CustomIcon] can be replaced by an icon file named after the structure file or project name. The file must be a `.icns` image on Mac or `.ico` on Windows.








[^hybrid]: An app merged with *4D Volume Desktop* that intially launches as a desktop app instead of a client app that automatically connecting to a peer server. The startup project can execute with or without a local database. (v18 or later)

[^loginimage]: [4D Design Reference > Users and groups > Access system overview](https://doc.4d.com/4Dv19/4D/19/Access-system-overview.300-5416896.en.html)

[^CustomIcon]: [4D Design Reference > Finalizing and deploying final applications > Customizing a stand-alone application icon](https://doc.4d.com/4Dv19/4D/19/Customizing-a-stand-alone-application-icon.300-5416835.en.html)
