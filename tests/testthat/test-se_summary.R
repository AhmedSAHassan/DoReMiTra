test_that("summarize_DoReMiTra_se rejects non-SummarizedExperiment", {
  expect_error(summarize_DoReMiTra_se("not_se"))

  se <- get_DoReMiTra_data("SE_Amundson_2008_ExVivo_GSE8917_GPL1708")
  expect_output(summarize_DoReMiTra_se(se))

  se_strippedawaymeta <- se
  metadata(se_strippedawaymeta)[["DoReMiTra"]][["Radiation"]] <- NULL
  expect_error(
    summarize_DoReMiTra_se(se_strippedawaymeta)
  )

  se_empty <- SummarizedExperiment()
  expect_error(
    summarize_DoReMiTra_se(se_empty)
  )
})
