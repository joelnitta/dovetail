test_that("Fixing empty yaml headers works", {
  expect_snapshot_file(
    fix_yaml_header(
      md_in = system.file(
        "extdata", "test_bad_yml_header_1.md", package = "dovetail"),
      md_out = tempfile()
    ),
    "test_bad_yml_header_1_fixed.md"
  )
})
