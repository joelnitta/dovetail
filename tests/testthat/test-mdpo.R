# Pre-work: need to exclude header from PO file before testing snapshot,
# since it includes a time-stamp

temp_po <- fs::path(tempdir(), "test.po")

test_that("PO file is generated", {
  md2po(
    system.file("extdata", "test.Rmd", package = "dovetail"),
    po = temp_po
  )
  exclude_header(temp_po)
  expect_snapshot_file(
    temp_po,
    "test.po"
  )
})


# Cleanup
fs::file_delete(temp_po)
