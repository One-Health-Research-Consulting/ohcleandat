

keep_corrected_entries <- function(existing_log,
                                   new_log){

  # if the log returns NULL (for example there is no existing log), then return NULL
  if(is.null(existing_log)){
    message("Validation log doesnt exist yet. Returning NULL")
    return(NULL)
  }


  ## keep records in new log
  validation_log <- dplyr::inner_join(existing_log,new_log,by = c("field","issue"))


  # keeping only records for correction (no_change = F) and removing NA or blank required info
  # is possible to have new value be an empty string e.g. ""
  validation_log <- validation_log |>
    dplyr::filter(
      no_change == "FALSE" | no_change == "F",
      !is.na(field),
      field != "",
      !is.na(entry),
      entry != ""
    )

  # if nothing to correct return NULL
  if(nrow(validation_log) == 0){
    message("Nothing to correct. Returning data.")
    return(data)
  }

  ## return validation log with only corrected values
  return(validation_log)


}



drop_corrected_entries <- function(existing_log,
                                   new_log){

  # if the log returns NULL (for example there is no existing log), then return NULL
  if(is.null(existing_log)){
    message("Validation log doesnt exist yet. Returning NULL")
    return(NULL)
  }


  ## keep records in new log
  validation_log <- dplyr::inner_join(existing_log,new_log,by = c("field","issue"))


  # keeping only records for correction (no_change = F) and removing NA or blank required info
  # is possible to have new value be an empty string e.g. ""
  validation_log <- validation_log |>
    dplyr::filter(
      no_change == "FALSE" | no_change == "F",
      !is.na(field),
      field != "",
      !is.na(entry),
      entry != ""
    )

  # if nothing to correct return NULL
  if(nrow(validation_log) == 0){
    message("Nothing to correct. Returning data.")
    return(data)
  }

  ## return validation log with only corrected values
  return(validation_log)


}





