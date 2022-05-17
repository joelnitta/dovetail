#' Create a single PO file for translating a (R)markdown file
#'
#' @inheritParams md2po
#'
#' @return List with components formatted like the output of [processx::run()].
#' Externally, the PO file will be generated at the path specified by `po`.
#' @export
#'
#' @examples
#' \dontrun{
#' # This example assumes the command is being run from the root of a
#' # carpentries lesson.
#' create_po("episodes/01-introduction.Rmd", "po/ja/01-introduction.po")
#' }
create_po <- function(md_in, po, wrap_width = 0, other_args = NULL) {

  # Create po dir
  fs::dir_create("po")

  # Pre-process MD for creating PO
  temp_md <- tempfile()

  # Exclude fences
  md_lines <- readr::read_lines(md_in)
  md_lines <- exclude_fences(md_lines)
  readr::write_lines(md_lines, temp_md)

  # Make PO
  md2po(
    md_in = temp_md, po = po,
    wrap_width = wrap_width,
    other_args = other_args
  )

  # Delete temp file
  fs::file_delete(temp_md)

}
