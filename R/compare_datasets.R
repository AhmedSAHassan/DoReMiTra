

#' Title
#' Compares the essential metadata information of 2 or more SE objects
#' including radiation type, dose, time point, etc.
#'

#' @param fields a character vector of the main metadata info
#'
#' @returns a dataframe comparing the metadata of the selected datasets
#'
#' @export
#'
#' @examples
#' get_radiation_data()
#' compare_datasets()

compare_datasets <- function(..., fields = c("Radiation_type", "Dose", "Sex", "Time_point", "Organism")) {
  se_list <- list(...)

  se_names <- names(se_list)
  if (is.null(se_names)) {
    se_names <- sapply(substitute(list(...))[-1], deparse)
    names(se_list) <- se_names
  }

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
  colnames(df) <- se_names
  return(df)
}

