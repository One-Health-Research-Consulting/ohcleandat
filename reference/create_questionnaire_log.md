# Create Validation Log for Questionnaire data

Create Validation Log for Questionnaire data

## Usage

``` r
create_questionnaire_log(data, form_schema, primary_key, rule_set, url)
```

## Arguments

- data:

  data fame Input data to be validated

- form_schema:

  data frame The ODK form schema data

- primary_key:

  character A character vector giving the column name of the primary key
  or unique row identifier in the data

- rule_set:

  a rule set of class validator from the validate package

- url:

  The ODK submission URL excluding the uuid identifier

## Value

a data frame formatted as a validation log for human review
