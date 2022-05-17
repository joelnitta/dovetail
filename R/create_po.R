#' Create a single PO file for translating a (R)markdown file
#'
#' Any folders that don't yet exist for the output path specified will be
#' automatically created.
#'
#' @inheritParams md2po
#' @param include_codeblocks Logical vector of length 1; should code blocks
#' be included in the PO file? Default `TRUE`.
#'
#' @return List with components formatted like the output of [processx::run()].
#' Externally, the PO file will be generated at the path specified by `po`.
#' @export
#'
#' @examples
#' # Write a PO file based on the example MD file in this package
#' # to a temporary file, check the first few lines, then delete it
#' temp_po <- tempfile(fileext = "po")
#' create_po(
#'   md_in = system.file("extdata", "test.Rmd", package = "dovetail"),
#'   po = temp_po,
#'   other_args = "--nolocation"
#' )
#' head(readLines(temp_po))
#' unlink(temp_po)
#'
create_po <- function(
    md_in, po, wrap_width = 0,
    include_codeblocks = TRUE,
    other_args = NULL) {

  # Get path to output file
  po_path <- fs::path_dir(po)
  # Create output directory structure if it doesn't yet exist
  fs::dir_create(po_path)

  # Pre-process MD for creating PO
  temp_md <- tempfile()

  # Exclude fences
  md_lines <- readr::read_lines(md_in)
  md_lines <- exclude_fences(md_lines)
  readr::write_lines(md_lines, temp_md)

  # Format arguments
  codeblocks_arg <- NULL
  if (isTRUE(include_codeblocks)) codeblocks_arg <- "-c"
  other_args <- c(codeblocks_arg, other_args)

  # Make PO
  md2po(
    md_in = temp_md, po = po,
    wrap_width = wrap_width,
    other_args = other_args
  )

  # Delete temp file
  fs::file_delete(temp_md)

}
