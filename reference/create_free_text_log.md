# Create Free Text Log

Collates free text responses from text fields in the survey data. Some
language detection is performed and placed in the log notes section for
possible translation.

## Usage

``` r
create_free_text_log(
  response_data,
  form_schema,
  url,
  type_to_keep = "text",
  existing_log,
  columns_to_exclude = NULL
)
```

## Arguments

- response_data:

  data.frame of ODK questionnaire responses

- form_schema:

  data.frame or flattened ODK form schema

- url:

  The ODK submission URL excluding the uuid identifier

- type_to_keep:

  String. Regex pattern passed to
  [`stringr::str_detect`](https://stringr.tidyverse.org/reference/str_detect.html).

- existing_log:

  data.frame Existing log used to create semi-clean data. Used to
  prevent double entry of items.

- columns_to_exclude:

  Character. Character vector of columns to exclude from the log.

## Value

data.frame validation log

## Details

Since this a "type" based validation, we must provide the existing log
to prevent the perptual addition of entries. Unlike other logs, this log
looks for specific types of data in the schema. If they are found, a new
record is created. Even if a record is marked validated, its type will
not change and so we must ensure the record is only added to the log if
it is unvalidated in the current log. Any records that are added to the
log but are unvalidated (in their original state) and duplicates, will
be removed when logs are combined in `combine_logs`.

## Examples

``` r
if (FALSE) { # \dontrun{

odk_schema_data <- schema_from_odk_xlsx_template(file_path = "inst/example_odk_schema.xlsx")

create_free_text_log(response_data = semi_clean_data,
                      form_schema = odk_schema_data,
                      url = "https://odk.xyz.io/#/projects/project-name/submissions",
                      existing_log = existing_log)

# exclude certain columns from the free text log
create_free_text_log(response_data = semi_clean_data,
                      form_schema = odk_schema_data,
                      url = "https://odk.xyz.io/#/projects/project-name/submissions",
                      existing_log = existing_log,
                      columns_to_exclude = c("household_id", "human_id")
                      )
} # }
```
