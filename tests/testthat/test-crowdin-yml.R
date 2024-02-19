# setup
temp_lesson_dir <- fs::path(tempdir(), "dovetail")
if (fs::dir_exists(temp_lesson_dir)) fs::dir_delete(temp_lesson_dir)
fs::dir_create(temp_lesson_dir)

# tests
test_that("writing crowdin yml works", {
  withr::with_tempdir({
    crowdin_yml_res <- use_crowdin_yml()
    },
    tmpdir = temp_lesson_dir,
    clean = FALSE)
  crowdin_yml_lines_dovetail <- readLines(
    system.file("extdata", "crowdin.yml", package = "dovetail")
  )
  expect_equal(
    crowdin_yml_lines_dovetail,
    readLines(crowdin_yml_res)
  )
})

test_that("overwrite works", {
  expect_error(
    withr::with_tempdir({
      crowdin_yml_res <- use_crowdin_yml()
      crowdin_yml_res <- use_crowdin_yml(overwrite = FALSE)
    },
    tmpdir = temp_lesson_dir,
    clean = FALSE)
  )
})

# cleanup
if (fs::dir_exists(temp_lesson_dir)) fs::dir_delete(temp_lesson_dir)