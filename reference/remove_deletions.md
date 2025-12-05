# Utility function to identify records for deletion

Filters for records matching a given string.

## Usage

``` r
remove_deletions(x, val = stringr::regex("Delete", ignore_case = TRUE))
```

## Arguments

- x:

  input vector

- val:

  Character or regex. The value to check for inequality. Val is fed into
  stringr::str_detect as the pattern parameter. Defaults to 'Delete'
  with ignore case = TRUE. See stringr::str_detect for more details.

## Value

logical vector

## Details

To be used within
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html).
The function returns a logical vector with TRUE resulting from values
that are not equal to the `val` argument. Also protects from NA values.

Used within verbs such as
[`tidyselect::all_of()`](https://tidyselect.r-lib.org/reference/all_of.html)
this can work effectively across all columns in a data frame. See
examples

## Examples

``` r
data <- data.frame("a" = sample(c("Delete", "Keep",NA),size = 10,replace = TRUE))

data |>
  dplyr::filter(dplyr::if_all(everything(), remove_deletions))
#>      a
#> 1 Keep
#> 2 Keep
#> 3 <NA>
#> 4 Keep
#> 5 Keep
#> 6 <NA>
#> 7 Keep
```
