.onLoad <- function(libname, pkgname) {
  fl <- system.file("extdata", "metadata.tsv", package = pkgname)
  if (file.exists(fl)) {
    titles <- utils::read.delim(fl, stringsAsFactors = FALSE)$Title
    ExperimentHub::createHubAccessors(pkgname, titles)
  }
}
