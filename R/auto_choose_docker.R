#' Automatically choose an appropriate Docker image
#' to run po4a
#'
#' @autoglobal
#' @return Character vector of length 1
#' @export
#'
#' @examples
#' auto_choose_docker()
auto_choose_docker <- function() {
  ifelse(
  grepl("arm64", Sys.info()[["machine"]]),
    "joelnitta/po4a-arm64:latest",
    "joelnitta/po4a:latest"
  )
}
