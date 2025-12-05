# Correct data using validation log

Takes a validation log and applies the required changes to the data

## Usage

``` r
correct_data(validation_log, data, primary_key)
```

## Arguments

- validation_log:

  tibble a validation log

- data:

  tibble the original unclean data

- primary_key:

  character the quoted column name for the unique identifier in data

## Value

tibble the semi-clean data set
