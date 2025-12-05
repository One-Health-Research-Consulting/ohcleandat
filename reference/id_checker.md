# ID Checker

General function for checking and correcting ID columns.

## Usage

``` r
id_checker(col, type = c("animal", "hum_anim", "site"), ...)
```

## Arguments

- col:

  The vector of ID's to be checked

- type:

  The ID type, see argument options for allowable settings

- ...:

  other function arguments passed to get_species_letter

## Value

vector of corrected ID's

## Details

In order to use the autobot process for correcting ID columns, a new
'corrected' column is created by the user using the id_checker()
function. It will take an existing vector of ID's, and an ID type
(animal, mosquito, etc) and apply the bespoke corrections. This can then
be consumed by the autobot log.

## Examples

``` r
if (FALSE) { # \dontrun{
# with a species identifier
    data |> mutate(animal_id_new = id_checker(animal_id, type = "animal", species = "cattle"))
    data |> mutate(farm_id_new = id_checker(farm_id, type = "site"))
    } # }
```
