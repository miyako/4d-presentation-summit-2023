# 4d-presentation-summit-2023
Repository for Topic D - SystemWorker, Go, PDF and more

#### PDF resources for SystemWorker

* https://github.com/signintech/gopdf

#### How to create a CLI with Go

* https://go.dev/dl/

* hello-world.go

```go
package main

func main() {
    print("Hello world!")
}
```

* compile Universal Binary 

```
GOOS=darwin GOARCH=amd64 go build -o hello-world_amd64 hello-world.go
GOOS=darwin GOARCH=arm64 go build -o hello-world_arm64 hello-world.go
lipo -create -output hello-world hello-world_amd64 hello-world_arm64
```
