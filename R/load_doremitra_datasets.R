
#' Title
#'
#' @param verbose
#'
#' @returns
#' all SummarizedExperiment objects and stores them in the global environment
#' @export
#'
#' @examples
#' load_doremitra_datasets()
#'
load_doremitra_datasets <- function(verbose = TRUE) {
  eh <- ExperimentHub::ExperimentHub()
  query_results <- query(eh, "DoReMiTra")

  if (length(query_results) == 0) {
    stop("No datasets found in ExperimentHub under 'DoReMiTra'.")
  }

  for (i in seq_along(query_results)) {
    dataset_name <- query_results$title[i]

    if (verbose) message("Loading dataset: ", dataset_name)

    se_obj <- query_results[[i]]

    # Assign to global environment
    assign(dataset_name, se_obj, envir = .GlobalEnv)
  }

  invisible(NULL)
}
