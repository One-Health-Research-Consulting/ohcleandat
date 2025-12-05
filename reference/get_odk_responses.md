# Get ODK Questionnaire Response Data

This function handles the authentication and pulling of responses data
for ODK Questionnaires. The raw return list is 'rectangularized' into a
data frame first. See the `ruODK` package for more info on how this
happens.

## Usage

``` r
get_odk_responses(
  url,
  un = Sys.getenv("ODK_USERNAME"),
  pw = Sys.getenv("ODK_PASSWORD"),
  odkc_version = Sys.getenv("ODKC_VERSION")
)
```

## Arguments

- url:

  character The survey URL

- un:

  character The ODK account username

- pw:

  character The ODK account password

- odkc_version:

  character The ODK version

## Value

data.frame of flattened survey responses

## Details

This is a wrapper around the `ruODK` package. It handles the setup and
authentication. See <https://github.com/ropensci/ruODK>

## See also

[`ruODK::form_schema_ext()`](https://docs.ropensci.org/ruODK/reference/form_schema_ext.html)

## Examples

``` r
if (FALSE) { # \dontrun{
    get_odk_responses(url ="https://odk.xyz.io/v1/projects/5/forms/survey.svc",
    un = Sys.getenv("ODK_USERNAME"),
    pw = Sys.getenv("ODK_PASSWORD"),
    odkc_version = Sys.getenv("ODKC_VERSION"))
} # }
```
