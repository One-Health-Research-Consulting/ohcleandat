# Update structural metadata

Appends rows and/or columns to existing metadata, change primary key
and/or adds foreign keys.

## Usage

``` r
update_structural_metadata(
  data,
  metadata,
  primary_key = "",
  foreign_key = "",
  additional_elements = tibble::tibble()
)
```

## Arguments

- data:

  Any named object. Expects a table but will work superficially with
  lists or named vectors.

- metadata:

  Data frame. Output from `create_structural_metadata`

- primary_key:

  Character. OPTIONAL Primary key in the data

- foreign_key:

  Character. OPTIONAL Foreign key or keys in the data

- additional_elements:

  data frame. OPTIONAL Empty tibble with structural metadata elements
  and their types.

## Value

data.frame

## Note

See vignette on metadata for examples
