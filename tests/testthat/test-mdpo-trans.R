temp_md_trans <- fs::path(tempdir(), "test.ja.md")

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
fs::file_delete(temp_md_trans)
