# Lipo : _CLI

`Lipo` is a subclass of `_CLI` to execute the `lipo` program. 

## .OnResponse()

**.OnResponse**($files : Collection; $parameters : Collection)

Used internally to process files returned from `_Find`. 

## .thin()

**.thin**($option : Variant)->$this : cs.Lipo

Process a collection of files/folders or a single file/folder.

Chained calls are queued as sequential tasks.

An option should have the following properties:

|Property|Type|Description|
|:-|:-|:-|
|src|4D.File or 4D.Folder|the input file or folder|
|dst|4D.File or 4D.Folder|the output file or folder|
|arch|Text|the architecture type to keep `arm64` (default) or `x86_64`|

`src` and `dst` must be matching objects.