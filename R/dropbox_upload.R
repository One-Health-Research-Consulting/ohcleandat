#' Dropbox Upload
#'
#' Upload a local file to dropbox and handle authentication. Automatically
#' zips files over 300mb by default.
#'
#' @details
#' This is a wrapper of `rdrop2::drop_upload()` which first reads in a local
#' CSV file and then uploads to a DropBox path.
#'
#' @param dataframe Data frame. Will work with any tabular data. Designed to be used with Validation Log for OH cleaning pipelines.
#' @param file_path character. local file path for upload
#' @param dropbox_path character. relative dropbox path
#' @param compress logical. Should files over 300mb be compressed?
#'
#' @return performs drop box upload
#' @export
#' @examples
#' \dontrun{
#'     dropbox_upload(
#'     kzn_animal_ship_semiclean,
#'     file_path = here::here("outputs/data.csv"),
#'     dropbox_path = "XYZ/Data/semi_clean_data"
#'     )
#' }
#'
dropbox_upload <- function(dataframe, file_path, dropbox_path,compress = TRUE) {
  dataframe_export <- readr::write_csv(dataframe, file_path)

  # set file path for file to upload
  file_to_upload <- file_path

  # check the file size
  file_size_check <- (file.size(file_path)/10^6) > 300

  # if compress and file size is greater than 300 then zip it
  if(all(compress,file_size_check)){
    file_to_upload <- make_zip_path(file_path)
    utils::zip(zipfile = file_to_upload,files = file_path)
  }

  # upload
  rdrop2::drop_upload(file_to_upload, dropbox_path)

}
