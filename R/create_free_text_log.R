#' Create Free Text Log
#'
#'  Collates free text responses from text fields in the survey
#' data. Some language detection is performed and placed in the log notes section
#' for possible translation.
#'
#' Since this a "type" based validation, we must provide the existing log to
#' prevent the perptual addition of entries. Unlike other logs, this log
#' looks for specific types of data in the schema. If they are found,
#' a new record is created. Even if a record is marked validated, its type will
#' not change and so we must ensure the record is only added to the log if it is
#' unvalidated in the current log.
#'
#' @param response_data data.frame of ODK questionnaire responses
#' @param form_schema data.frame or flattened ODK form schema
#' @param url The ODK submission URL excluding the uuid identifier
#' @param type_to_keep String. Regex pattern passed to `stringr::str_detect`.
#' @param existing_log data.frame Existing log used to create semi-clean data.
#' Used to prevent double entry of items.
#' @param columns_to_exclude Character. Character vector of columns to exclude from the log.
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
#'                       url = "https://odk.xyz.io/#/projects/project-name/submissions",
#'                       existing_log = existing_log)
#'
#' # exclude certain columns from the free text log
#' create_free_text_log(response_data = semi_clean_data,
#'                       form_schema = odk_schema_data,
#'                       url = "https://odk.xyz.io/#/projects/project-name/submissions",
#'                       existing_log = existing_log,
#'                       columns_to_exclude = c("household_id", "human_id")
#'                       )
#' }
#'
create_free_text_log <-
  function(response_data, form_schema, url, type_to_keep = "text", existing_log, columns_to_exclude = NULL) {

    # get items from schema that are free text.
    other_q <- form_schema |>
      dplyr::select(name, type,choices) |>
      dplyr::filter(
        stringr::str_detect(type,type_to_keep)
      ) |>
      dplyr::pull(name) |>
      unique()

    # exclude certain columns
    if(is.character(columns_to_exclude)){

      # warn user if a column to be excluded is not in the schema as free text
      if(!all(columns_to_exclude %in% other_q)){
        rlang::warn("Not all values in columns_to_exclude are stored as free text in the schema. Check spelling and column type.")
      }

      exclude_these <- other_q %in% columns_to_exclude
      other_q <- other_q[!exclude_these]
    }

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

    # get un-validated records --- this function includes issue in its
    # join so we don't need it here.
    unvalidated_entries <- drop_validated_entries(existing_log, free_text_log) |>
      dplyr::select(entry, field)

    ## keep only unvalidated items in log

    free_text_log_out<- dplyr::inner_join(free_text_log, unvalidated_entries, by = c("entry","field"))

    return(free_text_log_out)

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

    lifecycle::deprecate_stop(when = "1.1.6",
                              what = "create_translation_log()",
                              with = "create_free_text_log()")
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
