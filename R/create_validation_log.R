#' Create Validation Log
#'
#' @param data data fame  Input data to be validated
#' @param rule_set  a rule set of class validator from the validate package
#' @param primary_key character  a character vector giving the column name of the primary key or unique row identifier in the data
#' @param ... other arguments passed to validate::confront
#'
#' @return a data frame formatted as a validation log for human review
#' @export
#'
create_validation_log <- function(data, primary_key, rule_set, ...) {
  conf_obj <- validate::confront(data, rule_set, raise = 'all', ...)

  rule_sum <- validate::summary(conf_obj) |>
    cbind(description = validate::meta(rule_set)[["description"]]) |>
    dplyr::mutate(
      description = dplyr::na_if(description, ""),
      description = dplyr::coalesce(description, expression)
    )

  rule_vals <- validate::values(conf_obj)

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

  log <- issues |>
    dplyr::mutate(dplyr::across(tidyselect::everything(), as.character)) |>
    tidyr::pivot_longer(-c(entry, field, issue),
                        values_to = "old_value",
                        values_transform = as.character) |>
    dplyr::filter(field == name) |>
    dplyr::select(-name) |>
    tidyr::replace_na(list(old_value = '')) |>
    dplyr::mutate(
      is_valid = '',
      new_val = '',
      user_initials = '',
      comments = '',
    ) |>
    dplyr::select(entry,
                  field,
                  issue,
                  old_value,
                  is_valid,
                  new_val,
                  user_initials,
                  comments)

  return(log)

}
