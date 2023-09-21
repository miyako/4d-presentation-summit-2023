# Iconutil : _CLI

`Iconutil` is a subclass of `_CLI` to execute the `iconutil` program on macOS. 

## .convert()

**.convert**($option : Variant)->$this : cs.Iconutil

Process a collection of files or a single file.

Chained calls are queued as sequential tasks.

An option should have the following properties:

|Property|Type|Description|
|:-|:-|:-|
|src|Collection|input files. extension must be `.png`|
|dst|4D.File|the output file. extension must be `.icns`|
