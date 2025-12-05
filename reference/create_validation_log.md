# Create Validation Log

Create Validation Log

## Usage

``` r
create_validation_log(data, primary_key, rule_set, ...)
```

## Arguments

- data:

  data fame Input data to be validated

- primary_key:

  character a character vector giving the column name of the primary key
  or unique row identifier in the data

- rule_set:

  a rule set of class validator from the validate package

- ...:

  other arguments passed to validate::confront

## Value

a data frame formatted as a validation log for human review
