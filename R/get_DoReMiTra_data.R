
#' Fetch a selected dataset from the DoReMiTra collection
#'
#' This function fetches a `SummarizedExperiment` object from ExperimentHub
#' corresponding to a dataset in the DoReMiTra package.
#'
#' @param dataset_name Character. The exact name of the dataset (e.g. "SE_Amundson_2008_ExVivo_GSE8917_GPL1708").
#' @param gene_symbol Logical. default is FALSE. If TRUE, gene symbol will be assigned to rownames.
#' If some gene symbols were found to be duplicated, gene symbol and the corresponding probe id will be appended together.

#'
#' @returns A `SummarizedExperiment` object fetched from ExperimentHub.
#' @export
#'
#' @importFrom ExperimentHub ExperimentHub
#' @importFrom AnnotationHub query
#' @importFrom S4Vectors metadata<-
#' @importFrom S4Vectors metadata
#' @importFrom SummarizedExperiment rowData

#'
#' @examples
#' get_DoReMiTra_data("SE_Amundson_2008_ExVivo_GSE8917_GPL1708")
#'
get_DoReMiTra_data <- function(dataset_name, gene_symbol = FALSE) {
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

  # Add gene symbol if TRUE

  if (gene_symbol) {
    rd <- rowData(out_se)

    if (!"SYMBOL" %in% colnames(rd)) {
      warning("SYMBOL column not found in rowData, gene_symbol argument ignored.")
    } else {
      # Ensure character type for SYMBOL
      symbols <- as.character(rd$SYMBOL)
      probes <- rownames(out_se)

      # Use scater::uniquifyFeatureNames to make them unique
      new_rownames <- scater::uniquifyFeatureNames(ID = probes, names = symbols)

      rownames(out_se) <- new_rownames
    }
  }

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

