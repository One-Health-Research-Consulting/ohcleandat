# Download Google Drive Files

For a given Google Drive folder this function will find and download all
files matching a given pattern.

## Usage

``` r
download_googledrive_files(
  key_path,
  drive_path,
  search_pattern,
  MIME_type = NULL,
  out_path
)
```

## Arguments

- key_path:

  character path to Google authentication key

- drive_path:

  character The Google drive folder path

- search_pattern:

  character A search pattern for files in the Google drive

- MIME_type:

  character Google Drive file type, file extension, or MIME type.

- out_path:

  character The local file directory for files to be downloaded to

## Value

a character vector of files downloaded

## Details

Note: This relies on the
[`googledrive::drive_ls()`](https://googledrive.tidyverse.org/reference/drive_ls.html)
function which uses a search function and is not deterministic when
recursively searching. Please pay attention to what is returned.

## See also

[`googledrive::drive_ls()`](https://googledrive.tidyverse.org/reference/drive_ls.html)

## Examples

``` r
if (FALSE) { # \dontrun{
  download_googledrive_files(
  key_path = here::here("./key.json"),
  drive_path = "https://drive.google.com/drive/u/0/folders/asdjfnasiffas8ef7y7y89rf",
  search_pattern = ".*\\.xlsx",
  out_path = here::here("data/project_data/")
  )
} # }
```
