# Advanced Options for the Application Builder

## Teaser Message

Do you build your 4D app? Do you have an XML project to configure your application exactly how it ought to be deployed? This session will explain the benefits of building your 4D app and how to take full advantage of various build options, most of which are not exposed in the standard application build tool.

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
|v19|ServerStructureFolderName||✓||
|v19|ClientServerSystemFolderName||✓||

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
|v20|[MacCompiledDatabaseToWinIncludeIt](https://doc.4d.com/4Dv20/4D/20/MacCompiledDatabaseToWinIncludeIt.300-6335771.en.html)|✓|✓||
|v20|[MacCompiledDatabaseToWin](https://doc.4d.com/4Dv20/4D/20/MacCompiledDatabaseToWin.300-6335772.en.html)|✓|✓||

#### Packaging

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
||ArrayExcludedComponentName|✓|✓|removes 4D SVG, 4D Progress, 4D ViewPro, 4D NetKit, 4D WritePro Interface, 4D Mobile App Server, 4D Widgets, 3rd party components|
||ArrayExcludedPluginID|✓|✓|removes 4D authored plugins|
||ArrayExcludedPluginName|✓|✓|removes 3rd party plugins|
||IncludeAssociatedFolders|✓|✓|removes Plugins, Resources, Components, Extras|
|v20|[ArrayExcludedModuleName](https://doc.4d.com/4Dv20/4D/20/ArrayExcludedModuleName.300-6335787.en.html)|✓|✓|removes CEF, MeCab, PHP, SpellChecker, 4D Updater|

#### Installation

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
|v16|LastDataPathLookup|✓|✓||
|v18|ClientWinSingleInstance||✓||
|v20|[ShareLocalResourcesOnWindowsClient](https://doc.4d.com/4Dv20/4D/20/ShareLocalResourcesOnWindowsClient.300-6335754.en.html)||✓||
|v20|[ClientUserPreferencesFolderByPath](https://doc.4d.com/4Dv20/4D/20/ClientUserPreferencesFolderByPath.300-6335755.en.html)||✓||

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
|v20|[ServerDataCollection](https://doc.4d.com/4Dv20/4D/20/ServerDataCollection.300-6335775.en.html)||✓||

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
|v20|[HideDataExplorerMenuItem](https://doc.4d.com/4Dv20/4D/20/HideDataExplorerMenuItem.300-6335756.en.html)||✓||
|v20|[HideRuntimeExplorerMenuItem](https://doc.4d.com/4Dv20/4D/20/HideRuntimeExplorerMenuItem.300-6335774.en.html)||✓||
|v20|[ServerEmbedsProjectDirectoryFile](https://doc.4d.com/4Dv20/4D/20/ServerEmbedsProjectDirectoryFile.300-6335773.en.html)||✓||
|v20|[UseStandardZipFormat](https://doc.4d.com/4Dv20/4D/20/UseStandardZipFormat.300-6335800.en.html)||✓|generates scrambled and encrypted .4DZ|
|v20|[HideAdministrationMenuItem](https://doc.4d.com/4Dv20/4D/20/HideAdministrationMenuItem.300-6336259.en.html)||✓|[disable server admin](https://blog.4d.com/integrate-your-own-administration-window-for-4d-server/)|

## Branding

#### Legacy Instructions

* Standard

<!-- <img width="360" alt="" src="https://user-images.githubusercontent.com/1725068/220619223-492a0df4-fdda-4040-a7d9-a14c8dd4ae23.png" /> -->

<img width="360" alt="" src="https://github.com/miyako/4d-presentation-summit-2023/assets/1725068/e5bf04ed-a32e-4ec6-9519-89b636f6b438" />

* No List

<!-- <img width="360" alt="" src="https://user-images.githubusercontent.com/1725068/221106408-a7b8cba1-bcc6-4895-88b2-11863085d139.png"> -->

<img width="360" alt="" src="https://github.com/miyako/4d-presentation-summit-2023/assets/1725068/79e6cdc5-5e14-4632-8912-230cf7ce0af0" />

* No Edit

<!-- <img width="360" alt="" src="https://user-images.githubusercontent.com/1725068/221106422-970ba3c0-6dec-4cad-beb0-2d60f8a00b5b.png"> -->

<img width="360" alt="" src="https://github.com/miyako/4d-presentation-summit-2023/assets/1725068/53f8daa5-77ac-4941-9691-1694cf790a40" />

The 4D logo on the user login dialog can be replaced by a custom icon file[^loginimage]. The file format must be `.png`.

* Name: *LoginImage.png*  
* Location: Resources folder (old specification: adjacent to the project folder) 
* Size: Any (old specification: `80x80`)

<!-- <img width="64" alt="icon" src="https://user-images.githubusercontent.com/1725068/220619757-ba13915a-904a-4b1e-ae2d-772ad1d3d182.png" /> -->

<img width="64" alt="icon" src="https://github.com/miyako/4d-presentation-summit-2023/assets/1725068/85763d0e-eef3-44f0-a96e-d8238c2fde36" />

The 4D application icon[^CustomIcon] can be replaced by a custom icon file. The file format must be `.icns`[^icns] on Mac and `.ico`[^ico] on Windows. 

* Name: Same as the project file   
* Location: Adjacent to the project folder  
* Size: According to platform standards (`1024x1024` for Mac, `256x256` for Windows)  

#### Support High Resolution

It is recommended to use specialised tools to create a multi-resolution icon file with an alpha channel. If you use a paint application or image converter to export your icon file, make sure the generate file contains multiple resolutions.

* For Mac, the standard tool is `iconutil`[^iconutil]

* For Windows, there are various 3rd party tools and online services that can create composite `.ico` files. `go-png2ico`[^go-png2ico] is one such example.

#### Benefits of Using Advanced Options

With the easy configuration your server, client and desktop apps will all share the same icon. XML keys allow you to better manage your app's public profile.

## Sidebar: Hi-DPI support 

T.B.C.

## Sidebar: Name vs Indentifiler on Mac

T.B.C.

## Sidebar: The Sponsor Message 

![PoweredBy4D-v19](https://user-images.githubusercontent.com/1725068/220621767-fa600ec1-df01-4e50-b75d-cbbf7789db4f.png)

T.B.C.

## Hybrid Desktop

Some ideas:

* Clear Local Cache before connecting to server

## More custumisation

* [Help Menu](https://blog.4d.com/create-a-help-menu-with-a-simple-collection/)



[^hybrid]: An app merged with *4D Volume Desktop* that intially launches as a desktop app instead of a client app that automatically connecting to a peer server. The startup project can execute with or without a local database. (v18 or later)

[^loginimage]: [4D Design Reference > Users and groups > Access system overview](https://doc.4d.com/4Dv19/4D/19/Access-system-overview.300-5416896.en.html)

[^CustomIcon]: [4D Design Reference > Finalizing and deploying final applications > Customizing a stand-alone application icon](https://doc.4d.com/4Dv19/4D/19/Customizing-a-stand-alone-application-icon.300-5416835.en.html)

[^iconutil]: [Optimizing for High Resolution](https://developer.apple.com/library/archive/documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html)

[^icns]: [Foundations > Design > App icons](https://developer.apple.com/design/human-interface-guidelines/foundations/app-icons)

[^ico]: [Win32 > Design > Icons](https://learn.microsoft.com/en-us/windows/win32/uxguide/vis-icons)

[^go-png2ico]: [J-Siu > go-png2ico](https://github.com/J-Siu/go-png2ico/)
