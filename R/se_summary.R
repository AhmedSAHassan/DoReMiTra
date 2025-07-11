
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

  if (!(dataset_name %in% metadata$DatasetName)) {
    stop("Dataset name '", dataset_name, "' not found in metadata.")
  }

  # Extract row for this dataset

  meta_row <- metadata[metadata$DatasetName == dataset_name, ]

  # Load SummarizedExperiment object to get the number of samples included

  se <- get_dataset(dataset_name)
  metadata_file <- system.file("extdata", "metadata-DoReMiTra.csv", package = "DoReMiTra")

  n_samples <- ncol(se)
  species <- meta_row$Organism
  radiation <- meta_row$Radiation_type
  setting <- meta_row$Exp_setting
  accession <- metadata_file$Accession
  link <- metadata_file$SourceUrl

  message(glue::glue(
    "\n Dataset: {dataset_name}",
    "\n Organism(s): {species}",
    "\n️  Radiation Type: {radiation}",
    "\n Experiment Setting: {setting}",
    "\n Number of Samples: {n_samples}",
    "\n GEO Accession: {accession}",
    "\n for more information about this study, please check {link}"
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
      link <- meta_row$SourceUrl
    )
  )
}
