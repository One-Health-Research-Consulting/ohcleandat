#########
#Rscript to test identify_test_3 errors
#########


source("./R/identify_test_3_errors.R")
library(dplyr)
t3_original_dat <- read.csv("./inst/find_test_3_errors_orig_dat.csv")
t3_validation_log <- read.csv("./inst/find_test_3_errors_val_log.csv")
t3_semiclean_dat <- read.csv("./inst/find_test_3_errors_clean_dat.csv")

# validation cleaning checks

  test3_cleaning_checks <- ohcleandat::validation_checks(validation_log = t3_validation_log,
                                before_data = t3_original_dat,
                                after_data = t3_semiclean_dat,
                                primary_key = "unique_id")

  test3_2_cleaning_checks <- ohcleandat::validation_checks(validation_log = t3_2_val_log,
                                                        before_data = t3_original_dat,
                                                        after_data = t3_semiclean_dat,
                                                        primary_key = "unique_id")




  check_test_3 <- test_3_show_mismatch(validation_log = t3_validation_log,
                                     before_data = t3_original_dat,
                                     after_data = t3_semiclean_dat,
                                     primary_key  = "unique_id")


double_check_test_3 <- test_3_check_2(validation_log = t3_2_val_log,
                                      before_data = t3_original_dat,
                                      after_data = t3_semiclean_dat,
                                      primary_key  = "unique_id")

#Code to remake dataframes:
#t3_original_dat <- data.frame(unique_id = seq(1,10,1),
#                              location_id = paste("HH", seq(200, 209, 1), sep = "_"),
#                              date = c(as.Date("2023-03-01"), as.Date("2023-03-02"), as.Date("2023-03-03"), as.Date("2023-03-04"), as.Date("2023-03-05"),
#                                       as.Date("2023-03-06"), as.Date("2023-03-07"), as.Date("2023-03-08"), as.Date("2023-03-09"), as.Date("2023-10-03")),
#                              sampled = c("Yes", "Yes", "No", "Yes", "No", "No", "Yes", "Yes", "No", "No"),
#                              trap_type = c(rep("Tomahawk", 3), rep("Shannon", 3), rep("Pit", 2), rep("NA", 2)),
#                              species = c("no capture", "opposum", "racoon", "no capture", "NA", "squirrel", "white-footed mouse", "field mouse", "NA", "NA"),
#                              ticks_collected = c("NA", "Yes", "Yes", "NA", "NA", "No", "Yes", "Yes", "NA", "NA"),
#                              number_ticks = c(NA, 500, 2, NA, NA, 0, 15, 35, NA, NA),
#                              temperature = c(35, 35, 26, 28, NA, 31, NA, 27, 55, NA),
#                              collector = c("UK", "UK", "UK", "GG", "BB", "UK", "NA", "GG", "UK", "GG")
#)
#
#t3_validation_log <- data.frame(rowid = seq(1,9,1),
#                                entry = c( 1, 1, 6, 7, 9, 10, 3, 2, 4),
#                                field = c("sampled", "temperature","trap_type", "temperature",  "temperature", "date", "sampled", "number_ticks", "location_id"),
#                                issue = c("No sampling data for a day that was sampled","Data shouldn't be recorded when there was no sampling", "Incorrect trap type", "NA when data was collected that day",  "Data shouldn't be recorded when there was no sampling", "Date outside of sampling timeframe", "Sampling occurred but sampled is no", "Tick number seems high, double check", ""),
#                                old_value = c( "Yes", "35",  "Shannon", "", "55", "2023-10-03", "No", "500", "HH210"),
#                                no_change = c("FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE"),
#                                new_val = c( "No", "", "Pit", "22", "", "2023-03-10", "No", "5", "HH_203"),
#                                user_initials = sample(c("TY", "BY"), 9, replace = TRUE),
#                                comments = c( "Check 1", "Check 2", "Check 3", "Check 4", "Check 5", "Check 5", "Check 6", "Check 7", "Check test3_2")
#)%>%
#  mutate(log_response_id = entry)%>%
#  select(rowid,	log_response_id,	entry,	field,	issue,	old_value,	no_change,	new_val,	user_initials,	comments)
#
#
#t3_semiclean_dat <- data.frame(unique_id = seq(1,10,1),
#                               location_id = paste("HH", seq(200, 209, 1), sep = "_"),
#                               date = c(as.Date("2023-03-01"), as.Date("2023-03-02"), as.Date("2023-03-03"), as.Date("2023-03-04"), as.Date("2023-03-05"),
#                                        as.Date("2023-03-06"), as.Date("2023-03-07"), as.Date("2023-03-08"), as.Date("2023-03-09"), as.Date("2023-03-10")),
#                               sampled = c("No", "Yes", "No", "Yes", "No", "No", "Yes", "Yes", "No", "No"),
#                               trap_type = c(rep("Tomahawk", 3), rep("Shannon", 2), "NA", rep("Pit", 2), rep("NA", 2)),
#                               species = c("no capture", "opposum", "racoon", "no capture", "NA", "squirrel", "white-footed mouse", "field mouse", "NA", "NA"),
#                               ticks_collected = c("NA", "Yes", "Yes", "NA", "NA", "No", "Yes", "Yes", "NA", "NA"),
#                               number_ticks = c(NA, 50, 2, NA, NA, 0, 15, 35, NA, NA),
#                               temperature = c(35, 35, 26, 28, NA, 31, 22, 27, NA, NA),
#                               collector = c("UK", "UK", "UK", "GG", "BB", "UK", "NA", "GG", "UK", "GG")
#)
#
#t3_2_val_log <- t3_validation_log[9,]
#
#write.csv(t3_original_dat,   "./inst/find_test_3_errors_orig_dat.csv",  row.names = FALSE)
#write.csv(t3_validation_log, "./inst/find_test_3_errors_val_log.csv",   row.names = FALSE)
#write.csv(t3_semiclean_dat,  "./inst/find_test_3_errors_clean_dat.csv", row.names = FALSE)
#
