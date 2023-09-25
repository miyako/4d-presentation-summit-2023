//%attributes = {"invisible":true}
/*

Sign the specified application. The log is generated in /LOGS/SignApp-{timestamp}.log.

*/

var $SignApp : cs:C1710.SignApp

$application:=Folder:C1567("Macintosh HD:Users:miyako:Desktop:Final Application:TEST.app"; fk platform path:K87:2)
$SignApp:=cs:C1710.SignApp.new(cs:C1710.SignApp_Worker_Controller)

$SignApp.sign($application)

$logFile:=$SignApp.logFile