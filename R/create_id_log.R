#' ID Validation and Verification log
#'
#' This function does two things:
#' 1) Pairwise comparison of ID (i.e. human, animal, household) columns across two
#' data sets.
#' 2) Flags duplicate IDs within a data set.
#'
#' This allows for ID cleaning across data sets and sets you up for integration.
#'
#'
#' @param semiclean_x data.frame or tibble containing match id to check for non existence in y
#' @param semiclean_y data.frame or tibble to check for non-existence of match id from x
#' @param by character containing match id, or if named different, a named character vector like c("a" = "b")
#' this function assumes that the named character vector follows the convention of
#' c("variable in semiclean_x" = "variable in semiclean_y")
#' @param primary_key_x character vector of the row identifier for data.frame x
#' @param primary_key_y character vector of the row identifier for data.frame y
#' @param name_x character of file name for semiclean_x
#' @param name_y character of file name for semiclean_y
#'
#' @param ... other variables passed to dplyr::anti_join
#'
#' @export
#'
#' @return tibble formatted as a validation log for human review
#'
#' @examples \dontrun{

#' }
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

  anti_x<-dplyr::anti_join(semiclean_x, semiclean_y, by) |>
    dplyr::select(tidyselect::all_of(x_names))
  anti_y<-dplyr::anti_join(semiclean_y, semiclean_x, by_y) |>
    dplyr::select(tidyselect::all_of(y_names))

  validation_log_x<-anti_x|>
    dplyr::select(!all_of(x_names))
  validation_log_y<-anti_y|>
    dplyr::select(!all_of(y_names))

  if(nrow(anti_x)>0){
  validation_log_x<-anti_x|>
    dplyr::mutate(dataset = dataset_x,
                  entry = dplyr::pull(anti_x, primary_key_x),
                  field = by,
                  issue = paste(names(by), "in", dataset_x, "does not match any", by, "in", dataset_y),
                  old_value = dplyr::pull(anti_x, by_y),
                  no_change = '',
                  new_val = '',
                  user_initials = '',
                  comments = ''
    ) |>
    dplyr::select(!all_of(x_names))}

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
    dplyr::select(!all_of(y_names))}

  dupes_x <- semiclean_x |>
    dplyr::group_by(across(all_of(names(by)))) |>
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
    dplyr::select(!all_of(x_names))

  dupes_y <- semiclean_y |>
    dplyr::group_by(across(all_of(by))) |>
    dplyr::filter(dplyr::n() > 1) |>
    dplyr::ungroup() |>
    dplyr::select(tidyselect::all_of(y_names)) |>
    dplyr::mutate(issue = "Duplicate in dataset Y")

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
