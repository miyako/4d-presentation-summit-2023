<!-- Class to sign, archive, notarise and staple an app -->
# SignApp

A class to sign, archive, notarize and staple a built 4D app for distribution. Read "[Customizing the Notarization Workflow](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution/customizing_the_notarization_workflow)" on Apple Developer to learn about the notarization process.

## Who needs this?

Apple strongly recommends all apps distributed over the network to be signed  with a developer certifcate and notarized by Apple. This includes apps and components that you develop with 4D. 

The 4D command [`BUILD APPLICATION`](https://doc.4d.com/4Dv19/4D/19.6/BUILD-APPLICATION.301-6270031.en.html) supports signing your app using a certificate issued by Apple, or an *AdHoc* certifcate if you don't specify any certificates. The *AdHoc* option is useful if you only need to run the app locally. 4D does this by invoking the command-line interface of Xcode.

For the most basic and common cases, the built-in tools of 4D design is quite capable.

However, you may run into limits as your build practice gets more sophisticated.

* You want to automate the "archive and notarize" phase (4D only handles the "build & sign" phase).
* You want to customize the *Info.plist* file.
* You want to assign a specific bundle identifier to your app.
* You want to automate the process of building mutiple editions of your app, such as Desktop, Client and Server.
* You want to take advantage of advanced build options that are not exposed in the standard "Build Application" wizard.

## Prerequisites

* [macOS 10.14.5](https://developer.apple.com/jp/news/?id=04102019a) or later
* [Apple ID 2-factor authentication](https://support.apple.com/ja-jp/HT204915)
* [App specific password](https://support.apple.com/ja-jp/HT204397) strongly recommeded
* [Apple Developer Program](https://developer.apple.com/jp/programs/) membership
* Xcode 10 or later (for `xcrun`)
* Apple Developer ID Application identity
* Apple Developer ID Installer identity (only required for `.pkg` archive)
* 4D v19 or later
* [Standard XPath implementation](https://doc.4d.com/4Dv19/4D/19/DOM-Find-XML-element.301-5391781.en.html) (for DOM commands)
* User setting for data (for storing preferences outside the app)
* Default data (for storing data outside the app)

## Usage

In order to proceed, you need to specify your Apple Developer credentials. You can pass your Apple ID and and your app-specific password literally:

```4d
$credentials:=New object
$credentials.username:="keisuke.miyako@4d.com" 
$credentials.password:="mysecretpassword" 
$signApp:=cs.SignApp.new($credentials)
```

However, Apple recommends that you store your credentials in the s standard instructions from Apple and add your Apple Developer credentials to the login keychain. This way you can avoid exposing your password in the source code. For example, if your credentials are stored under that label `fourd` you can instead do:

```4d
$credentials:=New object
$credentials.username:="keisuke.miyako@4d.com"  
$credentials.password:="@keychain:fourd"  
$signApp:=cs.SignApp.new($credentials)
```

You can also specify the label you used to store your profile (`--apple-id` `--team-id`  '--password--' combo) in your login keychain: 

```4d
$credentials.keychainProfile:="notarytool-fourd"
```

Or pass them directly:

```4d
$credentials:=New object
$credentials.username:="keisuke.miyako@4d.com"  
$credentials.teamId:="myteam"  
$credentials.password:="mypassword" 
$signApp:=cs.SignApp.new($credentials)
```

By default, the class searches the keychain for the necessary certificates (you can create and add them to the keychain in Xcode) and signs your app with a faily comprehensive set of options.

```4d
$app:=Folder(fk desktop folder).folder("myApp.app"; fk platform path)
$statuses:=$signApp.sign($app)
```

Alternatively you may specify your certificate by its full name:

```4d
This.signingIdentity:="Developer ID Application: Keisuke Miyako (XXXXXXXXXX)"

```

**Note**: Unless the cerficates belong to the same developer team, signing the same application with a different certificate generally clears its profile. For instance, users will be asked to grant the new application access to specific features that were previously given to the old application.

If the app is successfully signed, you may create an archive in preparation for submitting it to Apple. The class supports all 3 valid formats:

```4d
//$signApp.archiveFormat:=".zip"
//$signApp.archiveFormat:=".pkg"
$signApp.archiveFormat:=".dmg"
$status:=$signApp.archive($app)
```

**Note**: The user is asked to authorize app installation when you choose the `.pkg` option, which makes it incompatible with the client auto-update feature.

If the app is successfully archived, you may submit it to Apple for notarization:

```4d
$status:=$signApp.notarize($status.file)
```

That's it!

## Customizing the property list

The *Info.plist* file contains information about your app. This file must be edited according to a specific format before the app is signed. 

To add or overwrite certain properties, pass an key-value pair object. For example, to instruct the system that the app should prefer the `x86_64` Intel architecture over Apple Silicon:

```4d
$plist:=New object("LSArchitecturePriority"; New collection("x86_64"; "arm64"))
$signApp:=cs.SignApp.new($credentials; $plist)
```

Likewise, to set a custom version code and bundle identifier:

```4d
$plist:=New object("CFBundleShortVersionString"; This.versionString; "CFBundleIdentifier"; $identifier)
```

**Note**: The version code can also be set using the build XML versioning key. However the bundle identifer is automatically set by the `BUILD APPLICATION`. In the specific case of signing an auto-update client you must be pay attention to when you modify the *Info.plist* file:

1. Clone 4D Volume Desktop.app.
1. Customize *Info.plist* (if necessary) but **don't change the version string**. If you change the version string before you call the build command, `BUILD APPLICATION` will fail.
1. **Sign the rumtime with additional entilements** (if necessary). You need to sign the runtime before you call `BUILD APPLICATION` because the command will immediately archive it to be embedded in the server. Due to the way `BUILD APPLICATION` signs the created app, any components of the runtime that are already signed will not be signed with lesser entitlements.
1. Build and sign the server with embedded auto-update client.

## Customizing the bundle identifier

Apps are identified in the Mac ecosystem by their unique bundle identifier. By default, `BUILD APPLICATION` automatically assigns an identifer in the style of `4d.com.{your app name}.app`. You can change this by modifying the *Info.plist* before you sign the app. 

Although not required for 4D, apps that perform inter-process communication (4D and the CEF web area does this) are advised to share a common prefix in their bundle identifer. This has the effect of indicating to the system that they are part of an app group and not spying on each other. Read more on my forum post: [sandboxing a desktop application](https://discuss.4d.com/t/understanding-cef-crash-and-sandboxing/24884 ).   

## Entitlements

Your app must be given explicit entitlements during the signing process in order to access certain system features. 

By default, the `BUILD APPLICATION` give your app the following entitlements: 

* com.apple.security.automation.apple-events
* com.apple.security.cs.allow-dyld-environment-variables
* com.apple.security.cs.allow-jit
* com.apple.security.cs.allow-unsigned-executable-memory
* com.apple.security.cs.debugger
* com.apple.security.cs.disable-executable-page-protection
* com.apple.security.cs.disable-library-validation
* com.apple.security.device.audio-input
* com.apple.security.device.camera
* com.apple.security.personal-information.addressbook
* com.apple.security.personal-information.calendars
* com.apple.security.personal-information.location
* com.apple.security.personal-information.photos-library

The class allows the following additional entitlements:

* com.apple.security.smartcard
* com.apple.security.get-task-allow
* com.apple.security.personal-information.photos-library
* com.apple.security.personal-information.location
* com.apple.security.personal-information.addressbook
* com.apple.security.personal-information.calendars

These are normally not neeed to use 4D, but required to execute certain plugins.

You can deactivate or add entitlements by modifying the `entitlements` property.

---

## Utilities

```4d
$Xcode:=$signApp.getXcodePath()
```

`$Xcode.path` is the current Xcode (`xcode-select -p`).  `$Xcode.paths` is a collection of Xcode applications found by Spotlight (`mdfind kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'`). 

```4d
$signApp.setXcodePath($Xcode)
```

Used to set the `DEVELOPER_DIR` environment variable before `xcrun`.

```4d
$providers:=$signApp.listProviders()
```

List identifiers associated with Apple ID. `$signApp` must be instantiated with clear password i.e. not `@keychain:{label}`.

```4d
$status:=$signApp.notarizationInfo($RequestUUID)
```

Obtain information about a particular submission.
