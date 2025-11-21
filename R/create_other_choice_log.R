#' Create Other Choice Log
#'
#' Creates custom validation log for 'other: explain' free text responses that may contain valid
#' multi-choice options.
#'
#' @param response_data data.frame ODK questionnaire response data
#' @param form_schema data.frame ODK flattened form schema data
#' @param url The ODK submission URL excluding the uuid identifier
#' @param lookup a tibble formatted as a lookup to match questions with their free text responses. The format must match
#' the output of `othertext_lookup()`. This function can be passed to this function argument as a convenient handler for this value.
#'
#' @return data.frame validation log
#' @details
#' This function needs to link a survey question with its corresponding free text response. Users can use the
#' `othertext_lookup()` function to handle this, or provide their own tibble in the same format. See below:
#'  tibble::tribble(
#'  ~name, ~other_name,
#'  question_1, question_1_other
#'  )
#' @export
#' @seealso [ohcleandat::othertext_lookup()]
#' @examples
#' \dontrun{
#' # Using othertext_lookup helper
#' test_a <- other_choice_log(response_data = animal_owner_semiclean,
#'                               form_schema = animal_owner_schema,
#'                               url = "https://odk.xyz.io/#/projects/5/forms/project/submissions",
#'                               lookup = ohcleandat::othertext_lookup(questionnaire = "animal_owner")
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
#'                                 lookup = mylookup
#'                                 )
#' }
#'
other_choice_log <- function(response_data, form_schema, url, lookup){

  # identify questions with some free text response
  other_q <- form_schema |>
    dplyr::select(name, type, labels = `label_english_(en)`, choices = `choices_english_(en)`) |>
    dplyr::filter(stringr::str_detect(labels, "other|Other|note|Note"),
           choices == "NA",
           type == "string") |>
    dplyr::pull(name) |>
    unique()

  # identidy responses to the questions with free text responses
  other_responses <- response_data |>
    dplyr::select(id, tidyselect::contains(other_q)) |>
    tidyr::pivot_longer(-id) |>
    dplyr::filter(!is.na(value))

  # Identify questions with multi-response options
  multi <- form_schema |>
    dplyr::select(name, type, labels = `label_english_(en)`, choices = `choices_english_(en)`) |>
    dplyr::filter(choices != "NA" & choices != "NULL")

  # explode label options
  multi_other_lst <- rlang::set_names(multi$choices, multi$name)
  multi_options <- purrr::map_dfr(multi_other_lst, dplyr::bind_rows, .id = "name")

  # Read in pre-defined lookup of free text responses and the base multi-option question.
  # Join these with actual responses to form a validation log
  freetext_log <- lookup |>
    dplyr::inner_join(multi_options, by = dplyr::join_by(name)) |>
    dplyr::inner_join(other_responses, by = dplyr::join_by(other_name == name)) |>
    dplyr::mutate(issue = "Is the free-text answer valid? Indicate IsValid = F to overwrite with the correct multiple choice response",
           no_change = "",
           user_initials = "",
           odk_url = paste(url, stringr::str_replace(id, pattern = ":", replacement = "%3A"), sep = "/"),
           overwrite_old_value = "FALSE",
           comments = ifelse(stringr::str_detect(string = tolower(value), pattern = tolower(values)), "Text contains a valid multiple choice option.", "")) |>
    dplyr::left_join(
      dplyr::select(form_schema, name, question = "label_english_(en)") , by = c("name" = "name")
    ) |>
    dplyr::select(entry = id,
           field = name,
           question,
           issue,
           old_value = value,
           no_change,
           new_val = values,
           overwrite_old_value,
           user_initials,
           odk_url,
           comments) |>
    dplyr::arrange(entry, field)

  return(freetext_log)

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
  lifecycle::deprecate_warn(when = "1.1.6",what = "create_freetext_log()",with = "other_choice_log()")

    other_choice_log(...)
}
