test_that("get_DoReMiTra_data returns a SummarizedExperiment", {
  se <- get_DoReMiTra_data("SE_Salah_2025_ExVivo") # replace with a real dataset in your hub

  expect_s4_class(se, "SummarizedExperiment")

  se_withgenesymbols <- get_DoReMiTra_data("SE_Amundson_2008_ExVivo_GSE8917_GPL1708", gene_symbol = TRUE)
  expect_s4_class(se_withgenesymbols, "SummarizedExperiment")
})

test_that("invalid dataset_name throws error", {
  expect_error(get_DoReMiTra_data("nonexistent_dataset"))
  expect_error(get_DoReMiTra_data(TRUE))
})
