#' Title
#'
#' @param existing_log data frame. An existing validation log.
#' @param id_log data frame. An id validation log
#' @param ... Additional id validation logs to be joined
#' @param dataset_name String. the name of the dataset as it appears in the id
#' validation log(s). This function uses exact matches "=="
#'
#' @returns
#' @export
#'
#' @examples
join_id_log <-function(existing_log, id_log,...,dataset_name){
  # filter id log to a dataset
  big_id_log <- dplyr::bind_rows(id_log,...)
  id_log_filtered <- big_id_log |>
    dplyr::filter(dataset == !!dataset_name) |>
    dplyr::select(-dataset)
  # rbind the filtered data to the existing log
    out <- dplyr::bind_rows(existing_log,id_log_filtered)
  # this log is used for creating semi-clean data
    return(out)
}
