#' Render a translated lesson
#'
#' Render a translation of a Carpentries lesson built with
#' [sandpaper](https://github.com/carpentries/sandpaper).
#' This requires that the lesson repo have a translation branch containing
#' translated files (typically maintained via Crowdin).
#'
#' The translated files should be located in a `./locale/<LANG_CODE>/`
#' hierarchy, for example:
#'
#' ```
#' .
#' └── locale
#'     ├── es
#'     │   ├── README.md
#'     │   ├── episodes/
#' ...
#' ```
#'
#' where `README.md` and the content of `episodes/` are translated files in the
#' target language (here, Spanish, as indicated by the language code `es`).
#' The `locale/` directory must exist either on the main branch or the
#' translation branch.
#'
#' To translate from a translation branch that is already present locally,
#' without pulling from the remote, set `clean` to `FALSE`.
#'
#' To translate from the current branch that contains a `locale/` directory
#' without pulling from the remote, set `l10n_branch` to `NULL`.
#'
#' @param lesson_dir Path to the lesson directory. Default: current working
#' directory.
#' @param l10n_branch Name of branch with translated files
#' (the "translation branch").
#' @param main_branch Name of main branch (with files in the source language).
#' @param lang Language code.
#' @param clean Logical; should any existing local translation branch
#' be deleted before and after rendering? If `TRUE`, a fresh copy of the
#' translation branch will be checked out from the remote. If `FALSE`, the
#' existing local translation branch will be used. Default: `TRUE`.
#' @param preview Logical; should the translated webpage be opened in a
#' browser window? Default: `TRUE`.
#' @param include_glob Character; only files with names matching one or more
#' strings in this character vector will be translated. Use to limit the
#' files for translation. Default: `NULL` (all files with translations
#' available will be translated).
#'
#' @return Nothing. This is typically called for its side-effect of rendering
#' a translated webpage. The webpage will be written to the `site` folder of
#' the lesson.
#' @export
render_trans <- function(
    lesson_dir = ".",
    l10n_branch = "l10n_main",
    main_branch = "main",
    lang,
    clean = TRUE,
    preview = TRUE,
    include_glob = NULL) {
  # Checks ---
  # - basic checks
  assertthat::assert_that(
    assertthat::is.string(lang)
  )
  assertthat::assert_that(
    assertthat::is.flag(clean)
  )
  assertthat::assert_that(
    assertthat::is.flag(preview)
  )
  # - lesson_dir is folder
  assertthat::assert_that(
    fs::dir_exists(lesson_dir),
    msg = sprintf(
      "No folder exists at 'lesson_dir' %s",
      lesson_dir
    )
  )
  # - lesson_dir is git repo
  assertthat::assert_that(
    tryCatch(
      is.list(gert::git_info(lesson_dir)),
      error = function(e) FALSE
    ),
    msg = sprintf(
        "'lesson_dir' %s does not appear to be a git repository",
        lesson_dir
      )
  )
  # - lesson_dir git status is clean
  status <- gert::git_status(repo = lesson_dir)
  assertthat::assert_that(
    nrow(status) == 0,
    msg = "Git status of lesson repo is not clean"
  )
  # - l10n_branch in remote or local
  remote_branches <- gert::git_branch_list(local = FALSE, repo = lesson_dir)
  local_branches <- gert::git_branch_list(local = TRUE, repo = lesson_dir)
  if (clean && !is.null(l10n_branch)) {
    assertthat::assert_that(
      any(grepl(l10n_branch, remote_branches$name, fixed = TRUE)),
      msg = sprintf(
        "'%s' not detected in branches of remote lesson repo",
        l10n_branch
      )
    )
  } else if (!is.null(l10n_branch)) {
    assertthat::assert_that(
      any(grepl(l10n_branch, local_branches$name, fixed = TRUE)),
      msg = sprintf(
        "'%s' not detected in branches of local lesson repo",
        l10n_branch
      )
    )
  }
  # - main branch in local
  assertthat::assert_that(
    main_branch %in% local_branches$name,
    msg = sprintf(
      "'%s' not detected in branches of local lesson repo",
      main_branch
    )
  )

  # Copy translated lesson into a temporary folder
  temp_dir <- make_translated_dir(
    translated_dir = NULL,
    overwrite = TRUE,
    lesson_dir = lesson_dir,
    l10n_branch = l10n_branch,
    main_branch = main_branch,
    lang = lang,
    clean = clean,
    include_glob = include_glob
  )

  # render lesson
  withr::with_dir(
    temp_dir,
    sandpaper::build_lesson(preview = FALSE)
  )

  # copy rendered lesson into local site folder
  fs::dir_copy(
    fs::path(temp_dir, "site"),
    fs::path(lesson_dir, "site"),
    overwrite = TRUE
  )

  # cleanup
  fs::dir_delete(temp_dir)

  gert::git_branch_checkout(
    branch = main_branch,
    repo = lesson_dir
  )

  if (clean &&
      gert::git_branch_exists(branch = l10n_branch, repo = lesson_dir)) {
    gert::git_branch_delete(
      branch = l10n_branch,
      repo = lesson_dir
    )
  }

  # optional preview
  if (preview) {
    utils::browseURL(
      url = fs::path(lesson_dir, "site", "docs", "index.html")
    )
  }

  invisible()
}
