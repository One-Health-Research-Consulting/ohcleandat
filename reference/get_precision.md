# Get Precision

Get Precision

## Usage

``` r
get_precision(x, func = c, ...)
```

## Arguments

- x:

  Numeric. Vector of gps points

- func:

  Function. Apply some function to the vector of precisions. Default is
  c so that all values are returned

- ...:

  Additional arguments to pass to func.

## Value

output of func - likely a vector

## Author

Nathan Layman

## Examples

``` r
x <- c(1,100,1.11)
get_precision(x,func = min)
#> [1] 0.01

```
