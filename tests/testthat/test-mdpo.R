# Pre-work: need to exclude header from PO file before testing snapshot,
# since it includes a time-stamp

temp_po <- fs::path(tempdir(), "test.po")

po4a_container <- ifelse(
  grepl("arm64", Sys.info()[["machine"]]),
  "joelnitta/po4a-arm64:latest",
  "joelnitta/po4a:latest"
  )

test_that("PO file is generated", {
  # Run arm64 version of po4a on arm64 machines,
  # default otherwise
  md2po(
    system.file("extdata", "test.Rmd", package = "dovetail"),
    po = temp_po,
    container_id = po4a_container
  )
  exclude_header(temp_po)
  expect_snapshot_file(
    temp_po,
    "test.po"
  )
})


# Cleanup
fs::file_delete(temp_po)
