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
  wrap_width = 0, other_args = NULL, quiet = FALSE) {

  temp_md <- tempfile()

  if (!quiet) message(glue::glue("Translating {md_in}"))

  po2md(
    md_in = md_in, po = po, md_out = temp_md,
    wrap_width = wrap_width,
    other_args = other_args
  )

  fix_yaml_header(
    md_in = temp_md, md_out = md_out)

  fs::file_delete(temp_md)

}
