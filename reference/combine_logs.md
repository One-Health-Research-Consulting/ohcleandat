# Combine Validation Logs

Checks for the existence of an existing validation log and appends new
records from the current run.

## Usage

``` r
combine_logs(existing_log, new_log)
```

## Arguments

- existing_log:

  tibble existing validation log

- new_log:

  tibble newly generated validation log

## Value

tibble appended validation log for upload
