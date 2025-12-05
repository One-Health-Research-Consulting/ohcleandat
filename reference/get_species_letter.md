# Get Species Letter

This function maps the relationship between animal species and
hum_anim_id codes. This is for use in id_checker()

## Usage

``` r
get_species_letter(
  species = c("human", "cattle", "small_mammal", "sheep", "goat")
)
```

## Arguments

- species:

  character The species identifier. See argument options

## Value

character The hum_anim_id code
