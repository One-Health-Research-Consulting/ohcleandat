devtools::load_all()
library(validate)

before_data <- readr::read_csv("inst/test_validation_log_data.csv")


# create_rules_from_template(name = "dummy_rules",dir = "inst")
make_dummy_rules <- function(){
  ## each rule should be named after the column its validating
  rule1 <- validator(
    animal_id = grepl(pattern = "[A-Z]{3}-\\d{3}",x = animal_id)
  )
  ## make sure descriptions are concise and interpretable
  description(rule1) <- rep("Results: animal_id (ID Number) improperly formatted",length(rule1))

  out <- list(
    rule1 = rule1
  )

  return(out)
}


dummy_rules <- make_dummy_rules()

val_log <- purrr::map_df(dummy_rules, ~create_validation_log(data = before_data, primary_key = "primary_key",rule_set = .x))

val_log_combined <- combine_logs(existing_log = NULL,new_log = val_log)

readr::write_csv(val_log_combined, "inst/test_two_issues_same_entry_log.csv")

### correct log manually

val_log_corrected <- readr::read_csv(file = "inst/test_two_issues_same_entry_log_corrected.csv",
                                     col_types = "iiccccccccc",
                                     na = character() )

val_log_ordered <- val_log_corrected |>
  dplyr::arrange(rowid) |>
  dplyr::select(-log_response_id)

# correct data

data_semiclean <- correct_data(validation_log = val_log_ordered,data = before_data,primary_key = "primary_key")

# validate cleaning checks

validation_checks(validation_log = val_log_ordered,after_data = data_semiclean,before_data = before_data,primary_key = "primary_key")

