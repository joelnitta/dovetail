# Setup
temp_po <- fs::path(tempdir(), "test.po")

test_that("Removing header works", {
  md2po(
    system.file("extdata", "test.Rmd", package = "dovetail"),
    po = temp_po
  )
  exclude_header(temp_po)
  expect_snapshot_file(
    temp_po,
    "no_header.po"
  )
})

# Cleanup
fs::file_delete(temp_po)
