.onLoad <- function(libname, pkgname) {
  meta_path <- system.file("extdata", "metadata.csv", package = pkgname)
  if (file.exists(meta_path)) {
    titles <- utils::read.csv(meta_path, stringsAsFactors = FALSE)$Title
    ExperimentHub::createHubAccessors(pkgname, titles)
  }
}
