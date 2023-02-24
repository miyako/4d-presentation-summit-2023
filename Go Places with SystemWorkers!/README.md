# Go Places with SystemWorkers!

## Teaser Message

Keisuke would be the last person to accept that the days of 4D plugins are numbered...but it's the year 2023 and SystemWorkers are here! In this landmark session, learn how the new feature changes everything, with a bonus primer on the ubiquitous Go programming language.

## Synopsis 

Present the benefits of SystemWorkers, compared to [`LAUNCH EXTERNAL PROCESS`](https://doc.4d.com/4Dv19/4D/19.5/LAUNCH-EXTERNAL-PROCESS.301-6137469.en.html) [`PHP Execute`](https://doc.4d.com/4Dv19/4D/19.5/PHP-Execute.301-6137576.en.html) or even plugins.

Explain how Go is the ideal programming language for a cross-platform, deployment-ready utility executable to be embedded in 4D.

Show some practical examples that adds value to the product or enhances the user experience.

## An Example

4D is not partculary versitle when it comes to processing proprietary data formats. For example, it doesn't have a robust CSV converter. On the other hand, there are standard libraries for CSV[^golangcsv], XML[^golangxml] and JSON[^golangjson] in Go. You can probably find ready-to-go solutions in no time.

* https://gosamples.dev/csv-to-json/

## GitHub Copilot and ChatGPT

The Go programming language has the tendancy to result in pretty formulaic code. Add to that the large population of programmers who actively work with the language, it makes an ideal candidate for AI assisted coding. 

For example, if you ask ChatGPT

> write me code in go that converts csv to json

you may get something like

> Here's an example Go code that reads a CSV file and converts it to JSON format:

```go
package main

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
)

func main() {
	// Open the CSV file
	file, err := os.Open("input.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	// Parse the CSV file
	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		panic(err)
	}

	// Convert CSV records to a slice of maps
	var data []map[string]string
	headers := records[0]
	for _, row := range records[1:] {
		record := make(map[string]string)
		for i, value := range row {
			record[headers[i]] = value
		}
		data = append(data, record)
	}

	// Convert data to JSON
	jsonData, err := json.MarshalIndent(data, "", "    ")
	if err != nil {
		panic(err)
	}

	// Write JSON data to file
	err = ioutil.WriteFile("output.json", jsonData, 0644)
	if err != nil {
		panic(err)
	}

	fmt.Println("CSV converted to JSON successfully.")
}
```

> In this code, we first open the CSV file using the `os.Open` function and parse it using the `csv.NewReader` function. We then loop over the CSV records and convert them to a slice of maps. Finally, we use the `json.MarshalIndent` function to convert the data to JSON format and write it to a file using the `ioutil.WriteFile` function.

Then you may be interested to know how this would work with streams.

> write me code in go that converts from csv stdin to json stdout

you may get something like

> Here's an example Go code that reads a CSV input from standard input and writes the JSON output to standard output:

```go
package main

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io"
	"os"
)

func main() {
	// Parse the CSV input from standard input
	reader := csv.NewReader(os.Stdin)
	var data []map[string]string
	headers, err := reader.Read()
	if err != nil {
		panic(err)
	}
	for {
		row, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			panic(err)
		}
		record := make(map[string]string)
		for i, value := range row {
			record[headers[i]] = value
		}
		data = append(data, record)
	}

	// Convert data to JSON
	jsonData, err := json.MarshalIndent(data, "", "    ")
	if err != nil {
		panic(err)
	}

	// Write the JSON output to standard output
	fmt.Println(string(jsonData))
}
```

> In this code, we use `os.Stdin` to read CSV input from standard input. We parse the input using the `csv.NewReader` function and loop over the CSV records to convert them to a slice of maps. Finally, we use the `json.MarshalIndent` function to convert the data to JSON format and write it to standard output using the `fmt.Println` function.

Does the code work? I don't know. Given the commonality of the problem, you could have searched the web the traditional way. Still, as long as the request is well defined, the answer should not be too far off the mark. Also, you can keep refining your requests to get a better answer. The AI takes context into account.

AI can also be used to perform mundane work such as 

* Generate variable or function names matching task description
* Generate sample dataset
* Ask what a code fragment is doing; insert comments
* Ask why a specific error message would be thrown
* Ask about common pitfalls related to a programming challenge
* Ask for refactoring with an explanation of why one is better than the other 

The results get better the more you give specific instructions, such as naming conventions and arbitrary rules. You are not talking to an actual person, you should be as persistent and blunt as you need to be until you get a satisfactory answer.

#### More Examples

There are no built-in triggers in 4D to execute scheduled tasks other than [`BACKUP`](https://doc.4d.com/4Dv19/4D/19.5/BACKUP.301-6137640.en.html). A cron[^gocron] job might be something interesting to implement with Go.

Another common task that often called for 3rd party tools such as a plugin is to read and write `.xlsx` spreadsheets. Depending on the need, you may consider a simple[^xlsx] or more comprehensive[^excelize] library.

Likewise, tools to extract[^docconv] plain text from `.doc` `.docx` or `.pdf` could be useful to build indexes.   

[^golangcsv]: [standard library > encoding >csv](https://pkg.go.dev/encoding/csv)
[^golangxml]: [standard library > encoding > xml](https://pkg.go.dev/encoding/xml)
[^golangjson]: [standard library > encoding > json](https://pkg.go.dev/encoding/json)
[^gocron]: [go-co-op > gocron](github.com/go-co-op/gocron)
[^xlsx]: [tealeg > xlsx](https://pkg.go.dev/github.com/tealeg/xlsx)
[^excelize]: [360EntSecGroup-Skylar > excelize](https://pkg.go.dev/github.com/360EntSecGroup-Skylar/excelize)
[^docconv]: [code.sajari.com > docconv](https://pkg.go.dev/code.sajari.com/docconv)
