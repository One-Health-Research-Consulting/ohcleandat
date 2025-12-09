#' Look-up table for 'Other' questions
#'
#' @description
#' Provides a look up table matching ODK survey questions with their free text
#' response question.
#'
#' @details
#' In many ODK surveys, a multiple choice question can have a response for 'other'
#' where the respondent can add free text as a response. There is no consistent
#' link in the response data to match the captured responses and the other free-text
#' collected. This function provides a manual look up reference so free text responses
#' can be compared to the original questions in the validation workflow.
#'
#' This function can be expanded by providing a tibble with two columns: `name` and
#' `other_name` which maps the question name in ODK to the question name containing
#' 'other' or 'free text'.
#'
#' @param questionnaire The ODK questionnaire. Used to ensure the correct look up table is found.
#'
#' @return tibble
#' @export
#' @examples
#' othertext_lookup(questionnaire = c("animal_owner"))
#'
#'
othertext_lookup <- function(questionnaire = c("animal_owner")){

  if(questionnaire == "animal_owner"){

    lookup <- tibble::tribble(
      ~name,                            ~other_name,
      "f2_species_own",                  "f2a_species_own_oexp",
      "f6e_rvf_vax_type",                "f6e_rvf_vax_type_oexp",
      "f6a_protocol",                    "f6a_protocol_other",
      "f6b_which_vax",                   "f6c_ani_vax_num_oexp",
      "f6i_rvf_vax_chalenge_mult",       "f6i_rvf_vax_chalenge_oexp",
      "f7b_abortion_3_which",            "f7b_abortion_3_which_oexp",
      "f7d_abortion_12_which",           "f7d_abortion_12_which_oexp",
      "f7f_abortus_dispose",             "f7f_abortus_dispose_oexp",
      "f8_ani_contact",                  "f8_ani_contact_oexp",
      "f8c_contact_other_sp",            "f8c_contact_other_sp_oexp",
      "f9f_ani_contact_wildlife",        "f9_ani_contact_oexp",
      "f9a_kraal_c",                     "f9a_kraal_oexp_c",
      "f9b_kraal_sh",                    "f9b_kraal_oexp_sh",
      "f9c_kraal_g",                     "f9c_kraal_oexp_g",
      "f9d_kraal_o",                     "f9d_kraal_oexp_o",
      "f14_new_ani",                     "f14_new_ani_oexp",
      "f14b_inj_type",                   "f14b_inj_type_oexp",
      "f16_animal_purpose",              "f16_animal_purpose_oexp",
      "f17a_slaughter_loc",              "f17a_slaughter_loc_oexp",
      "f18a_fencing_type",               "f18_fencing_type_oexp",
      "f19_sick_ani_self_treat",         "f19_sick_ani_self_treat_oexp"
    )
  }

  return(lookup)

}


#' Create other text lookup from ODK excel template
#'
#' @param file_path String. Path to excel template file
#'
#' @returns tibble. Tibble with fields name and other name
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' \dontrun{
#' othertext_lookup_from_odk_excel(file_path = "my/odk_template.xlsx")
#' }
#'
othertext_lookup_from_odk_excel <- function(file_path){
  xl_schema <- readxl::read_excel(file_path, sheet = "survey")

  out <- xl_schema |>
    dplyr::select(.data$name,.data$type, .data$relevant) |>
    dplyr::filter(stringr::str_detect(string = type,pattern = "text")) |>
    dplyr::filter(!is.na(.data$relevant)) |>
    dplyr::rename("other_name" = "name") |>
    dplyr::mutate( name = stringr::str_extract(.data$relevant,pattern = "selected\\(\\$\\{\\w*\\}")) |>
    dplyr::mutate( name = stringr::str_replace_all(name, pattern = "selected\\(\\$\\{|\\}",replacement = "")) |>
    dplyr::filter(!is.na(name)) |>
    dplyr::select(name,other_name) |>
    tibble::as_tibble()

  return(out)
}


