# fetching selected dataset

# here we can add the argument to assign the gene symbol to the rownames

#' Title
#'
#' @param dataset_name Character. The exact name of the dataset (e.g. "SE_Amundson_2008_ExVivo_GSE8917_GPL1708").

#'
#' @returns A `SummarizedExperiment` object fetched from ExperimentHub.
#' @export
#'
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom AnnotationHub query
#' @importFrom S4Vectors metadata<-
#' @importFrom S4Vectors metadata
#'
#' @examples
#' get_DoReMiTra_data("SE_Amundson_2008_ExVivo_GSE8917_GPL1708")
#'
get_DoReMiTra_data <- function(dataset_name) {
  if (missing(dataset_name) || !is.character(dataset_name)) {
    stop("Please provide a valid dataset name as a character string.")
  }

  eh <- ExperimentHub::ExperimentHub()
  query_results <- query(eh, "DoReMiTra")

  match_idx <- which(query_results$title == dataset_name)

  if (length(match_idx) == 0) {
    stop("Dataset '", dataset_name, "' not found in DoReMiTra")
  }


  all_info <- list_DoReMiTra_datasets(show_all_fields = TRUE)
  dataset_info <- all_info[all_info$Title == dataset_name,]

  out_se <- query_results[[match_idx]]

  metadata(out_se)[["DoReMiTra"]] <- list(
    Author = strsplit(dataset_name, "_")[[1]][2],
    Organism = dataset_info$Organism,
    Radiation = dataset_info$Radiation_type,
    nr_samples = ncol(out_se),
    Platform = unique(out_se$Platform),
    Setting = dataset_info$Exp_setting,
    Link = dataset_info$SourceUrl,
    Accession = dataset_info$Accession
  )


  return(out_se)
}






# here we can add the argument to assign the gene symbol to the rownames


