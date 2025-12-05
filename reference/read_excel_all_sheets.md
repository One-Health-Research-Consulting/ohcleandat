# Reads all tabs from an excel workbook

For a given excel file, this will detect all sheets, and iteratively
read all sheets and place them in a list.

If primary keys are added, the primary key is the triplet of the file,
sheet name, and row number e.g. "file_xlsx_sheet1_1". Row numbering is
based on the data ingested into R. R automatically skips empty rows at
the beginning of the spreadsheet so id 1 in the primary key will belong
to the first row with data.

## Usage

``` r
read_excel_all_sheets(
  file,
  add_primary_key_field = FALSE,
  primary_key = "primary_key"
)
```

## Arguments

- file:

  character. File path to an excel file

- add_primary_key_field:

  Logical. Should a primary key field be added?

- primary_key:

  character. The column name for the unique identifier to be added to
  the data.

## Value

list

## Note

The primary key method is possible because Excel forces sheet names to
be unique.

## Examples

``` r
 if (FALSE) { # \dontrun{
# Adding primary key field
read_excel_all_sheet(file = "test_pk.xlsx",add_primary_key_field = TRUE)

# Don't add primary key field
read_excel_all_sheet(file = "test_pk.xlsx")

    } # }
```
