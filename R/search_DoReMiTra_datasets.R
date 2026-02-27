
#' Search DoReMiTra datasets by metadata filters
#'
#' Filters the available DoReMiTra datasets using metadata fields such as
#' radiation type, organism, or experimental setting. This function helps narrow
#' down datasets of interest before fetching them.
#' @param radiation_type Character string (optional). Filter datasets by radiation type (e.g., "x-ray", "neutron").
#' @param organism Character string (optional). Filter by organism (e.g., "Homo sapiens").
#' @param exp_setting Character string (optional). Filter by experimental setting (e.g., "in vivo", "ex vivo").
#' @param author Character string (optional). Filter by the author name
#' @returns
#' a vector with the names of the se objects matching the inclusion criteria. If none match, returns an empty vector with a message.
#' @export
#'
#' @examples
#' search_DoReMiTra_datasets()
#'
search_DoReMiTra_datasets <- function(radiation_type = NULL,
                                      organism = NULL,
                                      exp_setting = NULL,
                                      author = NULL) {

  all_data <- list_DoReMiTra_datasets()

  # Custom messages for missing arguments
  if (is.null(radiation_type)) {
    message("Radiation type not provided - searching across all radiation types.")
  } else {
    message("Filtering for radiation type: ", radiation_type)
  }

  if (is.null(organism)) {
    message("Organism not provided - searching across all species.")
  } else {
    message("Filtering for organism: ", organism)
  }

  if (is.null(exp_setting)) {
    message("Experimental setting not provided - searching across all settings (in vivo, ex vivo, etc.).")
  } else {
    message("Filtering for experimental setting: ", exp_setting)
  }

  if (is.null(author)) {
    message("Author not provided - searching across all authors.")
  } else {
    message("Filtering for author: ", author)
  }

  filtered_data <- all_data

  if (!is.null(radiation_type)) {
    filtered_data <- filtered_data[
      grepl(radiation_type, filtered_data$RadiationType, ignore.case = TRUE), ]
  }

  if (!is.null(organism)) {
    filtered_data <- filtered_data[
      grepl(organism, filtered_data$Organism, ignore.case = TRUE), ]
  }

  if (!is.null(exp_setting)) {
    filtered_data <- filtered_data[
      grepl(exp_setting, filtered_data$ExpSetting, ignore.case = TRUE), ]
  }

  if (!is.null(author)) {
    filtered_data <- filtered_data[
      grepl(author, filtered_data$Author, ignore.case = TRUE), ]
  }


  if (nrow(filtered_data) == 0) {
    message("No datasets found matching the provided filters.:\nPlease check list_DoReMiTra_datasets() for a full view of the available datasets.")
    return(character(0))
  }

  dataset_names <- unique(filtered_data$Dataset)

  message("\nMatching datasets found: ", length(dataset_names))
  message("To retrieve one or more of these datasets, you can use:\n")

  for (i in seq_len(min(2, length(dataset_names)))) {
    message("se_name", i, " <- get_DoReMiTra_data(\"", dataset_names[i], "\")")
  }

  message("\nFor more details, please refer to `?get_DoReMiTra_data`")

  return(dataset_names)
}
