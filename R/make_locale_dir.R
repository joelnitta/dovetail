#' Create a lesson directory with translated materials
#'
#' @inheritParams render_trans
#' @param translated_dir Path to create lesson directory with translated
#' materials. If NULL, a directory will be created.
#' @param overwrite Logical; is it OK to overwrite any existing contents of
#' translated_dir?
#' @param include_glob Character; only files with names matching one or more
#' strings in this character vector will be translated. Use to limit the
#' files for translation. Default: `NULL` (all files with translations
#' available will be translated).
#'
#' @return Path to the lesson directory with translated materials
#' @noRd
make_translated_dir <- function(
  translated_dir = NULL,
  overwrite = FALSE,
  lesson_dir = ".",
  l10n_branch = "l10n_main",
  main_branch = "main",
  locale_dir = "locale",
  lang,
  clean = TRUE,
  include_glob = NULL
) {

  if (is.null(translated_dir)) {
  # Specify temp dir for writing lesson
  temp_dir <- fs::path(
    tempdir(),
    # Name folder with random string
    digest::digest(Sys.time())
  )
  } else if (fs::dir_exists(translated_dir) && !overwrite) {
    stop(
      sprintf(
        "'translated_dir' %s exists and `overwrite` is `FALSE`",
        translated_dir
      )
    )
  } else {
    temp_dir <- translated_dir
  }

  if (fs::dir_exists(temp_dir)) {
    fs::dir_delete(temp_dir)
  }

  fs::dir_create(temp_dir)

  # Copy source lang files to temp dir
  system2(
    "rsync",
    c(
      "-rl",
      # need trailing slash to copy *contents* of folders
      paste0(fs::path_abs(lesson_dir), "/"),
      paste0(fs::path_abs(temp_dir), "/")
    )
  )

  # Clean start: delete existing l10n branch (so we can check it out fresh)
  if (
    clean &&
      gert::git_branch_exists(branch = l10n_branch, repo = lesson_dir) &&
      !is.null(l10n_branch)
      ) {
    gert::git_branch_checkout(
      branch = main_branch,
      repo = lesson_dir
    )
    gert::git_branch_delete(
      branch = l10n_branch,
      repo = lesson_dir
    )
  }

  # Checkout l10n branch from remote
  if (!is.null(l10n_branch)) {
    gert::git_branch_checkout(
      branch = l10n_branch,
      repo = lesson_dir
    )
  }

  # Specify dir with translated lesson
  lesson_lang_dir <- fs::path(lesson_dir, locale_dir, lang)

  assertthat::assert_that(
    fs::dir_exists(lesson_lang_dir),
    msg = sprintf(
      "Is 'lang' correct? No folder detected at '%s'",
      lesson_lang_dir
    )
  )

  include_args <- NULL
  if (!is.null(include_glob)) {
    assertthat::assert_that(is.character(include_glob))
    include_args <- c(
      "--include='*/'",
      paste0("--include='", include_glob, "'"),
      "--exclude='*'"
    )
  }

  system2(
    "rsync",
    c(
      "-rl",
      include_args,
      # need trailing slash to copy *contents* of folders
      paste0(fs::path_abs(lesson_lang_dir), "/"),
      paste0(fs::path_abs(temp_dir), "/")
    )
  )

  temp_dir
}