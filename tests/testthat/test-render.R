test_that("checks work", {
  expect_error(
    render_trans_from_branch(
      lesson_dir = "most definitely not a folder", lang = "ja"),
    "No folder exists at"
  )
  expect_error(
    render_trans_from_dir(
      lesson_dir = "most definitely not a folder", lang = "ja"),
    "No folder exists at"
  )
  temp_dir <- fs::dir_create((fs::path(tempdir(), "testing_dir")))
  expect_error(
    render_trans_from_branch(lesson_dir = temp_dir, lang = "ja"),
    "does not appear to be a git repository"
  )
  fs::dir_delete(temp_dir)
})

test_that("translation works with l10n branch", {
  lesson_dir <- paste0(tempdir(), "/dovetail-", Sys.Date())
  if (fs::dir_exists(lesson_dir)) {
    fs::dir_delete(lesson_dir)
  }
  fs::dir_create(lesson_dir)
  temp_lesson <- sandpaper::create_lesson(
    lesson_dir,
    rmd = FALSE,
    rstudio = FALSE,
    open = FALSE
  )
  gert::git_branch_create(
    repo = temp_lesson,
    branch = "l10n_main"
  )
  gert::git_branch_checkout(
    repo = temp_lesson,
    branch = "l10n_main"
  )
  fs::dir_create(
    fs::path(lesson_dir, "locale", "ja", "episodes")
  )
  fs::file_copy(
    system.file("extdata", "intro-ja.md", package = "dovetail"),
    fs::path(lesson_dir, "locale", "ja", "episodes", "introduction.md")
  )
  gert::git_add(
    fs::path("locale", "ja", "episodes", "introduction.md"),
    repo = temp_lesson
  )
  gert::git_commit(
    "Add translation",
    repo = temp_lesson
  )
  gert::git_branch_checkout(
    repo = temp_lesson,
    branch = "main"
  )
  # If this test fails, be sure to check the full website by setting to TRUE
  check_website <- FALSE
  render_trans_from_branch(
    lesson_dir = temp_lesson,
    lang = "ja",
    clean = FALSE,
    preview = check_website
  )
  # Cannot snapshot entire introduction.html file because some HTML
  # changes slightly with each render
  # Instead just snapshot keypoints contents
  introduction <- fs::path(temp_lesson, "site", "docs", "introduction.html")
  introduction <- xml2::read_html(introduction)
  keypoints_contents <- introduction |>
    sandpaper:::get_content(".//div[contains(@class, 'keypoints')]") |>
    as.character()
  expect_snapshot(keypoints_contents)
  if (!check_website) {
    fs::dir_delete(temp_lesson)
  }
})

test_that("translation works with locale dir", {
  lesson_dir <- paste0(tempdir(), "/dovetail-", Sys.Date())
  if (fs::dir_exists(lesson_dir)) {
    fs::dir_delete(lesson_dir)
  }
  fs::dir_create(lesson_dir)
  temp_lesson <- sandpaper::create_lesson(
    lesson_dir,
    rmd = FALSE,
    rstudio = FALSE,
    open = FALSE
  )
  fs::dir_create(
    fs::path(lesson_dir, "locale", "ja", "episodes")
  )
  fs::file_copy(
    system.file("extdata", "intro-ja.md", package = "dovetail"),
    fs::path(lesson_dir, "locale", "ja", "episodes", "introduction.md")
  )
  gert::git_add(
    fs::path("locale", "ja", "episodes", "introduction.md"),
    repo = temp_lesson
  )
  gert::git_commit(
    "Add translation",
    repo = temp_lesson
  )
  # If this test fails, be sure to check the full website by setting to TRUE
  check_website <- FALSE
  render_trans_from_dir(
    lesson_dir = temp_lesson,
    lang = "ja",
    preview = check_website
  )
  # Cannot snapshot entire introduction.html file because some HTML
  # changes slightly with each render
  # Instead just snapshot keypoints contents
  introduction <- fs::path(temp_lesson, "site", "docs", "introduction.html")
  introduction <- xml2::read_html(introduction)
  keypoints_contents <- introduction |>
    sandpaper:::get_content(".//div[contains(@class, 'keypoints')]") |>
    as.character()
  expect_snapshot(keypoints_contents)
  if (!check_website) {
    fs::dir_delete(temp_lesson)
  }
})
