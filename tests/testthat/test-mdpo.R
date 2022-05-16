test_that("PO file is generated", {
  expect_snapshot_file(
    md2po(
      system.file("extdata", "test_small.md", package = "dovetail"),
      po = "test_small.po",
      other_args = "--nolocation"
    ),
    "test_small.po"
  )
})
