# _Find_Worker_Controller : _Worker_Controller : _CLI_Controller

`_Find_Worker_Controller` is a subclass of `_Worker_Controller` to execute the `find` command on macOS in a worker. 

## .bind() 

**.bind**($instance : cs._CLI)

Binds the `cs._CLI` instance to a callback functionality. 

The instance will receive callback methods for the following events:

* **.onResponse**($files : Collection; $parameters : Collection)
* **.onTerminate**($parameters : Collection)

`$parameters` is `Copy parameters(2)` from `.bind()`.