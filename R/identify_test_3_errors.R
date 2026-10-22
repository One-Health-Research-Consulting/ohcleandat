#' Function to troubleshoot cleaning errors that are identified in test 3 of the ohcleandat::validation_checks function.
#'
#'This function is used after data is cleaned and validation_checks are run and a test 3 error occurs.
#'Test 3 errors indicate that the change written in the validation log was either made and was incorrect or was not made.
#'The test 3 error can be difficult to interpret, and the log that this function creates helps you find where the error is coming from.
#'Corrections can then be made to the validation log to address the type 3 error. The data cleaning and validation steps can then be re-run to see if the type 3 error was resolved.
#'This function also compares the rows with changes identified by arsenal with the rows in the validation log that have changes. Rows are flagged in a new column called "arsenal_flag."
#'This log will not be joined to the main validation logs, it only to be used for identifying type 3 errors.
#'
#'
#' @param validation_log tibble Validation log
#' @param before_data tibble Data before corrections
#' @param after_data tibble Data after corrections
#' @param primary_key character the primary key for the 'after_data'
#'
#' @return test_3_validation_check The validation_log with an additional 4 columns. It adds a column "checked" to indicate whether the new_val == the change made in the after_val data: "Good" = the two matched, "No change" = the after_val value is still the same as the orig value,  "Mismatch" = the new_val is not what is found in the after_val data.
#' It also adds a column to show what the value for the corresponding row (entry) and column (field) is in the after_val data (in a column named after_val)
#' and in the original data (in a column named orig). Lastly, there is a column "arsenal_flag" that indicates rows that have changes being picked up in arsenal and not in the validation log or vice versa. It focuses the attention on a before_id that aresenal does not identify as a change.
#' @export
#'
#' @examples
#'
#'
test_3_show_mismatch <- function(validation_log, before_data, after_data, primary_key){

  test_3_validation_check <- validation_log%>%
    dplyr::filter(!no_change == "",
           !no_change == "TRUE",
           !no_change == "T")%>%
    dplyr::mutate(checked = NA,
           after_val = NA,
           orig = NA)

  test_3_validation_check[is.na(test_3_validation_check)] <- ""

  #check the before and after data for each entry-field combination from the validation log
  for(i in 1:nrow(test_3_validation_check)){
    row <- test_3_validation_check$entry[i]
    col <- test_3_validation_check$field[i]
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
    #Checks that if the validation log new_val is "" and the value in the after_val data is "" while the old_value in the orignal value had an incorrect response
    if(a1 == "" & test_3_validation_check$new_val[i] == "" & test_3_validation_check$old_value[i] != ""){
      test_3_validation_check$checked[i] <- "Good"
      test_3_validation_check$after_val[i] <- a1
      test_3_validation_check$orig[i] <- b1
    }else{
      if(a1 == "" | test_3_validation_check$new_val[i] == ""){#If either a1 or the new_val is "", then check the following
      #Check 2
      #Checks if the validation log new_val is blank, but the after_val value still has a value and no change was made
      if(test_3_validation_check$new_val[i]== "" & a1 != ""){
        test_3_validation_check$checked[i] <- "No change"
        test_3_validation_check$after_val[i] <- a1
        test_3_validation_check$orig[i] <- b1
      }else{
        #Check 3
        #Checks if the validation log new_val has a value, but the after_val data is blank
        if(test_3_validation_check$new_val[i] != "" & a1 == "" & b1 != ""){
          test_3_validation_check$checked[i] <- "Mismatch"
          test_3_validation_check$after_val[i] <- a1
          test_3_validation_check$orig[i] <- b1
        }
        #Check 4
        #Checks if the validation log new_val has a value, but the after_val data is blank
          if(test_3_validation_check$new_val[i] != "" & a1 == "" & b1 == ""){
            test_3_validation_check$checked[i] <- "No change"
            test_3_validation_check$after_val[i] <- a1
            test_3_validation_check$orig[i] <- b1
          }
         }
        }else{
        #Check 5
        #Checks if the validation log new_val is the same as the after_val data and the before data value was blank
        if(a1 == test_3_validation_check$new_val[i] & b1 == ""){
          test_3_validation_check$checked[i] <- "Good"
          test_3_validation_check$after_val[i] <- a1
          test_3_validation_check$orig[i] <- b1
        }else{
          #Check 6
          #Checks if the validation log new_val is the same as the after_val data and the before data value is not the same as the after_val data value
          if(a1 == test_3_validation_check$new_val[i] & !(a1 ==b1)){
            test_3_validation_check$checked[i] <- "Good"
            test_3_validation_check$after_val[i] <- a1
            test_3_validation_check$orig[i] <- b1
          }else{
            #Check 7
            #Checks if the before data value was is the same as what was put in the new_val in the validation log
            if(b1 == test_3_validation_check$new_val[i]){
              test_3_validation_check$checked[i] <- "No change"
              test_3_validation_check$after_val[i] <- a1
              test_3_validation_check$orig[i] <- b1
            }else{
              #Check 8
              #if the before data value and after data value are the same, but the new_value had a different value
              if(b1 == a1 & a1 != test_3_validation_check$new_val[i]){
                test_3_validation_check$checked[i] <- "No change"
                test_3_validation_check$after_val[i] <- a1
                test_3_validation_check$orig[i] <- b1
              }else{
              #Check 9
              #If it is not found to be good or no change and therefore it is likely a mismatch
              test_3_validation_check$checked[i] <- "Mismatch"
              test_3_validation_check$after_val[i] <- a1
              test_3_validation_check$orig[i] <- b1
            }
          }
        }
      }
    }
    }
  }

  #Compare dfs
  cd <- arsenal::comparedf(before_data, after_data)

  id_diffs <- arsenal::diffs(cd)

  #before_ids <- before_data[, primary_key][id_diffs$row.x]
  before_ids <- before_data[id_diffs$row.x, primary_key]

  #Which of the log entries (primary_keys) are not in the before_ids that were identified as having changed id_diffs?
  vid <- test_3_validation_check$entry
  bid <- before_ids #before_ids$id

  `%nin%` <- Negate(`%in%`)

  missing_index <- which(vid %nin% bid)
  missing_index2 <- which(bid %nin% vid)

  entries_to_check <- test_3_validation_check$entry[missing_index]

#Add to output
  test_3_validation_all <- test_3_validation_check%>%
    dplyr::mutate(arsenal_flag = if_else(entry %in% entries_to_check, 1, 0))


  return(test_3_validation_all)

}

