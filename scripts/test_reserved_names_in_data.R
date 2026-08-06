devtools::load_all()
library(validate)

# data input
before_data <- readr::read_csv("inst/test_reserved_field_names.csv")


# create_rules_from_template(name = "dummy_rules",dir = "inst")
make_dummy_rules <- function(){
  ## each rule should be named after the column its validating
  rule1 <- validator(
    animal_id = grepl(pattern = "[a-z]{3}-\\d{3}",x = animal_id)
  )
  ## make sure descriptions are concise and interpretable
  description(rule1) <- rep("Results: animal_id (ID Number) improperly formatted",length(rule1))

  # comments
  rule2 <- validator(
    comments = nchar(comments) == 7
  )

  description(rule2) <- rep("Results: comment should be 7 characters long",length(rule2))


 # user initials
  rule3 <- validator(
    user_initials = user_initials == "cjs"
  )

  description(rule3) <- rep("Results: user_initials should be cjs",length(rule3))

  # new_val
  rule4 <- validator(
    new_val = new_val == "blah"
  )

  description(rule4) <- rep("Results: new_val should be blah",length(rule4))

  # no_change
  rule5 <- validator(
    no_change = no_change == TRUE
  )

  description(rule5) <- rep("Results: no_change should be logical",length(rule5))

  # old_value
  rule6 <- validator(
    old_value = old_value == 1
  )

  description(rule6) <- rep("Results: old_value should be numeric",length(rule6))

  # issue
  rule7 <- validator(
    issue = issue == "no problem"
  )

  description(rule7) <- rep("Results: issue should be no problem",length(rule7))

  # field
  rule8 <- validator(
    field = field == "prado"
  )

  description(rule8) <- rep("Results: field should be prado",length(rule8))

  # entry
  rule9 <- validator(
    entry = entry == "door"
  )

  description(rule9) <- rep("Results: entry should be door",length(rule9))


  out <- list(
    rule1 = rule1,
    rule2 = rule2,
    rule3 = rule3,
    rule4 = rule4,
    rule5 = rule5,
    rule6 = rule6,
    rule7 = rule7,
    rule8 = rule8,
    rule9 = rule9
  )

  return(out)
}


dummy_rules <- make_dummy_rules()

# debugonce(create_validation_log)

val_log <- purrr::map_df(dummy_rules,
                         ~create_validation_log(data = before_data,
                                                primary_key = "primary_key",
                                                rule_set = .x))

# add a column with reserved field prefix

bf_data_2 <- before_data %>%
  dplyr::mutate(reserved_ohcleandat_ = "why?")

val_log <- purrr::map_df(dummy_rules,
                         ~create_validation_log(data = bf_data_2,
                                                primary_key = "primary_key",
                                                rule_set = .x))




