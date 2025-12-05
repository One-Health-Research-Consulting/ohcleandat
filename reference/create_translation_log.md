# Create Translation Log

Collates free text responses from 'other' and 'notes' fields in the
survey data. Some language detection is performed and placed in the log
notes section for possible translation.

## Usage

``` r
create_translation_log(response_data, form_schema, url)
```

## Arguments

- response_data:

  data.frame of ODK questionnaire responses

- form_schema:

  data.frame or flattened ODK form schema

- url:

  The ODK submission URL excluding the uuid identifier

## Value

data.frame validation log

## Examples
