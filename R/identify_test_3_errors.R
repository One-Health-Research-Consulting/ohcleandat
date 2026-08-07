#' Function to troubleshoot cleaning errors that are identified in test 3 of the ohcleandat::validation_checks function.
#'
#'
#' @param validation_log The validation log that was used in the ohcleandat::validation_checks function that errored out
#' @param before_data    The before_data that was used in the ohcleandat::validation_checks function that errored out
#' @param after_data     The after_data that was used in the ohcleandat::validation_checks function that errored out
#' @param primary_key    The primary_key used in the before and after data (e.g. uuid)
#'
#' @return validation_log_val The validation_log with an additional 3 columns. It adds a column "checked" to indicate whether the new_val == the change made in the semiclean data. Good = the two matched, Mismatch = the new_val is not what is found in the semiclean data.
#' It also adds a column to show what the value for the corresponding row (entry) and column (field) is in the semiclean data (in a column named semiclean)
#' and in the original data (in a column named orig).
#' @export
#'
#' @examples
#'
#'
test_3_show_mismatch <- function(validation_log, before_data, after_data, primary_key){

  validation_log_val <- validation_log%>%
    filter(!no_change == "",
           !no_change == "TRUE",
           !no_change == "T")%>%
    mutate(checked = NA,
           semiclean = NA,
           orig = NA)

  validation_log_val[is.na(validation_log_val)] <- ""

  #check the before and after data for each entry-field combination from the validation log
  for(i in 1:nrow(validation_log_val)){
    row <- validation_log_val$entry[i]
    col <- validation_log_val$field[i]
    a_row_ind <- which(after_data[{{primary_key}}] == row)
    a <-after_data[[a_row_ind, col]] #value in the after data
    b_row_ind <- which(before_data[{{primary_key}}] == row)
    b <-before_data[[b_row_ind, col]] #  value in the before data

    #housekeeping that arsenal does automatically
    if(is.na(a)){
      a <- ""}
    if(is.na(b)){
      b <- ""}

    #The dates throw off the checker so convert to character if date for either a or b
    if(any(class(a) == c("POSIXct", "POSIXt", "Date"))){
      a1 <- as.character(a)
    }else{
      a1 <- a
    }
    if(any(class(b) == c("POSIXct", "POSIXt", "Date"))){
      b1 <- as.character(b)
    }else{
      b1 <- b
    }

    #Check 1
    if(a1 == "" & validation_log_val$new_val[i] == "" & validation_log_val$old_value[i] != ""){
      validation_log_val$checked[i] <- "Good"
      validation_log_val$semiclean[i] <- a1
      validation_log_val$orig[i] <- b1
    }else{
      if(a1 == "" | validation_log_val$new_val[i] == ""){
      #Check 2
      if(validation_log_val$new_val[i]== "" & a1 != ""){
        validation_log_val$checked[i] <- "No change"
        validation_log_val$semiclean[i] <- a1
        validation_log_val$orig[i] <- b1
      }else{
        #Check 3
          if(validation_log_val$new_val[i] != "" & a1 == ""){
            validation_log_val$checked[i] <- "Mismatch"
            validation_log_val$semiclean[i] <- a1
            validation_log_val$orig[i] <- b1
          }
         }
        }else{
        #Check 4
        if(a1 == validation_log_val$new_val[i] & b1 == ""){
          validation_log_val$checked[i] <- "Good"
          validation_log_val$semiclean[i] <- a1
          validation_log_val$orig[i] <- b1
        }else{
          #Check 5
          if(a1 == validation_log_val$new_val[i] & !(a1 ==b1)){
            validation_log_val$checked[i] <- "Good"
            validation_log_val$semiclean[i] <- a1
            validation_log_val$orig[i] <- b1
          }else{
            #Check 6
            if(b1 == validation_log_val$new_val[i]){
              validation_log_val$checked[i] <- "No change"
              validation_log_val$semiclean[i] <- a1
              validation_log_val$orig[i] <- b1
            }else{
              #Check 7
              validation_log_val$checked[i] <- "Mismatch"
              validation_log_val$semiclean[i] <- a1
              validation_log_val$orig[i] <- b1
            }
          }
        }
      }
    }
  }

  return(validation_log_val)

}

#' Test 3 validation checker for entries put in the log.
#' Run if the test_3_show_mismatch doesn't identify all the issues.
#' In my experience, this was an entry was put in the wrong log. E.g., if a validator had to
#' correct the location in the household survey data, but the correction was added to the
#' participant validation log AND they used the unique identifier from the participant database,
#' not the household survey as they meant to. So it doesn't
#' flag as an invalid primary_key nor as a mismatch change because the old_value is incorrect,
#' but in this participant survey example, the value in the before_data was correct and it stayed the same.
#' Thus, it's identified as a "No change" but can be hard to identify if you don't notice that the old_value
#' is different from the original value. This function can help focus the attention on a before_id
#' that aresenal does not identify as a change.
#'
#' @param validation_log
#' @param before_data
#' @param after_data
#' @param primary_key
#'
#' @return entries_to_check A vector of IDs to check, this will include any rows in the validation log that are flagged as "No change"
#' @export
#'
#' @examples
test_3_check_2 <- function(validation_log, before_data, after_data, primary_key){

  #Filter log
  validation_log_filtered <- validation_log%>%
    filter(!no_change == "",
           !no_change == "TRUE",
           !no_change == "T")%>%
    mutate(checked = NA,
           semiclean = NA,
           orig = NA)


  #Compare dfs
  cd <- arsenal::comparedf(before_data, after_data)

  id_diffs <- arsenal::diffs(cd)

  #before_ids <- before_data[, primary_key][id_diffs$row.x]
  before_ids <- before_data[id_diffs$row.x, primary_key]

  #Which of the log entries (primary_keys) are not in the before_ids that were identified as having changed id_diffs?
  vid <- validation_log_filtered$entry
  bid <- before_ids #before_ids$id

  `%nin%` <- Negate(`%in%`)

  missing_index <- which(vid %nin% bid)
  missing_index2 <- which(bid %nin% vid)

  entries_to_check <- validation_log_filtered$entry[missing_index]

  return(entries_to_check)

}



