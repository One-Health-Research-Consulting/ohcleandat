#' Create Translation Log
#'
#'  Collates free text responses from text fields in the survey
#' data. Some language detection is performed and placed in the log notes section
#' for possible translation.
#'
#' @param response_data data.frame of ODK questionnaire responses
#' @param form_schema data.frame or flattened ODK form schema
#' @param url The ODK submission URL excluding the uuid identifier
#' @param type_to_keep String. Regex pattern passed to `stringr::str_detect`.
#'
#' @export
#'
#' @return data.frame validation log
#'
#' @examples
#' \dontrun{
#'
#' odk_schema_data <- schema_from_odk_xlsx_template(file_path = "inst/example_odk_schema.xlsx")
#'
#' create_free_text_log(response_data = semi_clean_data,
#'                       form_schema = odk_schema_data,
#'                       url = "https://odk.xyz.io/#/projects/project-name/submissions")
#' }
#'
create_free_text_log <-
  function(response_data, form_schema, url, type_to_keep = "text") {

    # get items from schema that are free text.
    other_q <- form_schema |>
      dplyr::select(name, type,choices) |>
      dplyr::filter(
        stringr::str_detect(type,type_to_keep)
      ) |>
      dplyr::pull(name) |>
      unique()

    # get free text responses
    other_responses <- response_data |>
      dplyr::select(id, tidyselect::contains(other_q)) |>
      tidyr::pivot_longer(-id) |>
      dplyr::filter(!is.na(value)) |>
      # add language to comments
      dplyr::mutate(comments = purrr::map_chr(value, detect_language))

    # make complete log
    free_text_log <- other_responses |>
      dplyr::mutate(
        no_change = "",
        new_val = "",
        user_initials = "",
        issue = "Free-text detected. Review and translate if required.",
        odk_url = paste(
          url,
          stringr::str_replace(id, pattern = ":", replacement = "%3A"),
          sep = "/"
        ),
        overwrite_old_value = "FALSE"
      ) |>
      dplyr::left_join(
        dplyr::select(form_schema, name, question = "label_english_(en)") ,
        by = c("name" = "name")
      ) |>
      dplyr::select(
        entry = id,
        field = name,
        question,
        issue,
        old_value = value,
        no_change,
        new_val,
        overwrite_old_value,
        user_initials,
        odk_url,
        comments
      )

    return(free_text_log)

  }



#' Create Translation Log
#'
#' `r lifecycle::badge("deprecated")` Collates free text responses from 'other' and 'notes' fields in the survey
#' data. Some language detection is performed and placed in the log notes section
#' for possible translation.
#'
#' @param response_data data.frame of ODK questionnaire responses
#' @param form_schema data.frame or flattened ODK form schema
#' @param url The ODK submission URL excluding the uuid identifier
#'
#' @export
#'
#' @return data.frame validation log
#'
#' @examples
#' \dontrun{
#' create_translation_log(response_data = semi_clean_data,
#'                        form_schema = odk_schema_data,
#'                        url = "https://odk.xyz.io/#/projects/project-name/submissions"))
#' }
#'
create_translation_log <-
  function(response_data, form_schema, url) {

    # get items from schema that are free text.
    other_q <- form_schema |>
      dplyr::select(name, type, labels = `label_english_(en)`, choices = `choices_english_(en)`) |>
      dplyr::filter(
        stringr::str_detect(labels, "other|Other|note|Note"),
        choices == "NA",
        type == "string"
      ) |>
      dplyr::pull(name) |>
      unique()

    # get free text responses
    other_responses <- response_data |>
      dplyr::select(id, tidyselect::contains(other_q)) |>
      tidyr::pivot_longer(-id) |>
      dplyr::filter(!is.na(value)) |>
      # add language to comments
      dplyr::mutate(comments = purrr::map_chr(value, detect_language))

    # make complete log
    trans_log <- other_responses |>
      dplyr::mutate(
        no_change = "",
        new_val = "",
        user_initials = "",
        issue = "Free-text detected. Review and translate if required.",
        odk_url = paste(
          url,
          stringr::str_replace(id, pattern = ":", replacement = "%3A"),
          sep = "/"
        ),
        overwrite_old_value = "FALSE"
      ) |>
      dplyr::left_join(
        dplyr::select(form_schema, name, question = "label_english_(en)") ,
        by = c("name" = "name")
      ) |>
      dplyr::select(
        entry = id,
        field = name,
        question,
        issue,
        old_value = value,
        no_change,
        new_val,
        overwrite_old_value,
        user_initials,
        odk_url,
        comments
      )

    return(trans_log)

  }
