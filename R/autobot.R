#' Autobot Function
#'
#' This compares two columns. Where there are differences, it extracts the values
#' and compiles a correctly formatted validation log. This is intended to be
#' used when an automated formatting correction is proposed in the data, but the
#' actual updating of the records is required to happen via the validation log.
#'
#' @param data data.frame or tibble
#' @param old_col The existing column with formatting issues
#' @param new_col The new column with corrections applied
#' @param primary_key column that uniquely identifies the records in data
#'
#' @export
#'
#' @return tibble formatted as validation log
#'
autobot <- function(data, old_col, new_col, primary_key) {
  data |>
    dplyr::filter(!!rlang::sym(old_col) != !!rlang::sym(new_col)) |>
    dplyr::mutate(entry = !!rlang::sym(primary_key)) |>
    tidyr::pivot_longer(!!rlang::sym(old_col), names_to = "field", values_to = "old_value") |>
    dplyr::mutate(
      field,
      issue = "Automated field format check failed",
      old_value,
      new_val = !!rlang::sym(new_col),
      no_change = as.character(ifelse(is.na(!!rlang::sym(new_col)), "", "FALSE")),
      user_initials = "autobot",
      comments = ""
    ) |>
    dplyr::select(entry,
           field,
           issue,
           old_value,
           no_change,
           new_val,
           user_initials,
           comments)
}
