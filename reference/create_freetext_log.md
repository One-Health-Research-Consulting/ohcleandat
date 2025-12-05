# Create Free Text Log

Creates custom validation log for 'other: explain' free text responses
that may contain valid multi-choice options.

## Usage

``` r
create_freetext_log(response_data, form_schema, url, lookup)
```

## Arguments

- response_data:

  data.frame ODK questionnaire response data

- form_schema:

  data.frame ODK flattened form schema data

- url:

  The ODK submission URL excluding the uuid identifier

- lookup:

  a tibble formatted as a lookup to match questions with their free text
  responses. The format must match the output of
  [`othertext_lookup()`](https://One-Health-Research-Consulting.github.io/ohcleandat/reference/othertext_lookup.md).
  This function can be passed to this function argument as a convenient
  handler for this value.

## Value

data.frame validation log

## Details

This function needs to link a survey question with its corresponding
free text response. Users can use the
[`othertext_lookup()`](https://One-Health-Research-Consulting.github.io/ohcleandat/reference/othertext_lookup.md)
function to handle this, or provide their own tibble in the same format.
See below: tibble::tribble( ~name, ~other_name, question_1,
question_1_other )

## See also

[`othertext_lookup()`](https://One-Health-Research-Consulting.github.io/ohcleandat/reference/othertext_lookup.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Using othertext_lookup helper
test_a <- create_freetext_log(response_data = animal_owner_semiclean,
                              form_schema = animal_owner_schema,
                              url = "https://odk.xyz.io/#/projects/5/forms/project/submissions",
                              lookup = ohcleandat::othertext_lookup(questionnaire = "animal_owner")
                              )

# using custom lookup table
mylookup <- tibble::tribble(
  ~name, ~other_name,
  "f2_species_own", "f2a_species_own_oexp"
  )

  test_b <- create_freetext_log(response_data = animal_owner_semiclean,
                                form_schema = animal_owner_schema,
                                url = "https://odk.xyz.io/#/projects/5/forms/project/submissions",
                                lookup = mylookup
                                )
} # }
```
