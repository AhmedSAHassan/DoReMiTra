
#' List all available DoReMiTra datasets with associated key metadata information
#'
#' Returns a metadata dataframe of all datasets available in the DoReMiTra collection,
#' including details such as title, organism, radiation type, experimental setting,
#' and accession numbers. Can optionally display extended metadata fields.
#'
#' @param show_all_fields Logical. If TRUE, it returns all the metadata information
#' @returns A data.frame with metadata for each dataset
#' @export
#'
#' @importFrom utils read.csv
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom AnnotationHub query
#'
#' @examples
#' list_DoReMiTra_datasets()
#'
#'

list_DoReMiTra_datasets <- function(show_all_fields = FALSE) {

  meta <- read.csv(system.file("extdata", "metadata-DoReMiTra.csv", package = "DoReMiTra"))

  if (show_all_fields) {
    meta_df <- as.data.frame(meta)
    return (meta_df)
  } else {

    out_df <- data.frame(
      Dataset = meta$Title,
      RadiationType = meta$Radiation_type,
      Organism = meta$Species,
      ExpSetting = meta$Exp_setting,
      Accession = meta$Accession,
      Tissue = meta$Tissue,
      stringsAsFactors = FALSE
    )

    return(out_df)
  }

}

