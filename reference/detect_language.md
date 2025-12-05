# Detect Language

A function that extracts the top guess of the language of a piece of
text.

## Usage

``` r
detect_language(text)
```

## Arguments

- text:

  character any text string

## Value

character estimate for language abbreviation

## Details

Utilizes the stringi package encoding detector as the means to infer
language.

## See also

[`stringi::stri_enc_detect()`](https://rdrr.io/pkg/stringi/man/stri_enc_detect.html)

## Examples

``` r
detect_language(text = "buongiorno")
#> [1] "it"
```
