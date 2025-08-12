
#' Compare two or more dataset from the DoReMiTra collection
#'
#'This function compares the essential metadata information of 2 or more SE objects
#' including radiation type, dose, time point, etc.
#'

#' @param fields a character vector of the main metadata info
#' @param se_list names of the se objects to be compared
#'
#' @returns a dataframe comparing the metadata of the selected datasets
#'
#' @export
#'
#' @importFrom SummarizedExperiment colData
#' @examples
#' se1 <- get_DoReMiTra_data("SE_Paul_2010_InVivo_GSE23393_GPL6480")
#' se2 <- get_DoReMiTra_data("SE_Amundson_2011_InVivo_GSE20162_GPL6480")
#'se_list<- list(Amundson = se1, Paul= se2)
#'compare_DoReMiTra_datasets(se_list = se_list)
#'

compare_DoReMiTra_datasets <- function(se_list, fields = c("Radiation_type", "Dose", "Sex", "Time_point", "Organism")) {
  # Check input is a list

  if (!is.list(se_list)) {
    stop("You should provide a list of SummarizedExperiment objects.", call. = FALSE)
  }

  # Check at least 2 SE objects

  if (length(se_list) < 2) {
    stop("The list should contain at least 2 SummarizedExperiment objects.", call. = FALSE)
  }

  # Check all elements are SummarizedExperiment objects

  if (!all(vapply(se_list, function(x) inherits(x, "SummarizedExperiment"), logical(1)))) {
    stop("The list does not contain only SummarizedExperiment objects.", call. = FALSE)
  }

  # Assign names if missing
  if (is.null(names(se_list))) {
    names(se_list) <- paste0("Dataset_", seq_along(se_list))
  }

  # Process each SE object
  results <- lapply(se_list, function(se) {
    coldata <- as.data.frame(colData(se))
    field_values <- sapply(fields, function(field) {
      if (field %in% colnames(coldata)) {
        vals <- unique(as.character(coldata[[field]]))
        paste(sort(vals), collapse = ", ")
      } else {
        NA_character_
      }
    })

    # Add number of samples
    c(field_values, Sample_number = as.character(ncol(se)))
  })

  # Combine into a data.frame
  df <- as.data.frame(do.call(cbind, results))
  rownames(df) <- c(fields, "Sample_number")
  return(df)
}
