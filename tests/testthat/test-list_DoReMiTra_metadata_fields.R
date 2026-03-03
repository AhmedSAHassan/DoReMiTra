test_that("list_DoReMiTra_metadata_fields prints correct metadata fields", {

  # Mock dataset
  mock_df <- data.frame(
    Dataset = c("D1", "D2", "D3"),
    Radiation = c("Xray", "Gamma", "Xray"),
    Organism = c("Human", "Mouse", "Human"),
    stringsAsFactors = FALSE
  )

  # Temporarily mock list_DoReMiTra_datasets()
  with_mocked_bindings(
    list_DoReMiTra_datasets = function() mock_df,
    {

      output <- capture_messages(
        list_DoReMiTra_metadata_fields()
      )

      # Check field names appear
      expect_true(any(grepl("Radiation:", output)))
      expect_true(any(grepl("Organism:", output)))

      # Check values are unique and sorted
      expect_true(any(grepl("Gamma, Xray", output)))
      expect_true(any(grepl("Human, Mouse", output)))

      # Ensure Dataset column was excluded
      expect_false(any(grepl("Dataset:", output)))
    }
  )
})
