# clean dataset
survey <- list(
  semiclean_data = data.frame(primary_key = 1:10,
                              foreign_key = letters[1:10],
                              do_you_like_ohcleandat = sample(c("yes","no"),size = 10,replace = TRUE)),
  foreign_key = "foreign_key",
  primary_key = "primary_key",
  name = "survey"
)


# hhid is single value
sero_prev <- list(
  semiclean_data = data.frame(sample_id = 1:10,
                              hhid = c(letters[1:9],"z"),
                              pos = sample(c(TRUE,FALSE),size = 10, replace = TRUE)),
  foreign_key = "hhid",
  primary_key = "sample_id",
  name = "sero_prev"
)


# duplicate hhid
env_data <- list(
  semiclean_data = data.frame(measurement_id = 1:10,
                              house_hold_id = c(rep(letters[1],2),letters[3:10])
  ),
  foreign_key = "house_hold_id",
  primary_key = "measurement_id",
  name = "env_data.csv"
)
# duplicate hhid
mos_data <- list(
  semiclean_data = data.frame(mosquito_id = 1:10,
                              hhold_id = c(rep(letters[1],2),letters[3:10]),
                              genus = sample(c("Aedes","Culex"),10,TRUE)
  ),
  foreign_key = "hhold_id",
  primary_key = "mosquito_id",
  name = "mos_data"
)

# duplicate hhid and is missing hhdids
visit_record <- list(
  semiclean_data = data.frame(visit_id = 1:5,
                              hhid = c(rep(letters[1],2),letters[3:5]),
                              construction_material = sample(c("stick","straw","brick"), 5,TRUE)
  ),
  foreign_key = "hhid",
  primary_key = "visit_id",
  name = "visit_record"
)


dataset_list <- list(survey,sero_prev,env_data)

create_full_id_log(dataset_list) |>
  View()


dataset_list <- list(survey,roster,sero_prev,env_data,mos_data,visit_record)

create_full_id_log(dataset_list) |>
  head(n = 10)



