
#' Fetch all datasets from the DoReMiTra collection
#'
#' Retrieves all datasets available in the DoReMiTra package from ExperimentHub
#' and returns them as a named list of `SummarizedExperiment` objects. This is
#' useful for batch processing or exploring all curated radiation response datasets
#' at once.
#'
#' @param verbose Logical. Whether to print progress messages. Default is TRUE.
#'
#' @returns
#' A list storing all the SE objects
#' @export
#'
#' @examples
#' fetch_all_DoReMiTra()
#'
fetch_all_DoReMiTra <- function(verbose = TRUE) {
  # Retrieve all dataset names from metadata
  dataset_names <- list_DoReMiTra_datasets()$Dataset

  out_list <- list()

  for (name in dataset_names) {
    if (verbose) message(" Loading dataset: ", name)

    # Fetch dataset with metadata using your custom function
    se <- get_DoReMiTra_data(name)

    # Add to the named list
    out_list[[name]] <- se
  }

  return(out_list)
}
