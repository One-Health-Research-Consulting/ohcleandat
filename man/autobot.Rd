% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/autobot.R
\name{autobot}
\alias{autobot}
\title{Autobot Function}
\usage{
autobot(data, old_col, new_col, primary_key)
}
\arguments{
\item{data}{data.frame or tibble}

\item{old_col}{The existing column with formatting issues}

\item{new_col}{The new column with corrections applied}

\item{primary_key}{column that uniquely identifies the records in data}
}
\value{
tibble formatted as validation log
}
\description{
This compares two columns. Where there are differences, it extracts the values
and compiles a correctly formatted validation log. This is intended to be
used when an automated formatting correction is proposed in the data, but the
actual updating of the records is required to happen via the validation log.
}
