
#' Translate a set of (R)Markdown files using PO files
#'
#' This calls `md2po` from Docker,
#' and therefore requires Docker to be installed and running.
#'
#' It also requires that a folder to write the translated (R)Markdown files
#' exists at `./locale/{lang}`, where `{lang}` matches that provided
#' by the `lang` argument.
#'
#' The easiest way to set this up is to use [create_locale()] first.
#'
#' It also requires that PO files are located in a folder like this:
#' ```
#' |--- po
#'      \---ja/
#'          |---01-introduction.po
#'          |---index.po
#'          ...
#' ```
#' Where `01-introduction.po` and `index.po` are PO files corresponding
#' to `01-introduction.md` and `index.md` in the original language.
#' The original md files must be located as specified by
#' [sandpaper](https://carpentries.github.io/sandpaper/),
#' and have unique file names.
#' Here, `ja` indicates that these PO files are for translating to Japanese.
#'
#' The easiest way to generate PO files meeting these requirements is to use
#' [create_po_for_locale()] first.
#'
#' @inheritParams create_locale
#' @autoglobal
#' @return Nothing; externally, translated (R)Markdown files will be written
#' to `./locale/{lang}`.
#' @export
#'
#' @examples
#' \dontrun{
#' # This example assumes the command is being run from the root of a
#' # carpentries lesson and that all PO files and the `locale/{lang}`
#' # folder has been set up.
#' translate_md_for_locale("ja")
#' }
translate_md_for_locale <- function(lang) {

  po_lang_dir <- glue::glue("po/{lang}")

  locale_lang_dir <- glue::glue("locale/{lang}")

  assertthat::assert_that(fs::dir_exists(po_lang_dir))
  assertthat::assert_that(fs::dir_exists(locale_lang_dir))

  # Make tibble of matching PO and md files
  file_paths <-
    tibble::tibble(
      po_file = list.files(
        path = po_lang_dir,
        full.names = TRUE,
        pattern = "\\.po$",
        ignore.case = TRUE,
        recursive = FALSE)
    ) %>%
    assertr::verify(
      nrow(.) > 0,
      error_fun = err_msg("No PO files found")
    ) %>%
    dplyr::mutate(
      md_name = fs::path_file(po_file) %>%
        fs::path_ext_remove()
    ) %>%
    dplyr::inner_join(
      find_md_files(),
      by = "md_name"
    ) %>%
    assertr::verify(
      nrow(.) > 0,
      error_fun = err_msg("No PO files and MD files match by file name")
    ) %>%
    dplyr::transmute(
      md_in = md_path,
      po = po_file,
      md_out = glue::glue("{locale_lang_dir}/{md_path}")
    )

  # Translate each MD file using its corresponding PO file and
  # write the translated MD file to `locale/{lang}/{md_path}`
  purrr::pwalk(
    file_paths,
    po2md
  )

}
