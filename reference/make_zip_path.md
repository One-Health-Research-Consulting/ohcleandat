# Get make a zip file path

Take a file path, remove the extension, replace the extension with .zip

## Usage

``` r
make_zip_path(file_path)
```

## Arguments

- file_path:

  character.

## Value

character. String where extension is replaced by zip

## Examples

``` r
file_path <- "hello.csv"
make_zip_path(file_path)
#> [1] "hello.zip"

file_path_with_dir <- "foo/bar/hello.csv"
make_zip_path(file_path_with_dir)
#> [1] "foo/bar/hello.zip"
```
