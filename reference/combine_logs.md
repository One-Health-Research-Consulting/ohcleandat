# Combine Validation Logs

Checks for the existence of an existing validation log and appends new
records from the current run.

## Usage

``` r
combine_logs(existing_log, new_log, is_id_log = FALSE)
```

## Arguments

- existing_log:

  tibble existing validation log

- new_log:

  tibble newly generated validation log

- is_id_log:

  Logical. Are you combining id logs output from
  [`create_id_log()`](https://One-Health-Research-Consulting.github.io/ohcleandat/reference/create_id_log.md)?

## Value

tibble appended validation log for upload
