compare_datasets <- function(..., fields = c("Radiation_type", "Dose", "Sex", "Time_point", "Organism")) {
  se_list <- list(...)

  se_names <- names(se_list)
  if (is.null(se_names)) {
    se_names <- sapply(substitute(list(...))[-1], deparse)
    names(se_list) <- se_names
  }

  results <- lapply(se_list, function(se) {
    coldata <- as.data.frame(colData(se))
    sapply(fields, function(field) {
      if (field %in% colnames(coldata)) {
        vals <- unique(as.character(coldata[[field]]))
        paste(sort(vals), collapse = ", ")
      } else {
        NA_character_
      }
    })
  })

  # Combine into a data.frame
  df <- as.data.frame(do.call(cbind, results))
  rownames(df) <- fields
  colnames(df) <- se_names
  return(df)
}
