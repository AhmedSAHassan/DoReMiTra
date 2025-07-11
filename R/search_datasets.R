
# filters and output the name of the datasets that matches the inclusion criteria selected by the user

search_datasets <- function(radiation_type = NULL, organism = NULL, exp_setting = NULL) {
  all_data <- list_datasets()

  # Custom messages for missing arguments
  if (is.null(radiation_type)) {
    message("Radiation type not provided — searching across all radiation types.")
  } else {
    message("Filtering for radiation type: ", radiation_type)
  }

  if (is.null(organism)) {
    message("Organism not provided — searching across all species.")
  } else {
    message("Filtering for organism: ", organism)
  }

  if (is.null(exp_setting)) {
    message("Experimental setting not provided — searching across all settings (in vivo, ex vivo, etc.).")
  } else {
    message("Filtering for experimental setting: ", exp_setting)
  }

  filtered_data <- all_data

  if (!is.null(radiation_type)) {
    filtered_data <- filtered_data[grepl(radiation_type, filtered_data$RadiationType, ignore.case = TRUE), ]
  }
  if (!is.null(organism)) {
    filtered_data <- filtered_data[grepl(organism, filtered_data$Organism, ignore.case = TRUE), ]
  }
  if (!is.null(exp_setting)) {
    filtered_data <- filtered_data[grepl(exp_setting, filtered_data$ExpSetting, ignore.case = TRUE), ]
  }

  if (nrow(filtered_data) == 0) {
    message("⚠️ No datasets found matching the provided filters.")
    return(character(0))
  }

  return(unique(filtered_data$Dataset))
}




get_DoReMiTra_datasets_info <- function() {

}
