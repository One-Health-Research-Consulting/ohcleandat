# Download Drop Box Files

Downloads files from dropbox into a given directory

## Usage

``` r
download_dropbox(dropbox_path, dropbox_filename, download_path, ...)
```

## Arguments

- dropbox_path:

  character The formal folder path on dropbox

- dropbox_filename:

  character The formal file name on dropbox

- download_path:

  character Local file path to download file to

- ...:

  other arguments passed to rdrop2::drop_download

## Value

returns file path if successful

## See also

[`rdrop2::drop_download()`](https://rdrr.io/pkg/rdrop2/man/drop_download.html)

## Examples

``` r
if (FALSE) { # \dontrun{
   download_dropbox(dropbox_path = "XYZ/Project-Datasets",
   dropbox_filename = "Project dataset as at 01-02-2024.xlsx",
   download_path = here::here("data"),
   overwrite = TRUE)
} # }
```
