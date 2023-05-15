#' Create all PO files needed for a given locale
#'
#' This will create a folder called `po/{lang}`, where `{lang}` is provided via
#' the `lang` argument and populate it with all PO files needed to translate
#' into that language.
#'
#' @inheritParams create_locale
#' @inheritParams md2po
#' @autoglobal
#' @return Nothing; externally, one or more PO files will be written to
#' `./po/{lang}`.
#' @export
#' @examples
#' \dontrun{
#' # This example assumes the command is being run from the root of a
#' # carpentries lesson.
#' create_po_for_locale("ja")
#' }
create_po_for_locale <- function(
  lang,
  container_id = auto_choose_docker()
  ) {

  assertthat::assert_that(
    assertthat::is.string(lang)
  )

  assertthat::assert_that(
    assertthat::is.string(container_id)
  )

  po_lang_dir <- glue::glue("po/{lang}")

  # List all md files, use this to format paths
  # for writing PO files
  file_paths <-
    find_md_files() %>%
    dplyr::mutate(
      po_file = paste0(md_name, ".po"),
      po_path = fs::path(po_lang_dir, po_file)
    )

  # Create po/{lang} dir (ignored if already exists)
  fs::dir_create(po_lang_dir)

  # Write PO files to po/{lang} dir
  purrr::walk2(
    .x = file_paths$md_path,
    .y = file_paths$po_path,
    ~md2po(.x, .y, container_id = container_id)
  )

}
