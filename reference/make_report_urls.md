# Make the URLs for the reports

Several HTML reports are emailed via an automated process. To do this a
secure URL is to be generated as a download link. This function is to be
used in an opinionated targets pipeline.

## Usage

``` r
make_report_urls(aws_deploy_target, pattern = "")
```

## Arguments

- aws_deploy_target:

  List. Output from aws_s3_upload

- pattern:

  String. Regex pattern for matching file paths

## Value

character URL for report

## Author

Collin Schwantes
