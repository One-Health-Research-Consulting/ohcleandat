# Create a "rules" file from a template

Creates a rules file from a template to show general structure of the
rule file.

## Usage

``` r
create_rules_from_template(
  name,
  dir = "R",
  open = TRUE,
  showWarnings = FALSE,
  overwrite_file = FALSE
)
```

## Arguments

- name:

  String. Name of rule set function e.g. create_rules_my_dataset

- dir:

  String. Name of directory where file should be created. If it doesnt
  exist, a folder will be created.

- open:

  Logical. Should the file be opened?

- showWarnings:

  Logical. Should dir.create show warnings?

- overwrite_file:

  Logical. Should a rules file with the same name be overwritten?

## Value

String. File path of newly created file

## Examples
