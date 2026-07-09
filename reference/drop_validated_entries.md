# Drop Validated Entries in Log

Removes any entries that have been validated in the existing log. Will
return records that are in both logs and have no_change = NA

## Usage

``` r
drop_validated_entries(existing_log, new_log)
```

## Arguments

- existing_log:

  data.frame A log created with the ohcleandat package

- new_log:

  data.frame A different log created with the ohcleandat package

## Value

data.frame An ohcleandat log based on the existing log.

## Examples

``` r
if (FALSE) { # \dontrun{
 existing_log <- get_dropbox_val_logs(file_name = "log.csv", folder = NULL)

 odk_schema_data <- schema_from_odk_xlsx_template(file_path = "inst/example_odk_schema.xlsx")

 new_log  <- create_free_text_log(response_data = semi_clean_data,
                      form_schema = odk_schema_data,
                      url = "https://odk.xyz.io/#/projects/project-name/submissions",
                      existing_log = existing_log)

 drop_validated_entries(existing_log,new_log)
} # }
```
