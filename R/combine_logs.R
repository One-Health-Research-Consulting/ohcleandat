#' Combine Validation Logs
#'
#' Checks for the existence of an existing validation log and appends
#' new records from the current run.
#'
#' @param existing_log tibble existing validation log
#' @param new_log tibble newly generated validation log
#'
#' @export
#'
#' @return tibble appended validation log for upload
combine_logs <- function(existing_log, new_log, is_id_log = FALSE){


  # if id log (based on fields), remove any uncorrected entries in the existing
  # log.
  if(is_id_log & is.data.frame(existing_log)){
    existing_log <- existing_log |>
      dplyr::filter(!is.na(no_change),
                    no_change != "")
  }


  # Does the existing log exist (it wont on initial run)
  if (is.null(existing_log)) {
    log_combined <- new_log
  } else {
    new_recs <- dplyr::anti_join(new_log, existing_log, by = dplyr::join_by(entry, field, issue, old_value))
    log_combined <- dplyr::bind_rows(existing_log, new_recs)
  }

  # adding row index to keep track of order. Also adding a unique, easier to parse
  # respondent id to assist humans when doing validation. These do not persist
  # and are re-generated when the new log is uploaded.
  log_out <- log_combined |>
    dplyr::group_by(entry) |>
    dplyr::mutate(log_response_id = dplyr::cur_group_id(), .before = "entry") |>
    tibble::rowid_to_column(var = 'rowid') |>
    dplyr::ungroup()

  return(log_out)
}



