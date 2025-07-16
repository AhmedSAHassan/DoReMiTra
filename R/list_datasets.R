
# generate a dataframe for the metadata of all the datasets


#' List Available DoReMiTra Datasets
#' Displays a summary of available datasets with key metadata fields.
#'
#' @returns A data.frame with metadata for each dataset
#' @export
#'
#' @examples
#' list_datasets()
#'
#'
list_datasets <- function() {
  eh <- ExperimentHub::ExperimentHub()
  res <- query(eh, "DoReMiTra")

  meta = read.csv(system.file("extdata", "metadata-DoReMiTra.csv", package = "DoReMiTra"))

  data.frame(
    Dataset = meta$Title,
    RadiationType = meta$Radiation_type,
    Organism = meta$Species,
    ExpSetting = meta$Exp_setting,
    Accession = meta$Accession,
    stringsAsFactors = FALSE
  )
}
