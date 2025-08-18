test_that("search_DoReMiTra_datasets filters correctly", {

  datasets_list<- list_DoReMiTra_datasets()


      # Filter by radiation type
      res <- search_DoReMiTra_datasets(radiation_type = "X-ray")
      expect_identical(res, datasets_list$Dataset[grepl("X-ray", datasets_list$RadiationType, ignore.case = TRUE)])

      # Filter by organism
      res <- search_DoReMiTra_datasets(organism = "Mus musculus")
      expect_identical(res, datasets_list$Dataset[grepl("Mus musculus", datasets_list$Organism, ignore.case = TRUE)])

      # Filter by exp setting
      res <- search_DoReMiTra_datasets(exp_setting = "InVivo")
      expect_identical(res, datasets_list$Dataset[grepl("InVivo", datasets_list$ExpSetting, ignore.case = TRUE)])

      # Combination filter
      res <- search_DoReMiTra_datasets(radiation_type = "X-ray", organism = "Homo sapiens")
      expect_identical(res, datasets_list$Dataset[grepl("X-ray", datasets_list$RadiationType, ignore.case = TRUE) & grepl("Homo sapiens", datasets_list$Organism, ignore.case = TRUE)])

      # No match
      res <- search_DoReMiTra_datasets(radiation_type = "protons")
      expect_equal(res, character(0))
}
  )


test_that("search_DoReMiTra_datasets returns all datasets when no filters applied", {

  datasets_list<- list_DoReMiTra_datasets()

      res <- search_DoReMiTra_datasets()
      expect_equal(res, datasets_list$Dataset)
    }
  )
