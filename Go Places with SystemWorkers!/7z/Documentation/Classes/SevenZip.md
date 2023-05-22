# SevenZip

`SevenZip` is a subclass of `_CLI` to execute the 7z program. 

## .add()

**.add**($destination : 4D.File; $sources : Collection)->$this : cs.SevenZip

Adds a collection of `4D.File` or `4D.Folder` objects to an archive.

## .extract()

**.extract**($source : 4D.File; $destination : 4D.Folder)->$this : cs.SevenZip

Extracts all files from an archive.
