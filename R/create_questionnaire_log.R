#' Create Validation Log for Questionnaire data
#'
#' @param data data fame  Input data to be validated
#' @param form_schema data frame The ODK form schema data
#' @param rule_set  a rule set of class validator from the validate package
#' @param primary_key character  A character vector giving the column name of the primary key or unique row identifier in the data
#' @param url The ODK submission URL excluding the uuid identifier
#'
#' @return a data frame formatted as a validation log for human review
#' @export
create_questionnaire_log <-
  function(data, form_schema, primary_key, rule_set, url) {
    conf_obj <- validate::confront(data, rule_set, raise = 'all')

    rule_sum <- validate::summary(conf_obj) |>
      cbind(description = meta(rule_set)[["description"]]) |>
      dplyr::mutate(
        description = dplyr::na_if(description, ""),
        description = dplyr::coalesce(description, expression)
      )

    rule_vals <- validate::values(conf_obj)

    issues <- rule_vals |>
      tibble::as_tibble() |>
      dplyr::mutate(id = dplyr::pull(data, primary_key), .before = 1) |>
      tidyr::pivot_longer(cols = -id)  |>
      dplyr::filter(value == FALSE) |>
      dplyr::inner_join(rule_sum, by = dplyr::join_by(name)) |>
      dplyr::select(entry = id,
                    field = name,
                    issue = description) |>
      dplyr::mutate(field = stringr::str_extract(field, pattern = "^.*?(?=\\.(\\d+)|$)")) |>
      dplyr::left_join(
        data,
        by = c("entry" = primary_key),
        na_matches = "never",
        keep = TRUE
      ) |>
      dplyr::left_join(
        dplyr::select(form_schema, name, question = "label_english_(en)") ,
        by = c("field" = "name")
      )

    log <- issues |>
      dplyr::mutate(dplyr::across(tidyselect::everything(), as.character)) |>
      tidyr::pivot_longer(
        -c(entry, field, question, issue),
        values_to = "old_value",
        values_transform = as.character
      ) |>
      dplyr::filter(field == name) |>
      dplyr::select(-name) |>
      tidyr::replace_na(list(old_value = '', question = '')) |>
      dplyr::mutate(
        no_change = '',
        new_val = '',
        user_initials = '',
        comments = '',
        odk_url = paste(
          url,
          stringr::str_replace(entry, pattern = ":", replacement = "%3A"),
          sep = "/"
        ),
        overwrite_old_value = "TRUE"
      ) |>
      dplyr::select(
        entry,
        field,
        question,
        issue,
        old_value,
        no_change,
        new_val,
        overwrite_old_value,
        user_initials,
        odk_url,
        comments
      )

    return(log)

  }
