test_that("list_DoReMiTra_datasets returns a data.frame with expected columns", {
  df <- list_DoReMiTra_datasets()

  expect_s3_class(df, "data.frame")
  expect_true(all(c("Dataset", "RadiationType", "Organism", "ExpSetting") %in% colnames(df)))
})
