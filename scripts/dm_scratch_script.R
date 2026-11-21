library(dm)

# lets pretend this is what our data look like
survey_data <- data.frame(id = letters[1:10],
                          some_question = rbinom(n = 10,size = 1,prob = .3),
                          human_id = rep(1:5, each =2))

mos_data <- data.frame(id = as.character(1:10),
                       genus = sample(c("Aedes","Culex"),
                                      size = 10,replace = TRUE),
                       env_id = paste("env",1:10,sep = "_"),
                       human_id = rep(2:6, each = 2), # adding a key for a non-existent table
                       household_id = c(letters[1:9], letters[11]))

env_data <- data.frame(id = paste("env",1:10,sep = "_"),
                       trap_id = 1:10,
                       hhid = toupper(mos_data$household_id))

project_data_no_keys <- dm::dm(survey_data,mos_data,env_data)

# add primary keys
project_data_pks <- project_data_no_keys |>
  dm::dm_add_pk(table = survey_data, columns = id) |>
  dm::dm_add_pk(table = mos_data, columns = id) |>
  dm::dm_add_pk(table = env_data, columns = id)

# have dm look for foreign keys
dm::dm_enum_fk_candidates(project_data_pks,table = mos_data,ref_table = survey_data)

## add foreign keys

project_data_fks <- project_data_pks |>
  dm::dm_add_fk(table = mos_data,columns = "household_id", ref_table = survey_data) |>
  dm::dm_add_fk(table = mos_data,columns = "env_id", ref_table = env_data) |>
  dm::dm_add_fk(table = env_data,columns = "hhid", ref_table = survey_data) |>
  dm::dm_add_fk(table = env_data,columns = "trap_id", ref_table = mos_data)





dm_obj <- project_data_fks



# look at the data model
dm::dm_get_all_fks(project_data_fks)




project_data_fks |>
  dm::dm_draw()

df <- project_data_fks$env_data |>
  dplyr::mutate("blah" = 1)
df

### read in raw data
## do corrections
## add to dm


## replicate list


survey <- list(
  semiclean_data = data.frame(primary_key = 1:10,
                              foreign_key = letters[1:10],
                              do_you_like_ohcleandat = sample(c("yes","no"),size = 10,replace = TRUE)),
  foreign_key = "foreign_key",
  primary_key = "primary_key",
  name = "survey"
)


semiclean_data = project_data_fks$survey_data

dm::dm_get_all_fks(project_data_fks)

dm_obj <- project_data_fks

dataset_list_from_dm <- function(dm_obj, target_pk){

  # for each table in the dm object create a  list with the following attributes
  # semiclean data
  # foreign_key
  # primary key
  # name

  names(dm_obj)




}

create_full_id_log()

## recreate dm object so that you can have implicit tables
## hhid - doesnt have a table of its own

list(
  # data frame 1
  survey_data = list(
    data = survey_data_semiclean,
    primary_key = "odk_response_id",
    foreign_keys = list(
      # foreign key 1
      hhid = list(
          univeral_name = "HHID",
          sero_data = "household_id",
          rodent_data = "HHID",
          mos_data = "HouseHold_Identifier"
        ),
      # foreign key 2
        site_id = list(
          env_data = "id",
          rodent_data = "site_id",
          mos_data = "Site_Identifier"
        )
    )
  )
)

# make_data_package # builds schema and stores semiclean data




# ohcleandat database
ocdat_package <- make_ocdat_package(semiclean_survey_data, semiclean_participant_data)


ocdat_package |>
  add_pk(col = "odk_response_id", dataset = "semiclean_survey_data")



#data frame
ocdat_package$survey_data$data

ocdat_package$survey_data |>
  # adds the hhid item to survey data
  # and adds the household_id item to sero_data, assuming sero data is there
  # if universal name is null, check the reference table to see if fk is a
  # primary in the reference table, if it is a primary key, use that name as the universal name, if no, use `col` value and inform
  add_fk(col = "hhid", ref_table = c("sero_data"), col_ref_table = c("household_id"), universal_name = "Household_ID") |>
  add_fk(col = "hhid", ref_table = "rodent", col_ref_table = "HHID", univeral_name = "HHID") # overwrites universal name


ocdat_package$rodent_data |>
  # adds the hhid item to survey data
  # and adds the household_id item to sero_data, assuming sero data is there
  add_fk(col = "hhid", ref_table = c("sero_data"), col_ref_table = c("household_id"), universal_name = "Household_ID") |>
  add_fk(col = "hhid", ref_table = "rodent", col_ref_table = "HHID", univeral_name = "HHID")


## all datasets, with all their foreign keys


## all variants of a specific id
make_ocdat_schema_dataframe( ocdat_package,
                             foreign_keys = c("Human ID","Household ID",...) # overall name for the field, output will be ordered by this vector
                             )

# Dataset Name | Primary Key | Human ID | House Hold ID| fk100
   asdlfkj.        id.          HID
   'klj'           id          human_id
   '138'           odk_url.      NA     | hhid


















