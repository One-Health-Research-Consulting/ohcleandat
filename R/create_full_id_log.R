
#' Create the full set of id validation logs
#'
#' Takes a list of datasets with shared foreign keys (identifiers that should match
#' across the datasets) and creates the full set of pairwise id validation logs.
#' This function is essentially a wrapper for [create_id_log()] that computes
#' all the unique pairs of datasets in a given list then runs each pair through
#' `create_id_log`.
#'
#' `create_id_log` flags duplicate foreign keys and any foreign keys not in both
#' datasets. The purpose of this log is to ensure links between datasets created
#' by foreign keys are correct and to help identify any potentially missing data.
#'
#' Foreign keys are identifiers that link two or more datasets.
#'
#' Primary keys are identifiers that uniquely identify items in a dataset.
#'
#' @param dataset_list List. A list of datasets where each item has the following
#' fields semiclean_data, foreign_key, primary_key, and name.
#'
#' @returns dataframe id validation log
#' @export
#'
#' @examples
#'
#' # dataset 1 and dataset 2 have perfectly matching foreign keys
#' # and the fields are consistently named.
#'
#' dataset_item_1 <- list(
#' semiclean_data = data.frame(primary_key = 1:10,
#'                             foreign_key = letters[1:10]),
#' foreign_key = "foreign_key",
#' primary_key = "primary_key",
#' name = "dataset_1"
#' )
#'
#'
#' dataset_item_2 <- list(
#'   semiclean_data = data.frame(primary_key = 1:10,
#'                               foreign_key = letters[1:10]),
#'   foreign_key = "foreign_key",
#'   primary_key = "primary_key",
#'   name = "dataset_2"
#' )
#'
#' # dataset 3 uses a different column name for the shared "foreign_key", is missing a,
#' # and has an additional key k
#' dataset_item_3 <- list(
#'   semiclean_data = data.frame(blah = 1:10,
#'                               bob = letters[2:11]),
#'   foreign_key = "bob",
#'   primary_key = "blah",
#'   name = "dataset_3"
#' )
#'
#' # dataset 4 uses yet another name for the shared "foreign_key", has duplicate a's,
#' # and is missing b
#'
#' dataset_item_4 <- list(
#'   semiclean_data = data.frame(blah = 1:10,
#'                               gary = c(rep(letters[1],2),letters[3:10])
#'   ),
#'   foreign_key = "gary",
#'   primary_key = "blah",
#'   name = "dataset_4"
#' )
#'
#' dataset_list <- list(dataset_item_1,dataset_item_2,dataset_item_3, dataset_item_4)
#'
#'create_full_id_log(dataset_list)
#'
create_full_id_log <- function(dataset_list){

  # dataset_list must have a length greater than 1
  assertthat::assert_that(length(dataset_list) > 1,
                          msg = "dataset_list must have a length greater than 1.")

  # check that each dataset_list item has
  # all necessary properties

  purrr::walk(dataset_list, function(x){

    check_prop_names <- all(names(x) %in% c("semiclean_data",
                                            "foreign_key",
                                            "primary_key",
                                            "name"))
    assertthat::assert_that(check_prop_names,
                            msg = "Each list item must contain semiclean_data, foreign_key, primary_key, name")

    assertthat::assert_that(is.data.frame(x$semiclean_data),
                            msg = "semiclean_data must be a data.frame")

    assertthat::assert_that(assertthat::is.string(x$foreign_key),
                            msg = "foreign_key must be character and length 1 (scalar string)")

    assertthat::assert_that(assertthat::is.string(x$primary_key),
                            msg = "primary_key must be character and length 1 (scalar string)")

    assertthat::assert_that(assertthat::is.string(x$name),
                            msg = "name must be character and length 1 (scalar string)")



  })


  # get all unique pairs where order doesnt matter
  dataset_pairs <- utils::combn(1:length(dataset_list),2,simplify = FALSE)

  id_logs <- purrr::map(dataset_pairs,function(pair){
    x <- pair[1]
    y <- pair[2]

    x_item <- dataset_list[[x]]
    y_item <- dataset_list[[y]]

    # setup named vector for join
    names(y_item$foreign_key) <- x_item$foreign_key


    id_log <- create_id_log(semiclean_x = x_item$semiclean_data,
                                 semiclean_y = y_item$semiclean_data,
                                 by = y_item$foreign_key,
                                 primary_key_x = x_item$primary_key,
                                 primary_key_y = y_item$primary_key,
                                 name_x = x_item$name,
                                 name_y = y_item$name)

    return(id_log)
  }) |>
    purrr::list_rbind() |>
    dplyr::distinct()

  return(id_logs)

}
