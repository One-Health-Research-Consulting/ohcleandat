# Update descriptive metadata in frictionless datapackage

This function overwrites the descriptive metadata associated with a
frictionless datapackage. It does *NOT* validate the metadata, or check
for conflicts with existing descriptive metadata. It is very easy to
create invalid metadata.

## Usage

``` r
update_frictionless_metadata(descriptive_metadata, data_package_path)
```

## Arguments

- descriptive_metadata:

  List of descriptive metadata terms.

- data_package_path:

  Character. Path to datapackage.json file

## Value

invisibly writes datapackage.json

## Examples

``` r
if (FALSE) { # \dontrun{
descriptive_metadata <- list (
title = "Example Dataset",
description = "This is the abstract but it needs more detail",
creator = list (list (name = "A. Person"), list (name = "B. Person"),
list (name = "C. Person"),list (name = "F. Person"))
# , accessRights = "open"
)
update_frictionless_metadata(descriptive_metadata = descriptive_metadata,
                             data_package_path = "data_examples/datapackage.json"
)
} # }
```
