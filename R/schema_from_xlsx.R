#' Create ODK Schema from XLSX template
#'
#' Converts and odk xlsx template to a condensed version of the ODK schema retrieved
#' by RuODK. It is only necessary to use this function if you converted your xlsx file
#' to XML before uploading to ODK.
#'
#' @param file_path String. Path to excel file.
#'
#' @returns Data frame. In same format as
#' @export
#'
#' @examples
schema_from_odk_xlsx_template <- function(file_path){

 survey <- readxl::read_excel(file_path,sheet = "survey")

  names(survey)  <- names(survey)|>
   tolower() |>
   stringr::str_replace_all(pattern = "::| ",replacement = "_")

  survey_out <- survey |>
    dplyr::filter(!is.na(type)) |> ## drop begin group and end group
    dplyr::filter(stringr::str_detect(type, "begin group|end group",negate = TRUE))
  # get choices

  type_list <- stringr::str_split(survey_out$type,pattern = " ")

  types <- purrr::map_chr(type_list, ~.x[[1]])

  choice_id <- purrr::map_chr(type_list, function(x){
    out <- NA
    if(length(x) >1){
      choice_id <- x[[2]]
      if(choice_id != "group"){
        out <- choice_id
      }
    }
    return(out)
  })

  # add choice id
  survey_out$list_name <- choice_id
  survey_out$type <- types

  survey_out <- survey_out |>
    dplyr::mutate(selectMultiple = dplyr::case_when(
      type == "select_multiple" ~ TRUE,
      TRUE ~ NA
    ))

  choices <- readxl::read_excel(file_path,sheet = "choices")

  names(choices) <- ru_odk_case(names(choices))
  # condense choices into a tibble

  choices_no_na <- choices |>
    dplyr::filter(!is.na(list_name)) |>
    dplyr::group_by(list_name) |>
    dplyr::summarise(choices = list(name),
                     `choices_english_(en)` = list(`label_english_(en)`),
                     `choices_zulu_(zu)` = list(`label_zulu_(zu)`),
                     .groups = "drop")


  out <- dplyr::left_join(survey_out, choices_no_na, "list_name")

  return(out)

}


#' Convert to same case as in RuODK
#'
#' Essentially snakecase but preserving parenthesis
#'
#' @param x Character. Some character vector.
#'
#' @returns Character vector in modified snakecase
#' @export
ru_odk_case <- function(x){
  x |>
    tolower() |>
    stringr::str_replace_all(pattern = "::| ",replacement = "_")
}
