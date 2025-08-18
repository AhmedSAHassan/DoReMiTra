test_that("get_DoReMiTra_data returns a SummarizedExperiment", {
  se <- get_DoReMiTra_data("SE_Salah_2025_ExVivo") # replace with a real dataset in your hub

  expect_s4_class(se, "SummarizedExperiment")
})

test_that("invalid dataset_name throws error", {
  expect_error(get_DoReMiTra_data("nonexistent_dataset"))
})
