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

<img src="https://user-images.githubusercontent.com/1725068/221110469-affa9680-08a5-4880-bcab-c9a798bfd65b.png" width="32px" /> `write me code in go that converts csv to json`

you might get something like

`Sure, here's an example code in Go that reads a CSV file and converts its contents into a JSON array:`

```go
package main

import (
    "encoding/csv"
    "encoding/json"
    "fmt"
    "os"
)

func main() {
    // Open the CSV file
    file, err := os.Open("data.csv")
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    defer file.Close()

    // Read the CSV data
    reader := csv.NewReader(file)
    lines, err := reader.ReadAll()
    if err != nil {
        fmt.Println("Error:", err)
        return
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

    // Encode the JSON data and print it
    jsonDataBytes, err := json.Marshal(jsonData)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Println(string(jsonDataBytes))
}
```
