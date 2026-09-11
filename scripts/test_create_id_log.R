source("R/create_id_log.R")

#testing no differences
semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = letters[1:10])
semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[1:10])

debugonce(create_id_log)

test<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")


#testing 2 differences
semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = letters[1:10])
semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[2:11])

debugonce(create_id_log)

test<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")

#testing 1 differences
semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = letters[1:10])
semiclean_y<-data.frame("primary_key_y" = 1:11, "household_id" = letters[1:11])

debugonce(create_id_log)

test<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")

#testing duplicates
semiclean_x<-data.frame("primary_key_x" = 1:10, "hhid" = c(letters[1:5], letters[1:5]))
semiclean_y<-data.frame("primary_key_y" = 1:10, "household_id" = letters[1:10])

debugonce(create_id_log)

test<-create_id_log(semiclean_x, semiclean_y, by = c("hhid"="household_id"), "primary_key_x",
                    "primary_key_y", name_x = "semiclean_x.csv" , name_y = "semiclean_y.csv")
