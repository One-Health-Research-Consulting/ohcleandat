# Keep Validated Entries in Log for Further Validation

This function compares an existing log and new log and keeps entries
that have been validated in the existing log and created in the new log.

## Usage

``` r
keep_validated_entries(existing_log, new_log)
```

## Arguments

- existing_log:

  data.frame A log created with the ohcleandat package

- new_log:

  data.frame A different log created with the ohcleandat package. Set to
  NULL to return validated entries from existing log.

## Value

data.frame An ohcleandat log based on the existing log.

## Details

This is used in the free_text other_choices validation sequence to
reduce the number of times a record is validated twice. In this use
case, questions that contain an "other choice" are identified in a look
up table. If they have been validated in the free text log, then they
can be flagged in the `other_choice` log.

## Examples

``` r
if (FALSE) { # \dontrun{
 existing_log <- get_dropbox_val_logs(file_name = "log.csv", folder = NULL)

 odk_schema_data <- schema_from_odk_xlsx_template(file_path = "inst/example_odk_schema.xlsx")

 new_log  <- create_free_text_log(response_data = semi_clean_data,
                      form_schema = odk_schema_data,
                      url = "https://odk.xyz.io/#/projects/project-name/submissions",
                      existing_log = existing_log)

 keep_validated_entries(existing_log,new_log)
} # }
```
