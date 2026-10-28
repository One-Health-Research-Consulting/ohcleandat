devtools::load_all()

## full overlap of corrected entries in new log
existing_log <- readr::read_csv("inst/test_filtering_logs_existing.csv",
                                col_names = TRUE,
                                list(.default = readr::col_character()))
new_log <- readr::read_csv("inst/test_filtering_logs_new.csv",
                           col_names = TRUE,
                           list(.default = readr::col_character()))

## output should have 8 items and 10 vars
## id 4 has no change and
## id 9 has a revision
debugonce(keep_validated_entries)
validated_log <- keep_validated_entries(existing_log,new_log)


## output should have 1 item and 10 vars
## id_10 has not been corrected

unvalidated_log <- drop_validated_entries(existing_log,new_log)
