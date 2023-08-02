# Csv2Json : _CLI

`Csv2Json` is a subclass of `_CLI` to execute the `csv2json` program. 

## .execute()

**.execute**($option : Variant)->$this : cs.Csv2Json

Process a collection of file or a single file.

Chained calls are queued as sequential tasks.

An option should have the following properties:

|Property|Type|Description|
|:-|:-|:-|
|src|4D.File|the CSV file to convert|
|pretty|Boolean|`False` (default) or `True`|
|separator|Text|`comma` (default) or `semicolon`|