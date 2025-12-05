# Dropbox Upload

Upload a local file to dropbox and handle authentication. Automatically
zips files over 300mb by default.

## Usage

``` r
dropbox_upload(dataframe, file_path, dropbox_path, compress = TRUE)
```

## Arguments

- dataframe:

  Data frame. Will work with any tabular data. Designed to be used with
  Validation Log for OH cleaning pipelines.

- file_path:

  character. local file path for upload

- dropbox_path:

  character. relative dropbox path

- compress:

  logical. Should files over 300mb be compressed?

## Value

Character. File path on dropbox.

## Details

This is a wrapper of
[`rdrop2::drop_upload()`](https://rdrr.io/pkg/rdrop2/man/drop_upload.html)
which first reads in a local CSV file and then uploads to a DropBox
path.

## Examples

``` r
if (FALSE) { # \dontrun{
    dropbox_upload(
    kzn_animal_ship_semiclean,
    file_path = here::here("outputs/data.csv"),
    dropbox_path = "XYZ/Data/semi_clean_data"
    )
} # }
```
