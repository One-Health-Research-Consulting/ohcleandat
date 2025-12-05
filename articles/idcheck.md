# ID Correction and Autobot

``` r
library(ohcleandat)
```

The data cleaning and validation pipeline provides a way to specify
rules that can then be applied to data in order to produce a validation
log for manual corrections. However, in some cases particularly with the
use of ID columns there are certain automatic corrections that can be
made due to formatting errors.

For instance missing prefixes, incorrect case, or non-standard
formatting of columns where there should be a predictable and fixed
format. In this case, we wish to provide an automated cleaning step that
makes these corrections to the data, but also produces a validation log
for our records. This is done in two steps.

The first is applying the automatic corrections through the use of an
`id_check()` function (or family of checking functions). These operate
on the semi-clean data set to produce a new proposed column with the
automated corrections. These functions are designed and implemented by
users based on their requirements.

Once these corrections are made, both the original ID column and the new
corrected ID column are provided to an
[`autobot()`](https://One-Health-Research-Consulting.github.io/ohcleandat/reference/autobot.md)
function in the pipeline. The
[`autobot()`](https://One-Health-Research-Consulting.github.io/ohcleandat/reference/autobot.md)
function compares these records and keeps only those where the original
in the new column are different - indicating that some form of automatic
correction has been made.

A validation log is generated in the exact same format as other
validation logs, however a key change here is that this validation log
does not require the manual overview of a reviewer. The proposed changes
are automatically accepted by the autobot. The reason for producing the
log is to persist changes and have a record of how IDs have changed due
to automatic corrections.

## Example

Below is an example of a (fake) farm_id identifier. We can see the ID
checker functions have corrected an ‘O’ to ‘0’ in record 2. Case
correction has taken place, and records that do not conform the the
required pattern post corrections, are set to NA for manual review.

    # A tibble: 6 × 2
      farm_id    farm_id_new
      <chr>      <chr>      
    1 123ABC0007 NA         
    2 1O3ABC010  103ABC010  
    3 143abc010  143ABC010  
    4 13DEFH005  NA         
    5 243DLF803  243DLF803  
    6 243DPF911  243DPF911 

    > ohcleandat::autobot(data = test, old_col = "farm_id", new_col = "farm_id_new", key = "farm_id")
    # A tibble: 2 × 8
      entry     field   issue                               old_value no_change new_val  user_initials comments
      <chr>     <chr>   <chr>                               <chr>     <chr>    <chr>    <chr>         <chr>   
    1 1O3ABC010 farm_id Automated field format check failed 1O3ABC010 FALSE    103ABC0… autobot       ""      
    2 143abc010 farm_id Automated field format check failed 143abc010 FALSE    143ABC0… autobot       ""    
