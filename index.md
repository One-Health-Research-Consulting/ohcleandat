# ohcleandat

This package provides useful functions to orchestrate analytics and data
cleaning pipelines for One Health projects.

## Installation

You can install the development version of ohcleandat from
[GitHub](https://github.com/one-health-research-consulting/ohcleandat)
with:

``` r
# install.packages("devtools")
devtools::install_github("one-health-research-consulting/ohcleandat")
```

## Getting Started

For help guides, check out the package vignettes.

## Contributions

This project uses the [Gitflow
workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).

All new feature requests should be done in a new branch based on `dev`
or a fork of `dev`. New branches can take the form `feature/*` or
`fix/*`. Once the feature is complete, automated CI checks and merge
checks will be performed and a pull request should be raised to merge
changes into `dev`.

Once the package is nearing a release, a `release/x.x.x` branch should
be created from the head of `dev`. This is used to make any changes to
convert the code to production level and to increment the version number
and make release notes if required before raising a PR into `main`. Once
the PR into `main` is accepted, a github release should be performed,
using the package version as the tag.

A final step is deleting any feature and release branches and merging
`main` back into `dev` and incrementing the `dev` version to
`x.x.x.9000`.

## Getting Help

If you encounter a clear bug, please file a minimal reproducible example
on [github](https://github.com/ecohealthalliance/ohcleandat/issues).
