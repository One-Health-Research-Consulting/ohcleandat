# Autobot Function

This compares two columns. Where there are differences, it extracts the
values and compiles a correctly formatted validation log. This is
intended to be used when an automated formatting correction is proposed
in the data, but the actual updating of the records is required to
happen via the validation log.

## Usage

``` r
autobot(data, old_col, new_col, primary_key)
```

## Arguments

- data:

  data.frame or tibble

- old_col:

  The existing column with formatting issues

- new_col:

  The new column with corrections applied

- primary_key:

  column that uniquely identifies the records in data

## Value

tibble formatted as validation log
