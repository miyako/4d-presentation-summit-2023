# Go Places with SystemWorkers!

## Teaser Message

Keisuke would be the last person to accept that the days of 4D plugins are numbered...but it's the year 2023 and SystemWorkers are here! In this landmark session, learn how the new feature changes everything, with a bonus primer on the ubiquitous Go programming language.

## Synopsis 

Present the benefits of SystemWorkers, compared to [`LAUNCH EXTERNAL PROCESS`](https://doc.4d.com/4Dv19/4D/19.5/LAUNCH-EXTERNAL-PROCESS.301-6137469.en.html) [`PHP Execute`](https://doc.4d.com/4Dv19/4D/19.5/PHP-Execute.301-6137576.en.html) or even plugins.

Explain how Go is the ideal programming language for a cross-platform, deployment-ready utility executable to be embedded in 4D.

Show some practical examples that adds value to the product or enhances the user experience.

## Examples

4D is not partculary versitle when it comes to processing proprietary data formats. For example, it doesn't have a robust CSV converter. 

* https://gosamples.dev/csv-to-json/

## Sidebar: GitHub Copilot and ChatGPT

The Go programming language has the tendancy to produce formulaic code. Add to that the large population of programmers who actively work with the language, it makes an ideal candidate for AI assisted coding. 

For example, if you ask ChatGPT

> write me code in go that converts from csv stdin to json stdout

you may get something like

> Sure, here's an example code in Go that reads CSV input from `stdin` and writes JSON output to `stdout`:

```go
package main

import (
    "bufio"
    "encoding/csv"
    "encoding/json"
    "fmt"
    "os"
)

func main() {
    // Create a scanner to read input from stdin
    scanner := bufio.NewScanner(os.Stdin)

    // Read input line by line
    var lines [][]string
    for scanner.Scan() {
        line := scanner.Text()

        // Parse the input as CSV and add it to the lines slice
        row, err := csv.NewReader(strings.NewReader(line)).Read()
        if err != nil {
            fmt.Fprintln(os.Stderr, "Error:", err)
            os.Exit(1)
        }
        lines = append(lines, row)
    }

    // Check for errors while reading input
    if err := scanner.Err(); err != nil {
        fmt.Fprintln(os.Stderr, "Error:", err)
        os.Exit(1)
    }

    // Convert the CSV data to a JSON array
    var jsonData []map[string]string
    for i, line := range lines {
        if i == 0 {
            continue // skip header row
        }
        data := make(map[string]string)
        for j, value := range line {
            data[lines[0][j]] = value
        }
        jsonData = append(jsonData, data)
    }

    // Encode the JSON data and write it to stdout
    jsonDataBytes, err := json.Marshal(jsonData)
    if err != nil {
        fmt.Fprintln(os.Stderr, "Error:", err)
        os.Exit(1)
    }
    fmt.Println(string(jsonDataBytes))
}
```

> Sure, here's an example code in Go that reads CSV input from stdin and writes JSON output to stdout:

go
Copy code
package main

import (
    "bufio"
    "encoding/csv"
    "encoding/json"
    "fmt"
    "os"
)

func main() {
    // Create a scanner to read input from stdin
    scanner := bufio.NewScanner(os.Stdin)

    // Read input line by line
    var lines [][]string
    for scanner.Scan() {
        line := scanner.Text()

        // Parse the input as CSV and add it to the lines slice
        row, err := csv.NewReader(strings.NewReader(line)).Read()
        if err != nil {
            fmt.Fprintln(os.Stderr, "Error:", err)
            os.Exit(1)
        }
        lines = append(lines, row)
    }

    // Check for errors while reading input
    if err := scanner.Err(); err != nil {
        fmt.Fprintln(os.Stderr, "Error:", err)
        os.Exit(1)
    }

    // Convert the CSV data to a JSON array
    var jsonData []map[string]string
    for i, line := range lines {
        if i == 0 {
            continue // skip header row
        }
        data := make(map[string]string)
        for j, value := range line {
            data[lines[0][j]] = value
        }
        jsonData = append(jsonData, data)
    }

    // Encode the JSON data and write it to stdout
    jsonDataBytes, err := json.Marshal(jsonData)
    if err != nil {
        fmt.Fprintln(os.Stderr, "Error:", err)
        os.Exit(1)
    }
    fmt.Println(string(jsonDataBytes))
}
> This code works similarly to the previous example code that reads input from stdin. However, it also parses each input line as CSV using csv.NewReader(), and adds the resulting rows to a lines slice. After reading all the input, it converts the CSV data to a JSON array using the same logic as before.

Finally, it encodes the JSON data and writes it to stdout using fmt.Println(). Note that stdout is the default output stream, so we don't need to specify it explicitly.

Note that this code assumes that each input line contains a single CSV row. If your input contains multiple CSV rows per line, you'll need to modify the parsing logic accordingly.
