# Title

Title

## Usage

``` r
join_id_log(existing_log, id_log, ..., dataset_name)
```

## Arguments

- existing_log:

  data frame. An existing validation log.

- id_log:

  data frame. An id validation log

- ...:

  Additional id validation logs to be joined

- dataset_name:

  String. the name of the dataset as it appears in the id validation
  log(s). This function uses exact matches "=="

## Value

tibble. Joined log using dplyr::bind_rows
