# Create ODK Schema from XLSX template

Converts and odk xlsx template to a condensed version of the ODK schema
retrieved by RuODK. It is only necessary to use this function if you
converted your xlsx file to XML before uploading to ODK.

## Usage

``` r
schema_from_odk_xlsx_template(file_path, ...)
```

## Arguments

- file_path:

  String. Path to excel file.

- ...:

  Additional arguments for dpylr::summarize. Generally used to supply
  paired arguments for creating lists of choices in a given language.
  See example.

## Value

Data frame. In same format as

## Examples

``` r
if (FALSE) { # \dontrun{
schema_from_odk_xlsx_template(file_path = "inst/RVF2_participant_survey_20220302.xlsx",
                              `choices_english_(en)` = list(`label_english_(en)`),
                               `choices_zulu_(zu)` = list(`label_zulu_(zu)`)
)
} # }


```
