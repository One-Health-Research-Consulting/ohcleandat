# Get Dropbox Validation Logs

Downloads existing validation logs that are stored on dropbox

## Usage

``` r
get_dropbox_val_logs(file_name, folder, path_name)
```

## Arguments

- file_name:

  character file name with extension of the validation log. Note that
  file may have been zipped on upload if its over 300mb. This file will
  be automatically unzipped on download so provide the file extenstion
  for the compressed file, not the zipped file. E.g. "val_log.csv" even
  if on dropbox its stored as "val_log.zip".

- folder:

  character the folder the log is saved in on drop box. Can be NULL if
  not in subfolder.

- path_name:

  character the default drop box path

## Value

tibble a Validation Log

## Details

This function will check if the log exists and return NULL if not. Else
it will locally download the file to 'dropbox_validations' directory and
read in to the session.

## Examples

``` r
if (FALSE) { # \dontrun{
 get_dropbox_val_logs(file_name = "log.csv", folder = NULL)
} # }
```
