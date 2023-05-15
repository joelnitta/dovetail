temp_md_trans <- fs::path(tempdir(), "test.ja.md")

po4a_container <- ifelse(
  grepl("arm64", Sys.info()[["machine"]]),
  "joelnitta/po4a-arm64:latest",
  "joelnitta/po4a:latest"
  )

test_that("Translation works", {
  # Run arm64 version of po4a on arm64 machines,
  # default otherwise
  expect_snapshot_file(
    po2md(
      md_in = system.file("extdata", "test.Rmd", package = "dovetail"),
      po = system.file("extdata", "test.ja.po", package = "dovetail"),
      md_out = temp_md_trans,
      container_id = po4a_container
    ),
    "test.ja.md"
  )
})

# Cleanup
fs::file_delete(temp_md_trans)
