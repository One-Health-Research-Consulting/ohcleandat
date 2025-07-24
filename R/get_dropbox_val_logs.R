#' Get Dropbox Validation Logs
#'
#' Downloads existing validation logs that are stored on dropbox
#'
#' This function will check if the log exists and return NULL if not. Else it will
#' locally download the file to 'dropbox_validations' directory and read in to the
#' session.
#'
#' @param file_name character file name with extension of the validation log.
#' Note that file may have been zipped on upload if its over 300mb. This file
#' will be automatically unzipped on download so provide the file extenstion for
#'  the compressed file, not the zipped file. E.g. "val_log.csv" even if on
#'  dropbox its stored as "val_log.zip".
#' @param folder character the folder the log is saved in on drop box. Can be NULL if not in subfolder.
#' @param path_name character the default drop box path
#'
#' @return tibble a Validation Log
#' @export
#' @examples
#' \dontrun{
#'  get_dropbox_val_logs(file_name = "log.csv", folder = NULL)
#' }
#'
get_dropbox_val_logs <-
  function(file_name, folder, path_name) {

    # path handling when log isnt in a dedicated subfolder on drop box
    if (is.null(folder)) {
      full_path_name <- sprintf("%s/%s", path_name, file_name)
    } else {
      full_path_name <- sprintf("%s/%s/%s", path_name, folder, file_name)
    }

    # check file exists - it wont on first push
    if (!rdrop2::drop_exists(full_path_name)) {
      # check for zip version
      full_path_name <- make_zip_path(full_path_name)
      if(!rdrop2::drop_exists(full_path_name)){
        return(NULL)
      }
    }

    # download file from drop box
    rdrop2::drop_download(
      path = full_path_name,
      local_path = here::here("dropbox_validations"),
      overwrite = TRUE
    )

    # reading in the log, detecting with excel or csv
    local_path <- sprintf("%s/%s", "dropbox_validations", file_name)

    # unzip if zipped
    if (stringr::str_detect(full_path_name, ".zip")) {
      local_zip_path <- make_zip_path(local_path)
      utils::unzip(zipfile = local_zip_path,files = here::here(local_path))
    }

    if (stringr::str_detect(file_name, ".xls|.xlsx")) {
      df <- readxl::read_xlsx(here::here(local_path))
    }

    if (stringr::str_detect(file_name, ".csv")) {

      temp_df <- readr::read_csv(file = here::here(local_path))

      temp_df_cols  <- ncol(temp_df)

      char_cols <- rep("c",times = (temp_df_cols-2) ) |>
        paste(collapse = "")

      col_types <- sprintf("ii%s",char_cols)

      df <-
        readr::read_csv(here::here(local_path),
                        col_types = col_types,
                        na = character())
    }



    # this ensures the log is ordered correctly before cleaning operations in case the user
    # has sorted the data before upload. Order is important so changes are processed sequentially.
    df_out <- df |>
      dplyr::arrange(rowid) |>
      dplyr::select(-log_response_id, -rowid)

    return(df_out)
  }
