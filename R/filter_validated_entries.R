
#' Keep Validated Entries in Log for Further Validation
#'
#' This function compares an existing log and new log and keeps entries that
#' have been validated in the existing log and created in the new log.
#'
#' This is used in the free_text other_choices validation sequence to reduce
#' the number of times a record is validated twice. In this use case, questions
#' that contain an "other choice" are identified in a look up table. If they have
#'  been validated in the free text log, then they can be flagged in the
#'  `other_choice` log.
#'
#'
#'
#' @param existing_log
#' @param new_log
#'
#' @returns
#' @export
#'
#' @examples
keep_validated_entries <- function(existing_log,
                                   new_log){

  # if the log returns NULL (for example there is no existing log), then return new_log
  if(is.null(existing_log)){
    message("Existing log is null. Returning new_log")
    return(new_log)
  }

  # trim new log to only fields for join.
  new_log_for_join <- new_log |>
    dplyr::select(entry,field, issue)

  # keep unique entries in the log, dropping any "early" duplicates
  existing_log_for_join <- existing_log |>
    dplyr::mutate(dup_id = sprintf("%s_%s_%s",entry,field,issue)) |>
    dplyr::filter(!duplicated(dup_id, fromLast = TRUE)) |> # keep last non-duplicate entry
    dplyr::select(-dup_id)

  ## keep records in new log
  validation_log <- dplyr::inner_join(existing_log_for_join,new_log_for_join,by = c("entry","field","issue"))


  # keeping only records for correction (no_change = F) and removing NA or blank required info
  # is possible to have new value be an empty string e.g. ""
  validated_log_entries <- validation_log |>
    dplyr::filter(
      stringr::str_detect(no_change,pattern = stringr::regex("F|FALSE|T|TRUE",ignore_case = TRUE)),
      !is.na(field),
      field != "",
      !is.na(entry),
      entry != ""
    )

  # if nothing to correct return NULL
  if(nrow(validated_log_entries) == 0){
    message("Nothing valdiated. Returning an empty df")
  }

  ## return validation log with only corrected values
  return(validated_log_entries)


}



#' Drop Validated Entries in Log
#'
#' Removes any entries that have been validated in the existing log.
#' Will return records that are in both logs and have no_change = NA
#'
#' @param existing_log
#' @param new_log
#'
#' @returns
#' @export
#'
#' @examples
drop_validated_entries <- function(existing_log,
                                   new_log){

  ## keep last entry for a entry field issue combo
  existing_log_for_join <- existing_log |>
    dplyr::mutate(dup_id = sprintf("%s_%s_%s",entry,field,issue)) |>
    dplyr::filter(!duplicated(dup_id, fromLast = TRUE)) |> # keep last non-duplicate entry
    dplyr::select(-dup_id)


  # make corrected records df
  validated_log_entries <- keep_validated_entries(existing_log_for_join,new_log)

  # drop extra fields
  validated_for_join <- validated_log_entries |>
    dplyr::select(entry, field, issue)

  # filter to unvalidated records
  unvalidated_log_entries <- dplyr::anti_join(existing_log_for_join, validated_for_join, by = c("entry","field","issue"))

  # if all corrected
  if(nrow(unvalidated_log_entries) == 0){
    message("All validated entries. returning an empty df")
  }

  ## return validation log with only corrected values
  return(unvalidated_log_entries)


}





