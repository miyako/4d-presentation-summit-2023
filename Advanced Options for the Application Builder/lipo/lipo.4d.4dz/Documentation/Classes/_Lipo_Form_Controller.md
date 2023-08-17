# _Lipo_Form_Controller : _Form_Controller : _CLI_Controller

`_Lipo_Form_Controller` is a subclass of `_Form_Controller` to execute `lipo` in a form. 

The class defines the following properties:

|Property|Type|Description|
|:-|:-|:-|
|src|4D.File|read-only|
|dst|4D.File|read-only|
|arch|Text|read-only|

## .bind() 

**.bind**($options : Object)

Binds the supplied form object names to a specific functionality. 

The following object names are supported:

|Property|Type|Description|
|:-|:-|:-|
|startButton|Text||
|stopButton|Text||

The enabled/disabled status of each button object is toggled automatically.
