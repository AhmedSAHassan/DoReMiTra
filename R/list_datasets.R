
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
  res <- ExperimentHub::query(eh, "DoReMiTra")

  meta <- S4Vectors::mcols(res)

  data.frame(
    Dataset = meta$Title,
    RadiationType = meta$Radiation_type,
    Organism = meta$Species,
    ExpSetting = meta$Exp_setting,
    Accession = meta$Accession,
    stringsAsFactors = FALSE
  )
}
