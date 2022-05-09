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
#' @return List with components formatted like the output of [processx::run()].
#' Externally, the PO file will be generated at the path specified by `po`.
#' @export
#'
md2po <- function(
  md_in, po, wrap_width = 0, other_args = NULL) {
  assertthat::assert_that(assertthat::is.readable(md_in))
  assertthat::assert_that(assertthat::is.string(po))
  run_auto_mount(
    container_id = "joelnitta/mdpo:latest",
    command = "md2po",
    args = c(
      file = md_in,
      "-po", file = po,
      "-s", file = po,
      "--wrapwidth", wrap_width,
      other_args
    )
  )
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
#' @return List with components formatted like the output of [processx::run()].
#' Externally, translated MD file will be generated at the path specified by
#'   `md_out`.
#' @export
#'
po2md <- function(
  md_in, po, md_out,
  wrap_width = 0, other_args = NULL) {
  run_auto_mount(
    container_id = "joelnitta/mdpo:latest",
    command = "po2md",
    args = c(
      file = md_in,
      "--pofiles", file = po,
      "-s", file = md_out,
      "--wrapwidth", wrap_width,
      other_args
    )
  )
}
