#########
#Rscript to test identify_test_3 errors
#########


source("./R/identify_test_3_errors.R")
library(dplyr)
t3_original_dat   <- read.csv("./inst/find_test_3_errors_orig_dat.csv")
t3_validation_log <- read.csv("./inst/find_test_3_errors_val_log.csv")
t3_semiclean_dat  <- read.csv("./inst/find_test_3_errors_clean_dat.csv")

# validation checks fail

  test3_validation_checks_dat <- ohcleandat::validation_checks(validation_log = t3_validation_log,
                                before_data = t3_original_dat,
                                after_data = t3_semiclean_dat,
                                primary_key = "unique_id")


#Run check_test_3 functions to identify issues and correct them in the respective validation log

  check_test_3 <- test_3_show_mismatch(validation_log = t3_validation_log,
                                       before_data = t3_original_dat,
                                       after_data = t3_semiclean_dat,
                                       primary_key  = "unique_id")


