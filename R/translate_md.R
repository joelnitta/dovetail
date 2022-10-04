#' Translate a single (R)Markdown file using a PO file
#'
#' This calls `md2po` from Docker,
#' and therefore requires Docker to be installed and running.
#'
#' @inheritParams md2po
#' @inheritParams po2md
#' @param quiet Logical; should messages from this function be suppressed?
#'
#' @return Nothing; externally, the markdown file will be translated to
#' `md_out`.
#' @export
#'
#' @examples
#' \dontrun{
#' # This example assumes the command is being run from the root of a
#' # carpentries lesson.
#'   translate_md(
#'     md_in = "episodes/01-introduction.Rmd",
#'     po = "po/01-introduction.ja.po",
#'     md_out = "locale/ja/episodes/01-introduction.Rmd"
#'   )
#' }
translate_md <- function(
  md_in, po, md_out,
  other_args = NULL, quiet = FALSE) {

  temp_md <- tempfile()

  if (!quiet) message(glue::glue("Translating {md_in}"))

  po2md(
    md_in = md_in, po = po, md_out = temp_md,
    other_args = other_args
  )

  fs::file_delete(temp_md)

}
