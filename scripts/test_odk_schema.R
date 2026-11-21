devtools::load_all()

test_schema <- schema_from_odk_xlsx_template(file_path = "inst/example_odk_schema.xlsx",
                              `choices_english_(en)` = list(`label_english_(en)`),
                               `choices_zulu_(zu)` = list(`label_zulu_(zu)`)
                              )

test_schema$`choices_english_(en)`

test_schema$choices

free_text_names <- test_schema |>
  dplyr::pull(name) |>
  unique()

exclude_these <- free_text_names %in% c("hello", "notes")

exclude_these <-  c("hello", "notes") %in% free_text_names


exclude_these

purrr::map2(test_schema$`choices_english_(en)`, test_schema$choices, function(label, value){
  if(is.null(label)){
    return(NULL)
  }

  list("label" = label,
       "value" = value)
})
