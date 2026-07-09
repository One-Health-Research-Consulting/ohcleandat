#' Create Other Choice Log
#'
#' Creates custom validation log for 'other: explain' free text responses that may contain valid
#' multi-choice options.
#'
#' create_other_choice_log creates log entries for a special case of free text
#' fields. These are the entries that coincide with select_multiple questions
#' that have an other option which leads to a free text entry (e.g. what animals do you own? cattle, goat, sheep,
#' other --> other explain: "free text response here").
#'
#' Because these log entries are based on data type, and not data value, we need
#' to provide additional inputs to keep them from being entered twice into the log.
#' By providing the existing_log, we can look for validated entries in the existing log
#' and only add items that have been validated.
#'
#' Unlike other logs, responses are only ever added one time.
#' So even if the free text associated with the multiple select question changes,
#' the multiple select options will not be added again.
#'
#'
#' @param response_data data.frame ODK questionnaire response data
#' @param form_schema data.frame ODK flattened form schema data
#' @param url The ODK submission URL excluding the uuid identifier
#' @param lookup a tibble formatted as a lookup to match questions with their free text responses. The format must match
#' the output of `othertext_lookup()`. This function can be passed to this function argument as a convenient handler for this value.
#' @param existing_log data.frame Existing log for this data set. Should be the same
#' log that was used to create the semi-clean data.
#'
#' @return data.frame validation log
#' @importFrom rlang .data
#' @details
#' This function needs to link a survey question with its corresponding free text response. Users can use the
#' `othertext_lookup()` function to handle this, or provide their own tibble in the same format. See below:
#'  tibble::tribble(
#'  ~name, ~other_name,
#'  question_1, question_1_other
#'  )
#' @export
#' @seealso [ohcleandat::othertext_lookup()] [ohcleandat::keep_validated_entries()]
#' @examples
#' \dontrun{
#' # Using othertext_lookup helper
#' test_a <- other_choice_log(response_data = animal_owner_semiclean,
#'                               form_schema = animal_owner_schema,
#'                               url = "https://odk.xyz.io/#/projects/5/forms/project/submissions",
#'                               lookup = ohcleandat::othertext_lookup(questionnaire = "animal_owner"),
#'                               existing_log
#'                               )
#'
#' # using custom lookup table
#' mylookup <- tibble::tribble(
#'   ~name, ~other_name,
#'   "f2_species_own", "f2a_species_own_oexp"
#'   )
#'
#'   test_b <- other_choice_log(response_data = animal_owner_semiclean,
#'                                 form_schema = animal_owner_schema,
#'                                 url = "https://odk.xyz.io/#/projects/5/forms/project/submissions",
#'                                 lookup = mylookup,
#'                                 existing_log
#'                                 )
#'
#' # using odk excel schema
#' xlsx_lookup  <- othertext_lookup_from_odk_excel(file_path = "animal_owner_schema.xlsx")
#'
#' test_c <- other_choice_log(response_data = animal_owner_semiclean,
#'                                 form_schema = animal_owner_schema,
#'                                 url = "https://odk.xyz.io/#/projects/5/forms/project/submissions",
#'                                 lookup = xlsx_lookup
#'                                 )
#'
#' }
#'
create_other_choice_log <- function(response_data, form_schema, url, lookup,
                                     existing_log){

  if(is.null(x = existing_log)){
    return(NULL)
  }

  # identify questions with some free text response
  # other_q <- form_schema |>
  #   dplyr::select(name, type, labels = `label_english_(en)`, choices = `choices_english_(en)`) |>
  #   dplyr::filter(stringr::str_detect(labels, "other|Other|note|Note"),
  #          choices == "NA",
  #          type == "string") |>
  #   dplyr::pull(name) |>
  #   unique()
  other_q <- lookup |>
    dplyr::pull(other_name)

  # identify responses to the questions with free text responses
  other_responses <- response_data |>
    dplyr::select(id, tidyselect::contains(other_q)) |>
    tidyr::pivot_longer(-id) |>
    dplyr::filter(!is.na(value))

  # Identify questions with multi-response options
  ### should we just join with the lookup table?
  multi <- form_schema |>
    dplyr::select(name, type, labels = `label_english_(en)`, choices = `choices_english_(en)`) |>
    dplyr::filter(choices != "NA" & choices != "NULL")

  # explode label options
  multi_other_lst <- rlang::set_names(multi$choices, multi$name)
  multi_options <- purrr::map_dfr(multi_other_lst, dplyr::bind_rows, .id = "name")

  # Read in pre-defined lookup of free text responses and the base multi-option question.
  # Join these with actual responses to form a validation log
  other_choice_log <- lookup |>
    dplyr::inner_join(multi_options, by = dplyr::join_by(name)) |>
    dplyr::inner_join(other_responses, by = dplyr::join_by(other_name == name)) |>
    dplyr::mutate(issue = "Is the free-text answer valid? Indicate no_change = F to overwrite with the correct multiple choice response",
                  no_change = "",
                  user_initials = "",
                  odk_url = paste(url, stringr::str_replace(id, pattern = ":", replacement = "%3A"), sep = "/"),
                  overwrite_old_value = "FALSE",
                  comments = ifelse(stringr::str_detect(string = tolower(.data$value.y), pattern = tolower(.data$value.x)), "Text contains a valid multiple choice option.", "")) |>
    dplyr::left_join(
      dplyr::select(form_schema, name, question = "label_english_(en)") , by = c("name" = "name")
    ) |>
    dplyr::select(entry = id,
                  field = name,
                  question,
                  issue,
                  old_value = .data$value.y,
                  no_change,
                  new_val = .data$value.x,
                  overwrite_old_value,
                  user_initials,
                  odk_url,
                  comments) |>
    dplyr::arrange(entry, field)


  # keep only  items that have been validated in free text
  ## existing_log filtered to lookup$other_name
  ## filter to validated entries
  ## keep entry and field


  validated_existing_log <- keep_validated_entries(existing_log = existing_log,
                                                new_log = NULL) |>
    dplyr::select(entry,field)

  validated_free_text <- dplyr::inner_join(validated_existing_log, lookup, by = c("field" = "other_name")) |>
    dplyr::select(-field) |>
    dplyr::rename("field" = "name")

  # other choice items with associated validated free text (vft)
  other_choice_log_vft <- dplyr::inner_join(other_choice_log,validated_free_text, by = c("entry","field"))

  # drop any items other choice items already in the log ---
  other_choice_log_out <- dplyr::anti_join(other_choice_log_vft,existing_log,
                                           by = c("entry","field"))


  return(other_choice_log_out)

}

#' create other choice log
#'
#' use `other_choice_log()`
#'
#' `r lifecycle::badge('deprecated')`
#'
#' @param ... arguments passed to other_choice_log
#' @export
create_freetext_log <- function(...){
  lifecycle::deprecate_stop(when = "1.1.6",what = "create_freetext_log()",with = "create_other_choice_log()")
}
