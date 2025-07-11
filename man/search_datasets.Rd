% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search_datasets.R
\name{search_datasets}
\alias{search_datasets}
\title{Title}
\usage{
search_datasets(radiation_type = NULL, organism = NULL, exp_setting = NULL)
}
\arguments{
\item{radiation_type}{Character string (optional). Filter datasets by radiation type (e.g., "x-ray", "neutron").}

\item{organism}{Character string (optional). Filter by organism (e.g., "Homo sapiens").}

\item{exp_setting}{Character string (optional). Filter by experimental setting (e.g., "in vivo", "ex vivo").}
}
\value{
a character string of the name of the se objects matching the inclusion criteria. If none match, returns an empty vector with a message.
}
\description{
Title
}
\examples{
search_datasets()

}
