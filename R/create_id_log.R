#' Create ID validation log
#'
#' This function does two things:
#'
#' 1) Pairwise comparison of foreign keys across two datasets.
#' Foreign keys are matching columns that exist in two different datasets
#' that allow you to link the two together (i.e. human, animal, household).
#'
#' A foreign key could also be a dataset's primary key. A primary key
#' is the column that uniquely identifies every single row in a data set.
#'
#' 2) Flags duplicate foreign keys within a single data set.
#'
#' The unaligned comparisons and duplicated flagged get put in to a single validation
#' log with one row per problem foreign key.
#'
#' This allows for foreign key cleaning across your data and sets you up for integration.
#'
#' @seealso
#' See the online documentation and vignette at
#' \url{https://one-health-research-consulting.github.io/ohcleandat/articles/create_id_log_function.html}
#'
#'
#' @param semiclean_x data.frame or tibble containing foreign key to check for existence in y
#' @param semiclean_y data.frame or tibble containing foreign key to check for existence in x
#' @param by character containing match id, or if named different, a named character vector like c("a" = "b")
#' this function assumes that the named character vector follows the convention of
#' c("variable in semiclean_x" = "variable in semiclean_y")
#' @param primary_key_x character vector of the row identifier for data.frame x
#' @param primary_key_y character vector of the row identifier for data.frame y
#' @param name_x character of file name for semiclean_x
#' @param name_y character of file name for semiclean_y
#'
#' @export
#'
#' @return tibble formatted as a validation log for human review
#'
#' @examples
#' #testing no differences and no duplicates
#'semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = letters[1:10])
#'semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[1:10])
#'
#'test_no_mm<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
#'                          "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")
#'
#'#should be an empty log
#'
#'#testing 2 differences
#'semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = letters[1:10])
#'semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[2:11])
#'
#'test_mm_2<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
#'                         "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")
#'
#'#should have a log with 2 rows of IDs, one from y (household_id) and one from x (hhid)
#'
#' @seealso `dplyr::anti_join`
create_id_log <- function(semiclean_x, semiclean_y, by, primary_key_x, primary_key_y, name_x, name_y){

   if(is.null(names(by))){
    names(by)<-by
   }

  #in order to do the anti-join we need to invert link relationship of "by"
  by_y<-names(by)
  names(by_y)<-by

  x_names<-c(names(by), primary_key_x)
  y_names<-c(names(by_y), primary_key_y)
  dataset_x<-basename(name_x)
  dataset_y<-basename(name_y)

  safe_anti_join <- function(a, b, join_by, keep_cols, from, to) {
    tryCatch(
      dplyr::anti_join(a, b, by = join_by) |>
        dplyr::select(tidyselect::all_of(keep_cols)),
      error = function(e) {
        if (grepl("incompatible types", conditionMessage(e))) {
          rlang::abort(
            c(
              paste0("The ID columns linking '", from, "' and '", to, "' are stored as different types (i.e. one is an integer column and one is a character column)."),
              "i" = "This function assumes that the ID columns are the same in both datasets to be matched please check your datasets for why this error is happening.",
              "!" = "Check for leading zeros (e.g. '007' vs 7) or the use of the letter 'O' as a zero to ensure that ID columns are being read in from their source as the same type."
            ),
            parent = e
          )
        } else {
          rlang::abort(
            c(
              paste0("Could not compare IDs in '", from, "' against '", to, "'."),
              "i" = "Check that the names in `by` and the primary keys exist in both datasets."
            ),
            parent = e
          )
        }
      }
    )
  }


  anti_x <- safe_anti_join(semiclean_x, semiclean_y, by,   x_names, dataset_x, dataset_y)
  anti_y <- safe_anti_join(semiclean_y, semiclean_x, by_y, y_names, dataset_y, dataset_x)

  validation_log_x<-anti_x|>
    dplyr::select(!tidyselect::all_of(x_names))
  validation_log_y<-anti_y|>
    dplyr::select(!tidyselect::all_of(y_names))

  if(nrow(anti_x)>0){
  validation_log_x<-anti_x|>
    dplyr::mutate(dataset = dataset_x,
                  entry = dplyr::pull(anti_x, primary_key_x),
                  field = names(by),
                  issue = paste(names(by), "in", dataset_x, "does not match any", by, "in", dataset_y),
                  old_value = dplyr::pull(anti_x, by_y),
                  no_change = '',
                  new_val = '',
                  user_initials = '',
                  comments = ''
    ) |>
    dplyr::select(!tidyselect::all_of(x_names))}

  if(nrow(anti_y)>0){
    #browser()
  validation_log_y<-anti_y|>
    dplyr::mutate(dataset = dataset_y,
                  entry =dplyr::pull(anti_y, primary_key_y),
                  field = by,
                  issue = paste(by, "in", dataset_y, "does not match any", names(by), "in", dataset_x),
                  old_value = dplyr::pull(anti_y, by),
                  no_change = '',
                  new_val = '',
                  user_initials = '',
                  comments = ''
    ) |>
    dplyr::select(!tidyselect::all_of(y_names))}

  dupes_x <- semiclean_x |>
    dplyr::group_by(dplyr::across(tidyselect::all_of(names(by)))) |>
    dplyr::filter(dplyr::n() > 1) |>
    dplyr::ungroup() |>
    dplyr::select(tidyselect::all_of(x_names)) |>
    dplyr::mutate(
      dataset       = dataset_x,
      entry         = dplyr::pull(dplyr::pick(primary_key_x), primary_key_x),
      field         = names(by),
      issue         = paste("Duplicate", names(by), "in", dataset_x),
      old_value     = dplyr::pull(dplyr::pick(names(by)), names(by)),
      no_change     = '',
      new_val       = '',
      user_initials = '',
      comments      = ''
    ) |>
    dplyr::select(!tidyselect::all_of(x_names))

  dupes_y <- semiclean_y |>
    dplyr::group_by(dplyr::across(tidyselect::all_of(by))) |>
    dplyr::filter(dplyr::n() > 1) |>
    dplyr::ungroup() |>
    dplyr::select(tidyselect::all_of(y_names)) |>
    dplyr::mutate(
      dataset       = dataset_y,
      entry         = dplyr::pull(dplyr::pick(primary_key_y), primary_key_y),
      field         = by,
      issue         = paste("Duplicate", by, "in", dataset_y),
      old_value     = dplyr::pull(dplyr::pick(names(by_y)), names(by_y)),
      no_change     = '',
      new_val       = '',
      user_initials = '',
      comments      = ''
    ) |>
    dplyr::select(!tidyselect::all_of(y_names))

  log_list <- list(validation_log_x, validation_log_y, dupes_x, dupes_y) |>
    purrr::keep(~ nrow(.x) > 0)

  complete_validation_log <- dplyr::bind_rows(log_list)


  # want to keep system as simple as possible to make sure working properly
  # can add ID look up and key if data gets restructured before ID logs are created

  # id_key<-read.csv(file = data_id_key)
  #
  # #changing the names of the IDs using id key so that the field names match what is written
  # #in the semiclean
  #
  # f <- e |>
  #   dplyr::left_join(id_key, by = c("field" = "idclean", "dataset" = "database")) |>
  #   dplyr::mutate(field = dplyr::coalesce(idraw, field)) |>
  #   dplyr::select(-idraw)


  return(complete_validation_log)

}
