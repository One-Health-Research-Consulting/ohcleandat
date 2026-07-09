# Obfuscate GPS

This function fuzzes gps points by first adding error then rounding to a
certain number of digits.

## Usage

``` r
obfuscate_gps(
  x,
  precision = 2,
  fuzz = 0.125,
  type = c("lat", "lon"),
  func = min,
  ...
)

obfuscate_lat(x, precision = 2, fuzz = 0.125)

obfuscate_lon(x, precision = 2, fuzz = 0.125)
```

## Arguments

- x:

  Numeric. Vector of gps points

- precision:

  Integer. Number of digits to keep. See `round` for more details

- fuzz:

  Numeric. Positive number indicating how much error to introduce to the
  gps measurements. This is used to generate the random uniform
  distribution `runif(1,min = -fuzz, max = fuzz)`

- type:

  Character. One of "lat" or "lon"

- func:

  Function. Function used in `get_precision`

- ...:

  Additional arguments for func.

## Value

Numeric. A vector of fuzzed and rounded GPS points

Numeric vector

Numeric vector

## Examples

``` r

# make data
gps_data  <- data.frame(lat = c(1.0001, 10.22223, 4.00588),
                        lon = c(2.39595, 4.506930, -60.09999901))

# Default obfuscation settings correspont to roughly a 27 by 27 km area
gps_data$lat |>
  obfuscate_gps(type = "lat")
#> The data have a max precision of: 1e-05
#> The max shift from the combination of precision and fuzz is: 0.225 degrees
#> [1]  0.90 10.12  3.90

# Obfuscation can be made more or less precise by changing the number of
# decimal points included or modifying the amount of fuzz (error)
# introduced
gps_data$lon |>
  obfuscate_gps(precision = 4, fuzz = 0.002, type = "lon")
#> The data have a max precision of: 1e-08
#> The max shift from the combination of precision and fuzz is: 0.012 degrees
#> The majority of the obfuscation is coming from rounding, this
#>     potentially makes re-identification easier
#> [1]   2.3973   4.5083 -60.0987

### working at the poles
gps_data_poles  <- data.frame(lat = c(89.0001, 89.22223, -89.8881),
                              lon = c(2.39595, 4.506930, -60.09999901))


gps_data_poles$lat |>
  obfuscate_gps(fuzz = 1, type = "lat")
#> The data have a max precision of: 1e-05
#> The max shift from the combination of precision and fuzz is: 1.1 degrees
#> [1]  89.20  89.42 -89.69


### working at the 180th meridian
gps_data_180  <- data.frame(lat = c(2, 3, 4),
                            lon = c(179.39595, -179.506930, -178.09999901))
gps_data_180$lon |>
  obfuscate_gps(fuzz = 1, type = "lon")
#> The data have a max precision of: 1e-08
#> The max shift from the combination of precision and fuzz is: 1.1 degrees
#> [1]  178.71  179.81 -178.79

### working NA GPS data
gps_data_180  <- data.frame(lat = c(2, 3, 4),
                            lon = c(179.39595, NA, -178.09999901))
gps_data_180$lon |>
  obfuscate_gps(fuzz = 1, type = "lon")
#> The data have a max precision of: 1e-08
#> The max shift from the combination of precision and fuzz is: 1.1 degrees
#> [1]  178.41      NA -179.09

### GPS is on the fritz!
if (FALSE) { # \dontrun{
gps_data_fritz <- data.frame(lat = c(91, -91, 90),
                             lon = c(181.0001, -181.9877, -178.09999901))
gps_data_fritz$lon |>
  obfuscate_gps(fuzz = 1, type = "lon")

gps_data_fritz$lat |>
  obfuscate_gps(fuzz = 1, type = "lat")
} # }
```
