#' Create Validation Log
#'
#' @param data data fame  Input data to be validated
#' @param rule_set  a rule set of class validator from the validate package
#' @param primary_key character  a character vector giving the column name of the primary key or unique row identifier in the data
#' @param ... other arguments passed to validate::confront
#' @param reserved_field_prefix String. A prefix for reserved fields. This allows
#' the log to safely handle field names from the data that match field names in the log.
#'
#'
#'
#' @return a data frame formatted as a validation log for human review
#' @export
#'
create_validation_log <- function(data, primary_key, rule_set, reserved_field_prefix = "reserved_ohcleandat_", ...) {


  # validate the data
  conf_obj <- validate::confront(data, rule_set, raise = 'all', ...)

  rule_sum <- validate::summary(conf_obj) |>
    cbind(description = validate::meta(rule_set)[["description"]]) |>
    dplyr::mutate(
      description = dplyr::na_if(description, ""),
      description = dplyr::coalesce(description, expression)
    )

  rule_vals <- validate::values(conf_obj)


  # reserved names -----
  ## change names after confronting because
  # the ohcleandat log fields should not dictate the contents of the data
  # collection instrument
  reserved_field_names <- c("entry",
                            "field",
                            "issue",
                            "old_value",
                            "no_change",
                            "new_val",
                            "user_initials",
                            "comments"
  )

  if(any(grepl(reserved_field_prefix,x = names(data)))){

    msg <- sprintf("One or more columns use the reserved_field_prefix (%s) in their name.
            Please change the reserved_field_prefix to a non-conflicting value",reserved_field_prefix )

    rlang::abort(msg)
  }

  filter_data_names <- names(data) %in% reserved_field_names

  if(any(filter_data_names)){
    data <- dplyr::rename_with(data,
                               ~paste0(reserved_field_prefix,.x),
                               tidyselect::contains(
                                 names(data)[filter_data_names]
                               ))

  }

  ## create issues ----

  issues <- rule_vals |>
    tibble::as_tibble() |>
    dplyr::mutate(id = dplyr::pull(data, primary_key), .before = 1) |>
    tidyr::pivot_longer(cols = -id)  |>
    dplyr::filter(value == FALSE) |>
    dplyr::inner_join(rule_sum, by = dplyr::join_by(name)) |>
    dplyr::select(entry = id,
                  field = name,
                  issue = description) |>
    dplyr::mutate(field = stringr::str_extract(field, pattern = "^.*?(?=\\.(\\d+)|$)")) |>
    dplyr::left_join(
      data,
      by = c("entry" = primary_key),
      na_matches = "never",
      keep = TRUE
    )

  # create log ----

  log <- issues |>
    dplyr::mutate(dplyr::across(tidyselect::everything(), as.character)) |>
    tidyr::pivot_longer(-c(entry, field, issue),
                        values_to = "old_value",
                        values_transform = as.character) |>
    # drop prefix from name if its there
    dplyr::mutate(name = stringr::str_remove(name,reserved_field_prefix)) |>
    dplyr::filter(field == name) |>
    dplyr::select(-name) |>
    tidyr::replace_na(list(old_value = '')) |>
    dplyr::mutate(
      no_change = '',
      new_val = '',
      user_initials = '',
      comments = '',
    ) |>
    dplyr::select(entry,
                  field,
                  issue,
                  old_value,
                  no_change,
                  new_val,
                  user_initials,
                  comments)


  return(log)

}
