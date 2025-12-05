# Metadata: Creating Standard Metadata with \`{ohcleandat}\` and \`{deposits}\`

``` r
library(ohcleandat)
library(deposits)
library(frictionless)
```

One if the primary aims of cleaning data is to be able to work with it.
Whether working with data shortly after it was created, or years later,
proper metadata make it easier to know whats in a dataset or data
package.

In extremely broad terms, there are two types of metadata: 1)
descriptive metadata - the who what where why when of the dataset. 2)
structural metadata - what do individual fields mean and how to do fit
together? This vignette focuses on creating descriptive metadata with
the {deposits} and {frictionless} packages and structural metadata using
functions in {ohcleandat}.

## Creating structural metadata with {ohcleandat}

Because {ohcleandat} largely deals with cleaning tabular data, we can
use a standard (and extensible) structural metadata format to describe
outputs.

The basic structural metadata table produced has the following elements

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

Additional metadata elements can be added by creating then column
binding an empty `data.frame` to the basic structure.

### Basic Example:

``` r

## read in your data
data_to_describe <- tibble::tibble(date = as.Date(19961:19970),
                                   measurement = sample(1:100,10),
                                   measured_by = sample(c("Collin","Johana"),size = 10,replace = TRUE),
                                   site_name = sample(letters[1:5],size = 10,replace = TRUE),
                                   field_we_dont_need = "nothing useful here"
)

# create metadata
structural_metadata  <- ohcleandat::create_structural_metadata(data_to_describe)

# write to csv
structural_metadata |>
  write.csv(file = "metadata_examples/structural_metadata.csv",row.names = FALSE)

# Fill in metadata by hand and read

structural_metadata_complete <- readr::read_csv(file = "metadata_examples/structural_metadata_complete.csv")
```

### What if the structure of my data change?

Do I have to re-write my metadata? Maybe! But in certain cirucumstances
you can just update the metadata.

``` r

## oops I forgot to add a primary key
data_to_describe$key <- 1:10


# add primary key and label it as a primary key in the metadata

structural_metadata_pk<- ohcleandat::update_structural_metadata(data = data_to_describe,metadata = structural_metadata_complete, primary_key = "key")

# oh also, the measured_by field is a foreign key

structural_metadata_fk <- ohcleandat::update_structural_metadata(data = data_to_describe,
                                                                 metadata = structural_metadata_pk, 
                                                                 foreign_key = "measured_by")

## yeah we deleted that field - sorry!

data_to_describe_drop_field <- data_to_describe |>
  dplyr::select(-field_we_dont_need)

structural_metadata_clean <- ohcleandat::update_structural_metadata(
  data = data_to_describe_drop_field,
  metadata = structural_metadata_fk)

write.csv(structural_metadata_clean,
          file = "metadata_examples/structural_metadata.csv",
          row.names = FALSE)
```

## Depositing data into an archive with {deposits}

Okay - so I want to deposit my data using the
[{deposits}](https://docs.ropensci.org/deposits/) package. {deposits}
uses the [frictionless data
standard](https://docs.ropensci.org/frictionless/articles/frictionless.html)
so I end up with this thing called `datapackage.json` that stores all of
my metadata.

The `datapackage.json` structural metadata is pretty minimal - it only
includes field name and type (numeric, character, etc). So we want to
add our metadata to that.

See the [{deposits} setup
guide](https://docs.ropensci.org/deposits/articles/install-setup.html)
for getting an api token and installing the package. It might also be
helpful to review the `metadata_template.json` file when creating the
descriptive metadata. Only certain DCMI terms can be included in the
descriptive metadata and their formatting can be a little tricky.

``` r


# set deposits token 
# this can also be done in the `.Renviron` file or
# via a .env file using the {dotenv} package
# dotenv::load_dot_env(file = "../.env")
Sys.setenv ("ZENODO_SANDBOX_TOKEN" = "<my-token>")

# make sure your data are saved to a file

write.csv(data_to_describe_drop_field,file = "data_examples/my_data.csv",row.names = FALSE)

# make sure your updated metadata file is loaded

structural_metadata <- readr::read_csv("metadata_examples/structural_metadata_complete.csv")


# Create descriptive metadata

# check valid dcmi terms by calling deposits::dcmi_terms()
# check see term defintions by calling: deposits::deposits_metadata_template(filename = "metadata_template.json")

descriptive_metadata <- list (
    title = "Example Dataset",
    description = "This is the abstract",
    creator = list (list (name = "A. Person"), list (name = "B. Person"))
    # , accessRights = "open"
)

# create a new client 
cli <- deposits::depositsClient$new(service = "zenodo",
                                    metadata = descriptive_metadata,
                                    sandbox = TRUE)


# create a new deposit item - this  creates a placeholder in zenodo
# for your items
cli$deposit_new()

# add your data - you can add individual files or whole folders
# this will make a datapackage.json item in data_examples
cli$deposit_add_resource(path = "data_examples/my_data.csv")

## open the 

# Take a peak at the `datapackage.json` file - you'll see the first section
# describes the csv file, the second section describes the data in the csv,
# the third section contains the descriptive metadata we created

# Add your structural metadata to the frictionless metadata

expand_frictionless_metadata(structural_metadata = structural_metadata,
                             resource_name = "my_data", # name of the file with no extension
                             resource_path = "data_examples/my_data.csv",
                             data_package_path = "data_examples/datapackage.json")



## OOPs actually I need to add more to the description

descriptive_metadata <- list (
    title = "Example Dataset",
    description = "This is the abstract but it needs more detail",
    creator = list (list (name = "A. Person"), list (name = "B. Person"),list (name = "C. Person"),list (name = "F. Person"))
    # , accessRights = "open"
)


update_frictionless_metadata(descriptive_metadata = descriptive_metadata,
                             data_package_path = "data_examples/datapackage.json"
)

cli$deposit_fill_metadata(descriptive_metadata)
# update deposit hangs if the descriptive metadata is not properly formatted, even after correction
# upload to zenodo - this creates a **draft** deposit in Zenodo 
cli$deposit_upload_file(path = "data_examples/")

## update structural metadata

structural_metadata[1,2] <- "New description"

expand_frictionless_metadata(structural_metadata = structural_metadata,
                             resource_name = "my_data", # name of the file with no extension
                             resource_path = "data_examples/my_data.csv",
                             data_package_path = "data_examples/datapackage.json")

## remove an element from the structural metadata and datapackage

# dropping the comments field 
structural_metadata <- structural_metadata[-5]

expand_frictionless_metadata(structural_metadata = structural_metadata,
                             resource_name = "my_data", # name of the file with no extension
                             resource_path = "data_examples/my_data.csv",
                             data_package_path = "data_examples/datapackage.json",
                             prune_datapackage = TRUE) # this is the default

# there are methods for embargoing or restricting deposits in {deposits}
```
