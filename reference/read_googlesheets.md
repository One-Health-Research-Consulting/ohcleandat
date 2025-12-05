# Read Google Sheets Data

For a given sheet id, this handles authentication and reads in a
specified sheet, or all sheets.

## Usage

``` r
read_googlesheets(
  key_path,
  sheet = "all",
  ss,
  add_primary_key_field = FALSE,
  primary_key = "primary_key",
  ...
)
```

## Arguments

- key_path:

  character path to Google authentication key json file

- sheet:

  Sheet to read, in the sense of "worksheet" or "tab".

- ss:

  Something that identifies a Google Sheet such as drive id or URL

- add_primary_key_field:

  Logical. Should a primary key field be added?

- primary_key:

  character. The column name for the unique identifier to be added to
  the data.

- ...:

  other arguments passed to
  [`googlesheets4::range_read()`](https://googlesheets4.tidyverse.org/reference/range_read.html)

## Value

tibble

## See also

[`googlesheets4::range_read()`](https://googlesheets4.tidyverse.org/reference/range_read.html)

## Examples

``` r
if (FALSE) { # \dontrun{
read_googlesheets(ss = kzn_animal_ship_sheets, sheet = "all",)
} # }
```
