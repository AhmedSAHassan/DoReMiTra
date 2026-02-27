#' List available metadata fields and their values in DoReMiTra
#'
#' This function displays the available metadata fields across all
#' DoReMiTra datasets along with the unique values observed for each field.
#' It facilitates intuitive dataset discovery and filtering.
#'
#' @return Invisibly returns a named list of metadata fields and their values.
#' @export
#' @examples
#' list_DoReMiTra_metadata_fields()
#'
list_DoReMiTra_metadata_fields <- function() {

  df <- list_DoReMiTra_datasets()

  # Remove Dataset column (identifier, not metadata field)
  df_metadata <- df[, setdiff(colnames(df), "Dataset"), drop = FALSE]

  metadata_values <- lapply(df_metadata, function(x) {
    sort(unique(as.character(x)))
  })

  message("Available metadata fields:\n")

  for (field in names(metadata_values)) {
    values <- paste(metadata_values[[field]], collapse = ", ")
    message(paste0("- ", field, ": ", values, "\n"))
  }

#  invisible(metadata_values)
}
