# Create the full set of id validation logs

Takes a list of datasets with shared foreign keys (identifiers that
should match across the datasets) and creates the full set of pairwise
id validation logs. This function is essentially a wrapper for
[`create_id_log()`](https://One-Health-Research-Consulting.github.io/ohcleandat/reference/create_id_log.md)
that computes all the unique pairs of datasets in a given list then runs
each pair through `create_id_log`.

## Usage

``` r
create_full_id_log(dataset_list)
```

## Arguments

- dataset_list:

  List. A list of datasets where each item has the following fields
  semiclean_data, foreign_key, primary_key, and name.

## Value

dataframe id validation log

## Details

`create_id_log` flags duplicate foreign keys and any foreign keys not in
both datasets. The purpose of this log is to ensure links between
datasets created by foreign keys are correct and to help identify any
potentially missing data.

Foreign keys are identifiers that link two or more datasets.

Primary keys are identifiers that uniquely identify items in a dataset.

## Examples

``` r

# dataset 1 and dataset 2 have perfectly matching foreign keys
# and the fields are consistently named.

dataset_item_1 <- list(
semiclean_data = data.frame(primary_key = 1:10,
                            foreign_key = letters[1:10]),
foreign_key = "foreign_key",
primary_key = "primary_key",
name = "dataset_1"
)


dataset_item_2 <- list(
  semiclean_data = data.frame(primary_key = 1:10,
                              foreign_key = letters[1:10]),
  foreign_key = "foreign_key",
  primary_key = "primary_key",
  name = "dataset_2"
)

# dataset 3 uses a different column name for the shared "foreign_key", is missing a,
# and has an additional key k
dataset_item_3 <- list(
  semiclean_data = data.frame(blah = 1:10,
                              bob = letters[2:11]),
  foreign_key = "bob",
  primary_key = "blah",
  name = "dataset_3"
)

# dataset 4 uses yet another name for the shared "foreign_key", has duplicate a's,
# and is missing b

dataset_item_4 <- list(
  semiclean_data = data.frame(blah = 1:10,
                              gary = c(rep(letters[1],2),letters[3:10])
  ),
  foreign_key = "gary",
  primary_key = "blah",
  name = "dataset_4"
)

dataset_list <- list(dataset_item_1,dataset_item_2,dataset_item_3, dataset_item_4)

create_full_id_log(dataset_list)
#> # A tibble: 12 × 9
#>    dataset  entry field issue old_value no_change new_val user_initials comments
#>    <chr>    <int> <chr> <chr> <chr>     <chr>     <chr>   <chr>         <chr>   
#>  1 dataset…     1 fore… fore… a         ""        ""      ""            ""      
#>  2 dataset…    10 bob   bob … k         ""        ""      ""            ""      
#>  3 dataset…     2 fore… fore… b         ""        ""      ""            ""      
#>  4 dataset…     1 gary  Dupl… a         ""        ""      ""            ""      
#>  5 dataset…     2 gary  Dupl… a         ""        ""      ""            ""      
#>  6 dataset…     1 fore… fore… a         ""        ""      ""            ""      
#>  7 dataset…    10 bob   bob … k         ""        ""      ""            ""      
#>  8 dataset…     2 fore… fore… b         ""        ""      ""            ""      
#>  9 dataset…     1 bob   bob … b         ""        ""      ""            ""      
#> 10 dataset…    10 bob   bob … k         ""        ""      ""            ""      
#> 11 dataset…     1 gary  gary… a         ""        ""      ""            ""      
#> 12 dataset…     2 gary  gary… a         ""        ""      ""            ""      
```
