
# generate a dataframe for the metadata of all the datasets

list_datasets <- function() {
  eh <- ExperimentHub::ExperimentHub()
  res <- ExperimentHub::query(eh, "DoReMiTra")

  meta <- S4Vectors::mcols(res)

  data.frame(
    Dataset = meta$Title,
    RadiationType = meta$Radiation_type,
    Organism = meta$Species,
    ExpSetting = meta$Exp_setting,
    Accession = meta$Accession,
    stringsAsFactors = FALSE
  )
}
