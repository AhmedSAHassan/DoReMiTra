% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compare_datasets.R
\name{compare_datasets}
\alias{compare_datasets}
\title{Title
Compares the essential metadata information of 2 or more SE objects
including radiation type, dose, time point, etc.}
\usage{
compare_datasets(
  ...,
  fields = c("Radiation_type", "Dose", "Sex", "Time_point", "Organism")
)
}
\arguments{
\item{fields}{a character vector of the main metadata info}
}
\value{
a dataframe comparing the metadata of the selected datasets
}
\description{
Title
Compares the essential metadata information of 2 or more SE objects
including radiation type, dose, time point, etc.
}
\examples{
get_radiation_data()
compare_datasets()
}
