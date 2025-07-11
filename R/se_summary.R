
# summarize metadata for a DoReMiTra Dataset

se_summary <- function(name) {
  if (missing(name) || !is.character(name)) {
    stop("Please provide the dataset name as a character string.")
  }

  # Load metadata table
  metadata <- list_datasets()

  if (!(name %in% metadata$DatasetName)) {
    stop("Dataset name '", name, "' not found in metadata.")
  }

  # Extract row for this dataset

  meta_row <- metadata[metadata$DatasetName == name, ]

  # Load SummarizedExperiment object to get the number of samples included

  se <- get_dataset(name)
  metadata_file <- system.file("extdata", "metadata-DoReMiTra.csv", package = "DoReMiTra")

  n_samples <- ncol(se)
  species <- meta_row$Organism
  radiation <- meta_row$Radiation_type
  setting <- meta_row$Exp_setting
  accession <- metadata_file$Accession
  link <- metadata_file$SourceUrl

  message(glue::glue(
    "\n Dataset: {name}",
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
    name = name,
    organism = species,
    radiation_type = radiation,
    exp_setting = setting,
    accession = accession,
    n_samples = n_samples,
    link <- meta_row$SourceUrl
  ))
}
