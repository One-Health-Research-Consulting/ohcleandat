# Class to Column Type lookup table

A table that links classes to `readr` column types. Created from csv
file of the same name in inst/

## Usage

``` r
class_to_col_type
```

## Format

### `class_to_col_type`

A data frame with 9 rows and 3 columns:

- col_type:

  Type of column as described in `readr`

- col_class:

  Class of R object that matches that column type

- col_abv:

  Abbreviation for that column type from `readr`

## Details

class_to_col_type \<- read.csv(file = "inst/class_to_col_type.csv")
usethis::use_data(class_to_col_type,overwrite = TRUE)

## See also

[`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
