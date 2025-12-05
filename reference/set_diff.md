# Get items that differ between x and y

Unlike setdiff, this function creates the union of x and y then removes
values that are in the intersect, providing values that are unique to X
and values that are unique to Y.

## Usage

``` r
set_diff(x, y)
```

## Arguments

- x:

  a set of values.

- y:

  a set of values.

## Value

Unique values from X and Y, NULL if no unique values.

## Examples

``` r
a <- 1:3
b <- 2:4

set_diff(a,b)
#> [1] 1 4
# returns 1,4

x <- 1:3
y <- 1:3

set_diff(x,y)
#> NULL
# returns NULL
```
