# Get ODK Questionnaire Schema Info

This function handles the authentication and pulling of questionnaire
form schema information.

## Usage

``` r
get_odk_form_schema(
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

  character The ODKC Version string

## Value

data frame of survey responses

## Details

This is a wrapper around the `ruODK` package. It handles the setup and
authentication. See <https://github.com/ropensci/ruODK>

## See also

[`ruODK::form_schema_ext()`](https://docs.ropensci.org/ruODK/reference/form_schema_ext.html)

## Examples

``` r
if (FALSE) { # \dontrun{
    get_odk_form_schema(url ="https://odk.xyz.io/v1/projects/5/forms/survey.svc",
    un = Sys.getenv("ODK_USERNAME"),
    pw = Sys.getenv("ODK_PASSWORD"),
    odkc_version = Sys.getenv("ODKC_VERSION"))
} # }
```
