test_that("compare_DoReMiTra_datasets works with valid SE list", {

  se1 <- get_DoReMiTra_data("SE_Park_2017_ExVivo_GSE102971_GPL10332_HomoSapiens")
  se2 <- get_DoReMiTra_data("SE_Paul_2013_ExVivo_GSE44201_GPL6480")

  df <- compare_DoReMiTra_datasets(list(name1 = se1, name2 = se2))

  df_nonames <- compare_DoReMiTra_datasets(list(se1, se2))
  expect_equal(colnames(df_nonames), c("Dataset_1", "Dataset_2"))

  expect_s3_class(df, "data.frame")
  expect_true(all(c("name1", "name2") %in% colnames(df)))
  expect_true("Radiation_type" %in% rownames(df))
})

test_that("compare_DoReMiTra_datasets errors on wrong input", {
  expect_error(compare_DoReMiTra_datasets("not_a_list"))
  expect_error(compare_DoReMiTra_datasets(list("not_se")))
  expect_error(compare_DoReMiTra_datasets(list(se1)))

  expect_error(
    compare_DoReMiTra_datasets(
      list(
        se1 = se1,
        not_se = "something else")
    )
  )
})
