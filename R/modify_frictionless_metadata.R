#' Expand Frictionless Metadata with structural metadata
#'
#' Loops over elements in the structural metadata and adds them to frictionless
#' metadata schema. Will overwrite existing values.
#'
#' @param structural_metadata Dataframe. Structural metadata from
#' `create_structural_metadata` or `update_structural_metadata`
#' @param resource_name Character. Item within the datapackage to be updated
#' @param resource_path Character. Path to csv file
#' @param data_package_path Character. Path to datapackage.json file
#' @param prune_datapackage Logical. Should properties not in the structural metadata
#' be removed?
#'
#' @return Updates the datapackage, returns nothing
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # read in file
#' data_path <- "my/data.csv"
#' data <- read.csv(data_path)
#'
#' # create structural metadata
#' data_codebook  <- create_structural_metadata(data)
#'
#' # update structural metadata
#' write.csv(data_codebook,"my/codebook.csv", row.names = FALSE)
#'
#' data_codebook_updated <- read.csv("my/codebook.csv")
#'
#' # create frictionless package - this is done automatically with the
#' # deposits package
#' my_package <-
#'  create_package() |>
#'  add_resource(resource_name = "data", data = data_path)
#'
#'  write_package(my_package,"my")
#'
#' expand_frictionless_metadata(structural_metadata = data_codebook_updated,
#'                             resource_name = "data",
#'                             resource_path = data_path,
#'                             data_package_path = "my/datapackage.json"
#'                             )
#'
#' }
#'
expand_frictionless_metadata <- function(structural_metadata,
                                         resource_name,
                                         resource_path,
                                         data_package_path,
                                         prune_datapackage = TRUE){

  data_package <- frictionless::read_package(data_package_path)

  data_package_dir <- dirname(data_package_path)

  # get the schema for a resource in the data package
  my_data_schema <- data_package|>
    frictionless::get_schema(resource_name)

  ## check that the number of fields matches

  # length(my_data_schema$fields) == nrow(structural_metadata)

  ## build up schema based on structural metadata

  for(idx in 1:length(my_data_schema$fields)){
    # item to build out
    x <- my_data_schema$fields[[idx]]
    for(idy in 1:length(structural_metadata)){

      y <- structural_metadata[idx,idy][[1]]
      # get property name
      property_to_add_name <- names(structural_metadata)[idy]
      property_to_add_value <- y
      names(property_to_add_value) <- property_to_add_name

      # overwrite properties that already exist
      if(property_to_add_name %in% names(x)){
        x[property_to_add_name] <- property_to_add_value
        next()
      }
      # add new property
      x <- c(x, property_to_add_value)
    }

    # update
    my_data_schema$fields[[idx]] <- x
  }

  if(prune_datapackage){
    my_data_schema <- prune_datapackage(my_data_schema,structural_metadata)
  }

  # update the datapackage.json
  data_package <- data_package|>
    frictionless::remove_resource(resource_name) |>
    frictionless::add_resource(resource_name = resource_name,
                               data = resource_path,
                               schema = my_data_schema,
    )

  # write the datapackage.json
  frictionless::write_package(data_package,directory = data_package_dir)

  invisible()
}


#' Prune data pacakge
#'
#' method to remove properties from the metadata for a dataset in a datapackage
#'
#' @param my_data_schema list. schema object from frictionless
#' @param structural_metadata dataframe. structural metadata for a dataset
#'
#' @return pruned data_schema -
#' @export
#'
prune_datapackage <- function(my_data_schema, structural_metadata){

  # get property names
  property_names <- names(structural_metadata)

  # add minimal property values
  property_names_complete <- append(c("name","type"),property_names) |>
    unique()

  # create storage object
  my_data_schema_pruned <- my_data_schema

  # map over fields and remove metadata items not in property names complete
  my_data_schema_pruned$fields <- purrr::map(my_data_schema$fields, function(schema_item){

    properties_to_drop <- names(schema_item) %in% property_names_complete
    out <- schema_item[properties_to_drop]
    return(out)
  })

  return(my_data_schema_pruned)
}
