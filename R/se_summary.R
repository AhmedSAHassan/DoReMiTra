
#'Summarize Metadata for a DoReMiTra Dataset
#'
#' @param dataset_name Character string specifying the name of the dataset
#'
#' @returns A character string containing a essential information about the dataset metadata
#'
#' @export
#'
#' @examples
#' se_name()
#' se_summary()
se_summary <- function(dataset_name) {
  if (missing(dataset_name) || !is.character(dataset_name)) {
    stop("Please provide the dataset name as a character string.")
  }

  # Load metadata table
  metadata <- list_datasets()

  if (!(dataset_name %in% metadata$Dataset)) {
    stop("Dataset name '", dataset_name, "' not found in metadata.")
  }

  # Extract row for this dataset

  meta_row <- metadata[metadata$Dataset == dataset_name, ]

  # Load SummarizedExperiment object to get the number of samples included

  se <- get_radiation_data(dataset_name)
  metadata_file <- read.csv(system.file("extdata", "metadata-DoReMiTra.csv", package = "DoReMiTra"))

  n_samples <- ncol(se)
  species <- meta_row$Organism
  radiation <- meta_row$RadiationType
  setting <- meta_row$ExpSetting
  accession <- metadata_file[metadata_file$Title == dataset_name, "Accession"]
  link <- metadata_file[metadata_file$Title == dataset_name, "SourceUrl"]


print(glue::glue(
    "\nDataset: {dataset_name}
    Organism(s): {species}
    Radiation Type: {radiation}
    Experiment Setting: {setting}
    Number of Samples: {n_samples}
    Accession: {accession}
    For more information about this study, please check {link}\n"
  ))
  # Return invisibly

  invisible(
    list(
      name = dataset_name,
      organism = species,
      radiation_type = radiation,
      exp_setting = setting,
      accession = accession,
      n_samples = n_samples,
      link = meta_row$SourceUrl
    )
  )
}
