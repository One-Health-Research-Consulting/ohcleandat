# Write data RDS

This function will write an RDS file for an R object if the file

1.  doesnt exist or 2) the object or file have changed.

## Usage

``` r
write_rds(r_obj, rds_file, ...)
```

## Arguments

- r_obj:

  R object to be saved. Likely a data frame

- rds_file:

  String. Path to rds file in the repo

- ...:

  Additional arguments to pass to saveRDS

## Value

Path to rds file

## Details

It is useful when working with data streams (airtable, googledrive,
dropbox, etc) that depend on account based access - particularly through
an institution or via an employer. If that account loses access to the
data stream then an entire pipeline may go down. Having a copy of the
data stored as RDS allows you to modify your pipeline to use the local
copy of the data instead.

## Examples
