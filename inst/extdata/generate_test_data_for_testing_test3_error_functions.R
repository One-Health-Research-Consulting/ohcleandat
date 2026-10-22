#Code to make dataframes for testing the identify_test_3_errors functions (test_3_show_mismatch and test_3_check_2):
t3_original_dat <- data.frame(unique_id = seq(1,10,1),
                              location_id = paste("HH", seq(200, 209, 1), sep = "_"),
                              date = c(as.Date("2023-03-01"), as.Date("2023-03-02"), as.Date("2023-03-03"), as.Date("2023-03-04"), as.Date("2023-03-05"),
                                       as.Date("2023-03-06"), as.Date("2023-03-07"), as.Date("2023-03-08"), as.Date("2023-03-09"), as.Date("2023-10-03")),
                              sampled = c("No", "", "No", "Yes", "No", "Yes", "Yes", "Yes", "Yes", "No"),
                              trap_type = c(rep("Tomahawk", 3), rep("Shannon", 3), rep("Pit", 2), rep("NA", 2)),
                              species = c("no capture", "opposum", "racoon", "no capture", "NA", "squirrel", "white-footed mouse", "field mouse", "NA", "NA"),
                              ticks_collected = c("NA", "Yes", "Yes", "NA", "NA", "No", "Yes", "Yes", "No", "NA"),
                              number_ticks = c(NA, 500, 2, NA, NA, 0, 15, 35, 0, NA),
                              temperature = c(35, 35, 26, 28, NA, 31, 36, 27, NA, NA),
                              collector = c("UK", "UK", "UK", "GG", "BB", "UK", "NA", "GG", "UK", "GG")
)

t3_validation_log <- data.frame(rowid = seq(1,10,1),
                                entry = c( 1, 1, 7, 9, 2, 10, 3, 6,  2, 4),
                                field = c( "temperature", "trap_type",  "temperature",  "temperature", "sampled", "date", "sampled", "sampled", "number_ticks", "location_id"),
                                issue = c("Data shouldn't be recorded when there was no sampling", "No trap was set as sampling didn't occur",  "NA even though data was collected that day", "Data was collected and sampled should be yes",  "Data shouldn't be recorded when there was no sampling", "Date outside of sampling timeframe", "Sampling occurred but sampled is no", "No sampling data for a day that was sampled", "Tick number seems high, double check", ""),
                                old_value = c(  "35", "Tomahawk", "36",  "", "", "2023-10-03", "No", "Yes", "500", "HH210"),
                                no_change = c("FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE", "FALSE"),
                                new_val = c(  "", "", "22", "28", "Yes", "2023-03-10", "No", "No",  "5", "HH_203"),
                                user_initials = sample(c("TY", "BY"), 10, replace = TRUE),
                                comments = c( "Check 1", "Check 2", "Check 3", "Check 4", "Check 5",  "Check 6", "Check 7", "Check 8", "Check 9", "arsenal check")
)%>%
  mutate(log_response_id = entry)%>%
  select(rowid,	log_response_id,	entry,	field,	issue,	old_value,	no_change,	new_val,	user_initials,	comments)


t3_semiclean_dat <- data.frame(unique_id = seq(1,10,1),
                               location_id = paste("HH", seq(200, 209, 1), sep = "_"),
                               date = c(as.Date("2023-03-01"), as.Date("2023-03-02"), as.Date("2023-03-03"), as.Date("2023-03-04"), as.Date("2023-03-05"),
                                        as.Date("2023-03-06"), as.Date("2023-03-07"), as.Date("2023-03-08"), as.Date("2023-03-09"), as.Date("2023-03-10")),
                               sampled = c("No", "Yes", "No", "Yes", "No", "Yes", "Yes", "Yes", "No", "No"),
                               trap_type = c(rep("Tomahawk", 3), rep("Shannon", 2), "NA", rep("Pit", 2), rep("NA", 2)),
                               species = c("no capture", "opposum", "racoon", "no capture", "NA", "squirrel", "white-footed mouse", "field mouse", "NA", "NA"),
                               ticks_collected = c("NA", "Yes", "Yes", "NA", "NA", "No", "Yes", "Yes", "NA", "NA"),
                               number_ticks = c(NA, 50, 2, NA, NA, 0, 15, 35, NA, NA),
                               temperature = c(NA, 35, 26, 28, NA, 31, NA, 27, NA, NA),
                               collector = c("UK", "UK", "UK", "GG", "BB", "UK", "NA", "GG", "UK", "GG")
)

#Validation log for test_3_arsenal_check
#t3_2_val_log <- t3_validation_log[9,]

write.csv(t3_original_dat,   "./inst/find_test_3_errors_orig_dat.csv",  row.names = FALSE)
write.csv(t3_validation_log, "./inst/find_test_3_errors_val_log.csv",   row.names = FALSE)
write.csv(t3_semiclean_dat,  "./inst/find_test_3_errors_clean_dat.csv", row.names = FALSE)
#write.csv(t3_2_val_log,      "./inst/find_test_3_2_errors_val_log.csv", row.names = FALSE)
