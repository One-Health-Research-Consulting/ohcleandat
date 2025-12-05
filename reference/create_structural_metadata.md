# Create Structural Metadata from a dataframe

This is the metadata that describes the data themselves. This metadata
can be generated then joined to pre-existing metadata via field names.

## Usage

``` r
create_structural_metadata(
  data,
  primary_key = "",
  foreign_key = "",
  additional_elements = tibble::tibble()
)
```

## Arguments

- data:

  Any named object. Expects a table but will work superficially with
  lists or named vectors.

- primary_key:

  Character. name of field that serves as a primary key

- foreign_key:

  Character. Field or fields that are foreign keys

- additional_elements:

  Empty tibble with structural metadata elements and their types.

## Value

dataframe with standard metadata requirements

## Details

The metadata table produced has the following elements

- `name` = The name of the field. This is taken as is from `data`.

- `description` = Description of that field. May be provided by
  controlled vocabulary

- `units` = Units of measure for that field. May or may not apply

- `term_uri` = Universal Resource Identifier for a term from a
  controlled vocabulary or schema

- `comments` = Free text providing additional details about the field

- `primary_key` = `TRUE` or `FALSE`, Uniquely identifies each record in
  the data

- `foreign_key` = `TRUE` or `FALSE`, Allows for linkages between data
  sets. Uniquely identifies records in a different data set

## Examples
