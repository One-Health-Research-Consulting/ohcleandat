# Guess the column type

uses column class to set readr column type

## Usage

``` r
guess_col_type(data, default_col_abv = "c")
```

## Arguments

- data:

  data.frame Data who column types you would like to guess

- default_col_abv:

  string. Column type abbreviation from
  [`readr::cols()`](https://readr.tidyverse.org/reference/cols.html).
  Use "g" to guess the column type.

## Value

character vector of column abbreviations

## Examples

``` r
data <- data.frame(time = Sys.time(),
char = "hello", num = 1, log = TRUE,
date = Sys.Date(), list_col = list("hello") )

guess_col_type(data)
#>     time     char      num      log     date X.hello. 
#>      "T"      "c"      "n"      "l"      "D"      "c" 

## change default value of default column abbreviation

guess_col_type(data, default_col_abv = "g")
#>     time     char      num      log     date X.hello. 
#>      "T"      "c"      "n"      "l"      "D"      "c" 

```
