
# fetching selected dataset

# here we can add the argument to assign the gene symbol to the rownames

get_radiation_data <- function(name) {
  if (missing(name) || !is.character(name)) {
    stop("Please provide a valid dataset name as a character string.")
  }

  eh <- ExperimentHub::ExperimentHub()
  query_results <- AnnotationHub::query(eh, "DoReMiTra")

  match_idx <- which(names(query_results) == name)

  if (length(match_idx) == 0) {
    stop("Dataset '", name, "' not found in DoReMiTra")
  }
  return(query_results[[match_idx]])
}
