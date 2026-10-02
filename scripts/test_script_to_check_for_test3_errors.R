#########
#Rscript to test identify_test_3 errors
#########


source("./R/identify_test_3_errors.R")
library(dplyr)
t3_original_dat   <- read.csv("./inst/find_test_3_errors_orig_dat.csv")
t3_validation_log <- read.csv("./inst/find_test_3_errors_val_log.csv")
t3_semiclean_dat  <- read.csv("./inst/find_test_3_errors_clean_dat.csv")
t3_2_val_log      <-read.csv("./inst/find_test_3_2_errors_val_log.csv")

# validation checks fail

  test3_validation_checks_dat <- ohcleandat::validation_checks(validation_log = t3_validation_log,
                                before_data = t3_original_dat,
                                after_data = t3_semiclean_dat,
                                primary_key = "unique_id")

  test3_2_validation_checks_dat <- ohcleandat::validation_checks(validation_log = t3_2_val_log,
                                                        before_data = t3_original_dat,
                                                        after_data = t3_semiclean_dat,
                                                        primary_key = "unique_id")


#Run check_test_3 functions

  check_test_3 <- test_3_show_mismatch(validation_log = t3_validation_log,
                                       before_data = t3_original_dat,
                                       after_data = t3_semiclean_dat,
                                       primary_key  = "unique_id")


double_check_test_3 <- test_3_arsenal_check(validation_log = t3_2_val_log,
                                            before_data = t3_original_dat,
                                            after_data = t3_semiclean_dat,
                                            primary_key  = "unique_id")

