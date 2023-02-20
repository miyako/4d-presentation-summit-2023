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

* build Universal Binary 

```
GOOS=darwin GOARCH=amd64 go build -o hello-world_amd64 hello-world.go
GOOS=darwin GOARCH=arm64 go build -o hello-world_arm64 hello-world.go
lipo -create -output hello-world hello-world_amd64 hello-world_arm64
```

* build Windows

```
build hello-world.go
```

---

# New Archive Algorithms

## Synopsis

The `4D.ZipArchive` class supports `3` compression algorithms: `DEFLATE` `LZMA` `XZ`.

The alternative algorithms create smaller files but takes more time to compress or decompress.

### Important

Regardless of the algorithm selected, the file created is always a `.zip` file, with the magic number `50 4B 03 04`. It is **NOT** an `.lzma` or `.7z` or `.gz` or `.xz` file. 4D can **NOT** create or process these files types. 

### Which Algorithms Should I Use?

* Where speed is essential, or you need to create Office documents, use `DEFLATE`. 

* Where size is more important than speed, consider `LZMA` or `XZ`.

### Which is better, `LZMA` or `XZ`?

`XZ` is an implementation of the `LZMA2` compression algorithm, created for the `.xz` file format.
Since 4D uses the algorithm to create a `.zip` file, the difference in performance should be negligible, although depending on the file content or compression level, one could be slightly faster than the other. Likewise, both algorithms would generate archives that are similar in size. Note that `XZ` is designed to potentially take advantage of multiple cores, this feature is disabled in 4D. Therefore, its advantages over `LZMA` are quite limited. 

### Encryption

Most archive utilities, including those embedded in the operating system, can decompress `.zip` files created using alternative algorithms. However, only the `DEFLATE` algorithm might be supported for password protection.

### Can I protect Office documents with the API?

No. Office documents (`.docx` `.xlsx` `.pptx`) are password protected using a [scheme different to the standard zip encryption](https://learn.microsoft.com/en-us/openspecs/office_file_formats/ms-offcrypto/3c34d72a-1a61-4b52-a893-196f9157f083). You can **NOT** use zip encryption to password protect Office documents.

## Conclusion 

* If you are using `4D.ZipArchive` to create Office documents, continue with `DEFLATE`.
* If you need to share the archive with password protection, continue with `DEFLATE`.
* If you are using `4D.ZipArchive` to create large archives for storage, switch to the new algorithms.
* If the encrypted file only needs to be decompressed with 4D, you may switch to the new algorithms.
* If you need to process  `.7z` or `.xz` file formats, you need to look for alternative solutions.

## References

* Blog: https://blog.4d.com/lzma-the-new-compression-algorithm/
* Doc Center: N/A
* Documentation: https://developer.4d.com/docs/API/ZipArchiveClass/
* Availability: v20 (v19 R3)
