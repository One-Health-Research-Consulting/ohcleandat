# Validation Correction Checks

Validation correction tests to be run on data before and after
validation to test expectations.

## Usage

``` r
validation_checks(validation_log, before_data, after_data, primary_key)
```

## Arguments

- validation_log:

  tibble Validation log

- before_data:

  tibble Data before corrections

- after_data:

  tibble Data after corrections

- primary_key:

  character the primary key for the 'after_data'

## Value

NULL if passed or stops with error

## Details

As part of the OH cleaning pipelines, raw data is converted to
'semi-clean' data through a process of upserting records from an
external Validation Log. To ensure these corrections were made as
expected, some checks are performed in this function.

1.  If no existing log exists \> no changes are make to data

    - Same variables

    - same Rows

    - No unequal values

2.  If log exists but no changes are recommended \> no changes to data.

    - Same variables

    - same Rows

    - No unequal values

3.  Log exists and changes recommended \> number of changes are same as
    log

    - Same variables

    - same Rows

    - Number of changing records in data match records in log

4.  Correct fields and records are being updated

    - Checks before and after variables and rows are the same

    - Checks the variable names and row indexes are the same in the logs
      and the changed data.

## Examples

``` r
if (FALSE) { # \dontrun{
    validation_checks(
    validation_log = kzn_animal_ship_existing_log,
    before_data = kzn_animal_ship,
    after_data = kzn_animal_ship_semiclean,
    primary_key = "animal_id"
    )
} # }
```
