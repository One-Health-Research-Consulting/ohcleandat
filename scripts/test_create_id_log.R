source("R/create_id_log.R")

debugonce(create_id_log)
#testing no differences and no duplicates
semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = letters[1:10])
semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[1:10])

test_no_mm<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")

#should be an empty log

#testing 2 differences
semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = letters[1:10])
semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[2:11])

test_mm_2<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")

#should have a log with 2 rows of IDs, one from y (household_id) and one from x (hhid)

#testing 1 difference in y
semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = letters[1:10])
semiclean_y<-data.frame("primary_key_y" = 1:11, "household_id" = letters[1:11])

debugonce(create_id_log)

test_mm_1_y<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")

#should have a log with 1 row from y (household_id)

#testing 1 difference in x
semiclean_x<-data.frame("primary_key_x" = 1:11, "hhid" = letters[1:11])
semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[1:10])


test_mm_1_x<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                           "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")

#should have a log with 1 row from x (hhid)

#testing duplicates in x with mismatching IDs in y

semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = c(letters[1:5], letters[1:5]))
semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[1:10])

test_dupes_mm_1<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")

#should have 15 rows, 10 of duplicates in x (hhid) and 5 of mismatches y (household_id) not found in x

#testing duplicates in y with mismatching IDs in x
semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = letters[1:10])
semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = c(letters[1:5],letters[1:5]))

test_dupes_mm_2<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                             "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")

#should have 15 rows, 10 of duplicates in y (household_id) and 5 of mismatches x (hhid) not found in y


#testing just duplicates
semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = c(letters[1:5], letters[1:5]))
semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[1:5])

debugonce(create_id_log)

test_dupes<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")


#testing duplicates in y
semiclean_x<-data.frame("primary_key_x" = 1:5, "hhid" = letters[1:5])
semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[1:5])

test_y_dupes<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")

#we expect that there are 10 rows for the 5 duplicated IDs in data set y for "household_id"


#testing duplicates in x
semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = letters[1:5])
semiclean_y<-data.frame("primary_key_y" = 1:5, "household_id" = letters[1:5])

test_x_dupes<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")


#we expect that there are 10 rows for the 5 duplicated IDsn data set x for "hhid"

#testing mismatched types
semiclean_x<-data.frame("primary_key_x" = 1:5, "hhid" = 1:5)
semiclean_y<-data.frame("primary_key_y" = 1:5, "household_id" = as.character(1:5))

test_x_dupes<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                            "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")
