#' Validation Correction Checks
#'
#' @description
#' Validation correction tests to be run on data before and after validation to test expectations.
#'
#' @details
#' As part of the OH cleaning pipelines, raw data is converted to 'semi-clean' data
#' through a process of upserting records from an external Validation Log. To ensure these
#' corrections were made as expected, some checks are performed in this function.
#'
#' 1. If no existing log exists > no changes are make to data
#'    * Same variables
#'    * same Rows
#'    * No unequal values
#' 2. If log exists but no changes are recommended > no changes to data.
#'    * Same variables
#'    * same Rows
#'    * No unequal values
#' 3. Log exists and changes recommended > number of changes are same as log
#'    * Same variables
#'    * same Rows
#'    * Number of changing records in data match records in log
#' 4. Correct fields and records are being updated
#'    * Checks before and after variables and rows are the same
#'    * Checks the variable names and row indexes are the same in the logs and the changed data.
#'
#' @param validation_log tibble Validation log
#' @param before_data tibble Data before corrections
#' @param after_data tibble Data after corrections
#' @param primary_key character the primary key for the 'after_data'
#'
#' @return NULL if passed or stops with error
#' @export
#' @examples
#' \dontrun{
#'     validation_checks(
#'     validation_log = kzn_animal_ship_existing_log,
#'     before_data = kzn_animal_ship,
#'     after_data = kzn_animal_ship_semiclean,
#'     primary_key = "animal_id"
#'     )
#' }
#'
validation_checks <-
  function(validation_log,
           before_data,
           after_data,
           primary_key) {
    if (!is.null(validation_log)) {
      # preprocess the log
      preprocess_log <- validation_log |>
        dplyr::filter(
          no_change == "FALSE" | no_change == "F",
          !is.na(field),
          field != "",
          !is.na(entry),
          entry != "",
          !is.na(new_val) # since "" is an allowable value
        ) |>
        dplyr::mutate("entry_field" = paste(entry,field,sep = "_")) |>
        dplyr::mutate("entry_field_dupe" =  duplicated(entry_field,
                                                       fromLast = TRUE)) # check for duplicate entry-field combos.

        ## warning message for duplicate field and entry items
        if(any(preprocess_log$entry_field_dupe)){
          body <- stringr::str_wrap("Detected duplicate entry-field combination. The same item has been corrected at least twice in the log")
          row_ids <- preprocess_log[preprocess_log$entry_field_dupe,"rowid"]
          row_ids_cat <- paste(row_ids,collapse = "\n")

          msg <- sprintf("%s:\n%s", body,row_ids_cat)
          rlang::warn("Detected duplicate entry-field combination. The same item has been corrected at least twice in the log")
        }

      ## message about reversions
      if(any(preprocess_log$old_value == preprocess_log$new_val)){
        rlang::inform("Reversion to the an original value detected in the log.")
      }

      # drop duplicate or reversion changes
      validation_log_filtered <- preprocess_log|>
        dplyr::filter(
        # keep the last entry-field item for any repeated entry-field combos
        !entry_field_dupe,
        ## remove any changes that are reversions in the original value
        new_val != old_value)

      expected_changes <- validation_log_filtered |>
        dplyr::summarise(n = dplyr::n()) |>
        dplyr::pull(n)

      val_fields <- validation_log_filtered |>
        dplyr::pull(field) |>
        unique()

      val_recs <- validation_log_filtered |>
        dplyr::pull(entry) |>
        unique()

      val_recs_idx <-
        which(dplyr::pull(before_data[primary_key]) %in% val_recs)
    }

    # perform dataframe comparison ----

    cd <- arsenal::comparedf(before_data, after_data)
    s <- summary(cd)

    ### TESTS ----

    # TEST: If no existing log exists > no changes are make to data
    # same vars
    # same rows
    # No unequal values
    test1 <- if (is.null(validation_log)) {
      all(
        s$comparison.summary.table[s$comparison.summary.table$statistic == "Number of observations with some compared variables unequal", "value"] == 0,
        s$frame.summary.table$ncol[1] ==  s$frame.summary.table$ncol[2],
        s$frame.summary.table$nrow[1] ==  s$frame.summary.table$nrow[2]
      )
    } else {
      TRUE
    }

    # TEST: Log exists but no changes are recommended > No changes to data.
    # same vars
    # same rows
    # No unequal values
    test2 <- if (!is.null(validation_log) &
                 NROW(validation_log) == 0) {
      all(
        s$comparison.summary.table[s$comparison.summary.table$statistic == "Number of values unequal", "value"] == 0,
        s$frame.summary.table$ncol[1] ==  s$frame.summary.table$ncol[2],
        s$frame.summary.table$nrow[1] ==  s$frame.summary.table$nrow[2]
      )
    } else {
      TRUE
    }

    # TEST: Log exists and changes recommended > number of changes are same as log
    # same vars
    # same rows
    # number of changing records in data match records in log
    test3 <- if (!is.null(validation_log) & NROW(validation_log) > 0) {
      all(
        s$comparison.summary.table[s$comparison.summary.table$statistic == "Number of values unequal", "value"] == expected_changes,
        s$frame.summary.table$ncol[1] ==  s$frame.summary.table$ncol[2],
        s$frame.summary.table$nrow[1] ==  s$frame.summary.table$nrow[2]
      )
    } else {
      TRUE
    }

    # TEST: Correct fields and records are being updated
    test4 <- if (!is.null(validation_log) & NROW(validation_log) > 0) {
      all(
        all(s[["diffs.table"]][, 1] == s[["diffs.table"]][, 2]),
        all(s[["diffs.table"]][, 6] == s[["diffs.table"]][, 7]),
        is.null(set_diff(val_fields, s[["diffs.table"]][, 1])),
        is.null(set_diff(val_fields, s[["diffs.table"]][, 2])),
        is.null(set_diff(val_recs_idx,  as.character(s[["diffs.table"]][, 7])))
      )
    } else {
      TRUE
    }

    stopifnot(test1,
              test2,
              test3,
              test4)

    message("Validation correction checks completed without error.")

    return(s)

  }
