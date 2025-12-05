# Expand Frictionless Metadata with structural metadata

Loops over elements in the structural metadata and adds them to the
frictionless metadata schema. Will overwrite existing values and remove
any fields from the datapackage metadata not listed in the structural
metadata.

## Usage

``` r
expand_frictionless_metadata(
  structural_metadata,
  resource_name,
  resource_path,
  data_package_path,
  prune_datapackage = TRUE
)
```

## Arguments

- structural_metadata:

  Dataframe. Structural metadata from `create_structural_metadata` or
  `update_structural_metadata`

- resource_name:

  Character. Item within the datapackage to be updated

- resource_path:

  Character. Path to csv file

- data_package_path:

  Character. Path to datapackage.json file

- prune_datapackage:

  Logical. Should properties not in the structural metadata be removed?

## Value

Updates the datapackage, returns nothing

## Examples

``` r
if (FALSE) { # \dontrun{

# read in file
data_path <- "my/data.csv"
data <- read.csv(data_path)

# create structural metadata
data_codebook  <- create_structural_metadata(data)

# update structural metadata
write.csv(data_codebook,"my/codebook.csv", row.names = FALSE)

data_codebook_updated <- read.csv("my/codebook.csv")

# create frictionless package - this is done automatically with the
# deposits package
my_package <-
 create_package() |>
 add_resource(resource_name = "data", data = data_path)

 write_package(my_package,"my")

expand_frictionless_metadata(structural_metadata = data_codebook_updated,
                            resource_name = "data",
                            resource_path = data_path,
                            data_package_path = "my/datapackage.json"
                            )

} # }
```
