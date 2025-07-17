# fetching selected dataset

# here we can add the argument to assign the gene symbol to the rownames

#' Title
#'
#' @param dataset_name Character. The exact name of the dataset (e.g. "SE_Amundson_2008_ExVivo_GSE8917_GPL1708").

#'
#' @returns A `SummarizedExperiment` object fetched from ExperimentHub.
#' @export
#'
#' @examples
#' get_radiation_data()
#'
get_radiation_data <- function(dataset_name) {
  if (missing(dataset_name) || !is.character(dataset_name)) {
    stop("Please provide a valid dataset name as a character string.")
  }

  eh <- ExperimentHub::ExperimentHub()
  query_results <- query(eh, "DoReMiTra")

  match_idx <- which(query_results$title == dataset_name)

  if (length(match_idx) == 0) {
    stop("Dataset '", dataset_name, "' not found in DoReMiTra")
  }

  # Assign to global environment

  se_obj <- query_results[[match_idx]]

  assign(dataset_name, se_obj, envir = .GlobalEnv)
}


# fetching selected dataset






get_DoReMiTra_datasets_info <- function() {

}

# here we can add the argument to assign the gene symbol to the rownames


