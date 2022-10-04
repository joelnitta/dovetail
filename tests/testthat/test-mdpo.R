# Pre-work: need to exclude header from PO file before testing snapshot,
# since it includes a time-stamp

temp_po <- fs::path(tempdir(), "test.po")
temp_md_trans <- fs::path(tempdir(), "test.ja.md")

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

test_that("Translation works", {
  expect_snapshot_file(
    po2md(
      md_in = system.file("extdata", "test.Rmd", package = "dovetail"),
      po = system.file("extdata", "test.ja.po", package = "dovetail"),
      md_out = temp_md_trans
    ),
    "test.ja.md"
  )
})

# Cleanup
fs::file_delete(temp_po)
fs::file_delete(temp_md_trans)
