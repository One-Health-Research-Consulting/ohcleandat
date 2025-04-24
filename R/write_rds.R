#' Write data RDS
#'
#' This function will write an RDS file for an R object if the file
#' 1) doesnt exist or 2) the object or file have changed.
#'
#' It is useful when working with data streams (airtable, googledrive, dropbox,
#' etc) that depend on account based access - particularly through an
#' institution or via an employer. If that account loses access to the data
#' stream then an entire pipeline may go down. Having a copy of the data
#' stored as RDS allows you to modify your pipeline to use the local copy
#' of the data instead.
#'
#' @param r_obj R object to be saved. Likely a data frame
#' @param rds_file String. Path to rds file in the repo
#' @param ... Additional arguments to pass to saveRDS
#'
#' @returns Path to rds file
#' @export
#'
#' @examples
#' \dontrun{
#'  pretend we got this from a work associated dropbox folder
#'  df <- data.frame(a = 1:10)
#'  # write rds file somewhere
#'  rds_path <- write_rds(df, "example.rds")
#'  # read it back in
#'  df_from_rds < readRDS(rds_path)-
#' }
#'

write_rds <- function(r_obj, rds_file, ...) {

  if(fs::file_exists(rds_file) & !is.null(r_obj)){
    dat_rds <- readRDS(file = rds_file)
    if(!identical(r_obj,dat_rds)){
      rlang::warn("raw data have changed, .rds file will be overwritten.")
      saveRDS(r_obj, file =  rds_file) # this is safe enough because data will be version controlled
    }
  } else {
    rds_dir <- fs::path_dir(rds_file)

    if(!fs::dir_exists(rds_dir)){
      fs::dir_create(rds_dir)
    }


    rlang::inform("writing raw data rds")
    saveRDS(r_obj,file =  rds_file, ...)
  }

  if(!fs::file_exists(rds_file)){
    rlang::abort("rds file not written. Check path in rds_file")
  }

  return(rds_file)
}
