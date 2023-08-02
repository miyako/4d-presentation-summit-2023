# _TEST_Form_Controller : _Form_Controller : _CLI_Controller

`_TEST_Form_Controller` is a subclass of `_Form_Controller` to execute `7z` in a form. 

The class defines the following properties:

|Property|Type|Description|
|:-|:-|:-|
|src|4D.File|read-only|
|dst|4D.File|read-only|

## .bind() 

**.bind**($options : Object)

Binds the supplied form object names to a specific functionality. 

The following object names are supported:

|Property|Type|Description|
|:-|:-|:-|
|startButton|Text||
|_stopButtonName|Text||
|csvInput|Text||
|jsonInput|Text||

The enabled/disabled status of each button object is toggled automatically.

Pass the name of the input objects that should be bound the CSV input and JSON output.

## .setInput() 

**.setInput**()->$src : 4D.File

Call this method before `.execute()` to set the CSV input value.
