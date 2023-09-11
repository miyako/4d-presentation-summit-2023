# Png2Ico : _CLI

`Png2Ico` is a subclass of `_CLI` to execute the `go-png2ico` program. 

## .convert()

**.convert**($option : Variant)->$this : cs.Png2Ico

Process a collection of files or a single file.

Chained calls are queued as sequential tasks.

An option should have the following properties:

|Property|Type|Description|
|:-|:-|:-|
|src|Collection|input files. extension must be `.png`|
|dst|4D.File|the output file. extension must be `.ico`|
