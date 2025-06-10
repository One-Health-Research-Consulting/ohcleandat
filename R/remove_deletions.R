#' Utility function to identify records for deletion
#'
#' @description
#' Filters for records matching a given string.
#'
#' @details
#' To be used within `dplyr::filter()`. The function returns a logical vector
#' with TRUE resulting from values that are not equal to the `val` argument. Also
#' protects from NA values.
#'
#' Used within verbs such as `tidyselect::all_of()` this can work effectively across all
#' columns in a data frame. See examples
#'
#' @param x input vector
#' @param val Character or regex. The value to check for inequality. Val is fed into
#' stringr::str_detect as the pattern parameter. Defaults to 'Delete' with
#' ignore case = TRUE. See stringr::str_detect for more details.
#'
#' @return logical vector
#' @export
#'
#' @examples
#' data <- data.frame("a" = sample(c("Delete", "Keep",NA),size = 10,replace = TRUE))
#'
#' data |>
#'   dplyr::filter(dplyr::if_all(everything(), remove_deletions))
#'
remove_deletions <- function(x, val = stringr::regex("Delete",ignore_case = TRUE)){

  stringr::str_detect(string = x, pattern = val,negate = TRUE) | is.na(x)
}
