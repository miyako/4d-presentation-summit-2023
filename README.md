# 4d-presentation-summit-2023
Repository for Topic D - SystemWorker, Go, PDF and more

#### PDF resources for SystemWorker

* https://github.com/signintech/gopdf

#### How to install Go

if you use the official macos installer from https://go.dev/dl/ on macOS, you would need to uninstall via `rm`

```sh
sudo rm -rf /usr/local/g
sudo rm -rf /etc/paths.d/go
```

it is easier to manage if you install with [brew](https://formulae.brew.sh/formula/go)

the official windows installer is somewhat better in that you can uninstall go from the control panel

still, to manage packages, it may make sense to install with [choco](https://chocolatey.org)

#### How to create a CLI with Go

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
