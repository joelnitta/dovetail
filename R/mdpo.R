#' Create a PO file from an MD file
#'
#' This is a wrapper around the
#' [md2po](https://mdpo.readthedocs.io/en/master/cli.html#md2po)
#' command. It calls `md2po` from Docker,
#' and therefore requires Docker to be installed and running.
#'
#' @param md_in Character vector of length 1; path to existing MD file.
#' @param po Character vector of length 1; path to PO file to write.
#' @param wrap_width Integer vector of length 1; number of characters
#'   to wrap lines in PO file. `0` (default) indicates no wrapping.
#' @param other_args Character vector; other arguments used by
#'   [md2po](https://mdpo.readthedocs.io/en/master/cli.html#md2po).
#'   Must be formatted like the `args` command used by [processx::run()].
#'
#' @return Character vector of length 1; the path to the PO file specified by
#' `po`. Externally, the PO file will be generated at that path.
#' @export
#' @examples
#' # Write a PO file based on the example MD file in this package
#' # to a temporary file, check the first few lines, then delete it
#' temp_po <- tempfile(fileext = "po")
#' md2po(
#'   md_in = system.file("extdata", "test_small.md", package = "dovetail"),
#'   po = temp_po,
#'   other_args = "--nolocation"
#' )
#' head(readLines(temp_po))
#' unlink(temp_po)
#'
md2po <- function(
  md_in, po, wrap_width = 0, other_args = NULL) {
  assertthat::assert_that(assertthat::is.readable(md_in))
  assertthat::assert_that(assertthat::is.string(po))
  res <- run_auto_mount(
    container_id = "joelnitta/mdpo:latest",
    command = "md2po",
    args = c(
      file = md_in,
      "-po", file = po,
      "--wrapwidth", wrap_width,
      other_args
    )
  )
  readr::write_lines(res$stdout, po)
  po
}

#' Create a translated MD file from an input MD file and a PO file
#'
#' This is a wrapper around the
#' [po2md](https://mdpo.readthedocs.io/en/master/cli.html#po2md)
#' command. It calls `po2md` from Docker,
#' and therefore requires Docker to be installed and running.
#'
#' @inheritParams md2po
#' @param po Character vector of length 1; path to PO file to use for
#'   translation.
#' @param md_out Character vector of length 1; path to write translated MD file.
#' @param other_args Character vector; other arguments used by
#'   [po2md](https://mdpo.readthedocs.io/en/master/cli.html#po2m).
#'   Must be formatted like the `args` command used by [processx::run()].
#'
#' @return Character vector of length 1; the path to the translated MD file
#'   specified by `md_out`. Externally, the translated MD file will be generated
#'   at that path.
#' @export
#' @examples
#' # Translate an MD file using example MD and PO file with this package
#' # to a temporary file, check the first few lines, then delete it
#' temp_md <- tempfile(fileext = "md")
#' po2md(
#'   md_in = system.file("extdata", "test_small.md", package = "dovetail"),
#'   po = system.file("extdata", "test_small.ja.po", package = "dovetail"),
#'   md_out = temp_md
#' )
#' # first six lines of the original
#' head(readLines(
#'   system.file("extdata", "test_small.md", package = "dovetail")
#' ))
#' # first six lines of the translation
#' head(readLines(temp_md))
#' unlink(temp_md)
#'
po2md <- function(
  md_in, po, md_out,
  wrap_width = 0, other_args = NULL) {
  res <- run_auto_mount(
    container_id = "joelnitta/mdpo:latest",
    command = "po2md",
    args = c(
      file = md_in,
      "--pofiles", file = po,
      "--wrapwidth", wrap_width,
      other_args
    )
  )
  readr::write_lines(res$stdout, md_out)
  md_out
}
