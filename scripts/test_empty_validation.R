library(validate)

dummy_survey <- read.csv("inst/test_val_log_data_empty_string.csv")


# create_rules_from_template(name = "dummy_rules",dir = "inst")
make_dummy_rules <- function(){
  ## each rule should be named after the column its validating
  rule1 <- validator(
    animals_on_farm = !(animals_on_farm %in%"other")
  )
  ## make sure descriptions are concise and interpretable
  description(rule1) <- rep("Animals on farm is other",length(rule1))

  rule2 <- validator(
    other_response =  nchar(other_response,allowNA = TRUE,keepNA = FALSE) == 0
  )

  description(rule2) <- rep("other_response has characters",length(rule2))

  out <- list(
    rule1 = rule1,
    rule2 = rule2
  )

  return(out)
}


dummy_rules <- make_dummy_rules()

val_log <- purrr::map_df(dummy_rules, ~create_validation_log(dummy_survey, primary_key = "primary_key",rule_set = .x))

val_log_combined <- combine_logs(existing_log = NULL,new_log = val_log)

readr::write_csv(val_log_combined, "inst/empty_string_log.csv")

### make corrections in log, save

val_log_corrected <-         readr::read_csv("inst/empty_string_log.csv",
                                             col_types = "iiccccccccc",
                                             na = character())

val_log_ordered <- val_log_corrected |>
  dplyr::arrange(rowid) |>
  dplyr::select(-log_response_id, -rowid)

# correct data

dummy_survey_semiclean <- correct_data(validation_log = val_log_ordered,data = dummy_survey,primary_key = "primary_key")

# validate cleaning checks

validation_checks(validation_log = val_log_ordered,after_data = dummy_survey_semiclean,before_data = dummy_survey,primary_key = "primary_key")



##### EXPECT FAILURE --- accidentally delte old value in other response

library(validate)

dummy_survey <- read.csv("inst/test_val_log_data_empty_string.csv")


# create_rules_from_template(name = "dummy_rules",dir = "inst")
make_dummy_rules <- function(){
  ## each rule should be named after the column its validating
  rule1 <- validator(
    animals_on_farm = !(animals_on_farm %in%"other")
  )
  ## make sure descriptions are concise and interpretable
  description(rule1) <- rep("Animals on farm is other",length(rule1))

  rule2 <- validator(
    other_response =  nchar(other_response,allowNA = TRUE,keepNA = FALSE) == 0
  )

  description(rule2) <- rep("other_response has characters",length(rule2))

  out <- list(
    rule1 = rule1,
    rule2 = rule2
  )

  return(out)
}


dummy_rules <- make_dummy_rules()

val_log <- purrr::map_df(dummy_rules, ~create_validation_log(dummy_survey, primary_key = "primary_key",rule_set = .x))

val_log_combined <- combine_logs(existing_log = NULL,new_log = val_log)

readr::write_csv(val_log_combined, "inst/empty_string_log_accidental_delete_other.csv")

### make corrections in log, save

val_log_corrected <-         readr::read_csv("inst/empty_string_log_accidental_delete_other.csv",
                                             col_types = "iiccccccccc",
                                             na = character())

val_log_ordered <- val_log_corrected |>
  dplyr::arrange(rowid) |>
  dplyr::select(-log_response_id, -rowid)

# correct data

dummy_survey_semiclean <- correct_data(validation_log = val_log_ordered,data = dummy_survey,primary_key = "primary_key")

# validate cleaning checks

validation_checks(validation_log = val_log_ordered,after_data = dummy_survey_semiclean,before_data = dummy_survey,primary_key = "primary_key")



##### EXPECT FAILURE --- accidentally delte old value in other response

library(validate)

dummy_survey <- read.csv("inst/test_val_log_data_empty_string.csv")


# create_rules_from_template(name = "dummy_rules",dir = "inst")
make_dummy_rules <- function(){
  ## each rule should be named after the column its validating
  rule1 <- validator(
    animals_on_farm = !(animals_on_farm %in%"other")
  )
  ## make sure descriptions are concise and interpretable
  description(rule1) <- rep("Animals on farm is other",length(rule1))

  rule2 <- validator(
    other_response =  nchar(other_response,allowNA = TRUE,keepNA = FALSE) == 0
  )

  description(rule2) <- rep("other_response has characters",length(rule2))

  out <- list(
    rule1 = rule1,
    rule2 = rule2
  )

  return(out)
}


dummy_rules <- make_dummy_rules()

val_log <- purrr::map_df(dummy_rules, ~create_validation_log(dummy_survey, primary_key = "primary_key",rule_set = .x))

val_log_combined <- combine_logs(existing_log = NULL,new_log = val_log)

readr::write_csv(val_log_combined, "inst/empty_string_log_accidental_delete_other.csv")

### make corrections in log, save

val_log_corrected <-         readr::read_csv("inst/empty_string_log_accidental_delete_other.csv",
                                             col_types = "iiccccccccc",
                                             na = character())

val_log_ordered <- val_log_corrected |>
  dplyr::arrange(rowid) |>
  dplyr::select(-log_response_id, -rowid)

# correct data

dummy_survey_semiclean <- correct_data(validation_log = val_log_ordered,data = dummy_survey,primary_key = "primary_key")

# validate cleaning checks

validation_checks(validation_log = val_log_ordered,after_data = dummy_survey_semiclean,before_data = dummy_survey,primary_key = "primary_key")



