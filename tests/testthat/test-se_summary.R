test_that("summarize_DoReMiTra_se rejects non-SummarizedExperiment", {
  expect_error(DoReMiTra_se_summary("not_se"))
})
