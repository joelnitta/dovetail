#' Create a PO file from an MD file
#'
#' This is a wrapper around the
#' [po4a-updatepo](https://po4a.org/man/man1/po4a-updatepo.1.php)
#' command. It calls `po4a` from Docker,
#' and therefore requires Docker to be installed and running.
#'
#' To run on arm64 machines, use `container_id` joelnitta/po4a-arm64:latest.
#'
#' @param md_in Character vector of length 1; path to existing MD file.
#' @param po Character vector of length 1; path to PO file to write.
#' @param container_id Character vector of length 1;
#'   name of Docker container that includes po4a to run.
#' @param other_args Character vector; other arguments used by
#'   [po4a-updatepo](https://po4a.org/man/man1/po4a-updatepo.1.php).
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
#'   md_in = system.file("extdata", "test.Rmd", package = "dovetail"),
#'   po = temp_po
#' )
#' tail(readLines(temp_po))
#' unlink(temp_po)
#'
md2po <- function(
  md_in, po, container_id = "joelnitta/po4a:latest", other_args = NULL) {

  assertthat::assert_that(assertthat::is.readable(md_in))
  assertthat::assert_that(assertthat::is.string(po))
  assertthat::assert_that(assertthat::is.string(container_id))

  # Create output directory structure if it doesn't yet exist
  po_path <- fs::path_dir(po)
  fs::dir_create(po_path)

  # docker will write as root in some cases
  # to make sure po file has correct permissions,
  # read-in / write-out with R
  temp_file <- tempfile()

  if (fs::file_exists(po)) fs::file_copy(po, temp_file)

  run_auto_mount(
    container_id = container_id,
    command = "po4a-updatepo",
    args = c(
      "-f", "text",
      "-m", file = md_in,
      "-p", file = temp_file,
      c(
        "-o", "markdown",
        "--wrap-po", "newlines"
      ),
      other_args
    )
  )
  po_lines <- readr::read_lines(temp_file)
  readr::write_lines(po_lines, po)
  po
}

#' Create a translated MD file from an input MD file and a PO file
#'
#' This is a wrapper around the
#' [po2md](https://mdpo.readthedocs.io/en/master/cli.html#po2md)
#' command. It calls `po2md` from Docker,
#' and therefore requires Docker to be installed and running.
#'
#' To run on arm64 machines, use `container_id` joelnitta/po4a-arm64:latest.
#'
#' @inheritParams md2po
#' @param po Character vector of length 1; path to PO file to use for
#'   translation.
#' @param md_out Character vector of length 1; path to write translated MD file.
#' @param container_id Character vector of length 1;
#'   name of Docker container that includes po4a to run.
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
#'   md_in = system.file("extdata", "test.Rmd", package = "dovetail"),
#'   po = system.file("extdata", "test.ja.po", package = "dovetail"),
#'   md_out = temp_md
#' )
#' # last six lines of the original
#' tail(readLines(
#'   system.file("extdata", "test.Rmd", package = "dovetail")
#' ))
#' # last six lines of the translation
#' tail(readLines(temp_md))
#' unlink(temp_md)
#'
po2md <- function(
  md_in, po, md_out,
  container_id = "joelnitta/po4a:latest",
  other_args = NULL) {

  assertthat::assert_that(assertthat::is.readable(md_in))
  assertthat::assert_that(assertthat::is.readable(po))
  assertthat::assert_that(assertthat::is.string(container_id))

  # docker will write as root in some cases
  # to make sure po file has correct permissions,
  # read-in / write-out with R
  temp_file <- tempfile()

  res <- run_auto_mount(
    container_id = container_id,
    command = "po4a-translate",
    args = c(
      "-f", "text",
      "-m", file = md_in,
      "-p", file = po,
      "-l", file = temp_file,
      "-o", "markdown",
      "-k", 0, # don't require minimum number of translated lines
      "--width", 1000,
      "--wrap-po", "newlines",
      other_args
    )
  )

  if (res$status == 0 && res$stderr != "") {
    stop(paste(res$stderr))
  }

  out_lines <- readr::read_lines(temp_file)
  readr::write_lines(out_lines, md_out)
  md_out
}
