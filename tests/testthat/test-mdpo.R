test_that("PO file is generated", {
  expect_snapshot_file(
    md2po(
      system.file("extdata", "test_small.md", package = "dovetail"),
      po = tempfile(),
      other_args = "--nolocation"
    ),
    "test_small.po"
  )
})

test_that("Translation works", {
  expect_snapshot_file(
    po2md(
      md_in = system.file("extdata", "test_small.md", package = "dovetail"),
      po = system.file("extdata", "test_small.ja.po", package = "dovetail"),
      md_out = tempfile()
    ),
    "test_small_ja.md"
  )
})
