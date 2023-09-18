# CLI

`CLI` is a class to print [ASCII escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code). 

## .CR() 

**.CR**() : cs.CLI

Print the carriage-return ASCII code.

## .LF() 

**.LF**() : cs.CLI

Print the line-feed ASCII code.

## .escape() 

**.escape**($message : Text; $style : Text) : Text

Apply ASCII escape codes to `$message`.

## .print() 

**.print**($message : Text; $style : Text) : cs.CLI

Print `$message` using ASCII escape codes.

```4d
var $CLI : cs.CLI

$CLI:=cs.CLI.new()

//foreground
$CLI.print("Hello World"; "red;bold;underline").LF()
//foreground and background
$CLI.print("Hello World"; "red;yellow;bold;underline").LF()
```

<img width="634" alt="" src="images/hello.png">

```4d
$CLI.LF()

//16-bit color
For ($i; 0; 255)
	$CLI.print(String($i; "^^0"+"   "); String($i)+";bold")
End for 

$CLI.LF()
```

<img width="634" alt="" src="images/colors.png">