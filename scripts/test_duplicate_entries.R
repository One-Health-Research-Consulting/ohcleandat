devtools::load_all()
library(validate)

before_data <- readr::read_csv("inst/test_two_issues_one_entry_data.csv")


# create_rules_from_template(name = "dummy_rules",dir = "inst")
make_dummy_rules <- function(){
  ## each rule should be named after the column its validating
  rule1 <- validator(
    animal_id = grepl(pattern = "[A-Z]{3}-\\d{3}",x = animal_id)
  )
  ## make sure descriptions are concise and interpretable
  description(rule1) <- rep("Results: animal_id (ID Number) improperly formatted",length(rule1))

  rule2 <- validator(
    animal_id = nchar(animal_id) == 7
  )

  description(rule2) <- rep("Results: animal_id (ID Number) should be 7 characters long",length(rule1))


  out <- list(
    rule1 = rule1,
    rule2 = rule2
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
