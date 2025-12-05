# Look-up table for 'Other' questions

Provides a look up table matching ODK survey questions with their free
text response question.

## Usage

``` r
othertext_lookup(questionnaire = c("animal_owner"))
```

## Arguments

- questionnaire:

  The ODK questionnaire. Used to ensure the correct look up table is
  found.

## Value

tibble

## Details

In many ODK surveys, a multiple choice question can have a response for
'other' where the respondent can add free text as a response. There is
no consistent link in the response data to match the captured responses
and the other free-text collected. This function provides a manual look
up reference so free text responses can be compared to the original
questions in the validation workflow.

This function can be expanded by providing a tibble with two columns:
`name` and `other_name` which maps the question name in ODK to the
question name containing 'other' or 'free text'.

## Examples

``` r
othertext_lookup(questionnaire = c("animal_owner"))
#> # A tibble: 21 × 2
#>    name                      other_name                
#>    <chr>                     <chr>                     
#>  1 f2_species_own            f2a_species_own_oexp      
#>  2 f6e_rvf_vax_type          f6e_rvf_vax_type_oexp     
#>  3 f6a_protocol              f6a_protocol_other        
#>  4 f6b_which_vax             f6c_ani_vax_num_oexp      
#>  5 f6i_rvf_vax_chalenge_mult f6i_rvf_vax_chalenge_oexp 
#>  6 f7b_abortion_3_which      f7b_abortion_3_which_oexp 
#>  7 f7d_abortion_12_which     f7d_abortion_12_which_oexp
#>  8 f7f_abortus_dispose       f7f_abortus_dispose_oexp  
#>  9 f8_ani_contact            f8_ani_contact_oexp       
#> 10 f8c_contact_other_sp      f8c_contact_other_sp_oexp 
#> # ℹ 11 more rows

```
