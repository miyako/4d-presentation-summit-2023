# Advanced Options for the Application Builder

## Synopsis 

Present the benefits of building a server, client, desktop, or *hybrid*[^hybrid] app.

Explain how the basic options available in the [Build Application](https://developer.4d.com/docs/Desktop/building/) tool are just a subset of what is actually possible using the more advanced [`BUILD APPLICATION`](https://doc.4d.com/4Dv19/4D/19.5/BUILD-APPLICATION.301-6137056.en.html) command.

Show some of the powerful options that adds value to the product or enhances the user experience.

### Tool vs Command

The [Build Application](https://developer.4d.com/docs/Desktop/building/) tool allows the developer to quickly configure their build project with basic parameters. The tool automatically generates a *BuildApp.xml* project file and internally calls the [`BUILD APPLICATION`](https://doc.4d.com/4Dv19/4D/19.5/BUILD-APPLICATION.301-6137056.en.html) command.

The table below shows how the options available in the tool are just a subset of what is acutally defined in the specification.

xxx = Mac/Win

| Version | Key | Tool | Command | Remarks |
|:-------:|:---|:----:|:-------:|:-------|
||BuildApplicationName|✓|✓||
||BuildCompiled|✓|✓|generates .4DC or .4DZ|
||BuildComponent|✓|✓||
||BuildApplicationSerialized|✓|✓|generates desktop app|
||BuildCSUpgradeable|✓|✓||
||BuildServerApplication|✓|✓||
||BuildxxxDestFolder|✓|✓|relative or absolute patform path|
||DataFilePath||✓|relative or absolute patform path|
||ArrayLicensexxx|✓|✓||
||ArrayExcludedComponentName|✓|✓||
|v20|ArrayExcludedModuleName|✓|✓|removes CEF, MeCab, PHP, SpellChecker, 4D Updater|
||ArrayExcludedPluginID|✓|✓|for 4D authored plugins|
||ArrayExcludedPluginName|✓|✓|for 3rd party plugins|
||IncludeAssociatedFolders|✓|✓||
|v20|ClientUserPreferencesFolderByPath||✓||
|v20|HideDataExplorerMenuItem||✓||
|v20|HideRuntimeExplorerMenuItem||✓||
||IPAddress||✓||
||PortNumber||✓||
||HardLink||✓||
||RangeVersMin||✓||
||RangeVersMax||✓||
||CurrentVers|✓|✓||
|v14|MacSignature|✓|✓||
|v14|MacCertificate|✓|✓||
|v19|AdHocSign|✓|✓||
|v16|LastDataPathLookup|✓|✓||
|v16|ServerSelectionAllowed||✓||
|v18|ClientWinSingleInstance||✓||
|v19|ServerStructureFolderName||✓||
|v19|ClientServerSystemFolderName||✓||
|v20|MacCompiledDatabaseToWinIncludeIt|✓|✓||
|v20|MacCompiledDatabaseToWin|✓|✓||
|v20|ServerEmbedsProjectDirectoryFile||✓||
|v20|ShareLocalResourcesOnWindowsClient||✓||
|v20|ServerDataCollection||✓||
|v19|PackProject||✓|generates alterable project|
|v20|UseStandardZipFormat||✓|generates scrambled and encrypted .4DZ|
|v14|StartElevated||✓|request admin privileges for auto-update|



[^hybrid]: An app merged with *4D Volume Desktop* that intially launches as a desktop app instead of a client app that automatically connecting to a peer server. The startup project can execute with or without a local database. (v18 or later)
