test_that("checks work", {
  expect_error(
    render_trans(lesson_dir = "most definitely not a folder", lang = "ja"),
    "No folder exists at"
  )
  temp_dir <- fs::dir_create((fs::path(tempdir(), "testing_dir")))
  expect_error(
    render_trans(lesson_dir = temp_dir, lang = "ja"),
    "does not appear to be a git repository"
  )
  fs::dir_delete(temp_dir)
})
