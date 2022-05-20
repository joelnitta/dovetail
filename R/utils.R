#' Exclude pandoc fences from an MD file
#'
#' @param md_lines Character vector; lines read in from a markdown file
#'
#' @return Character vector with comments inserted that tell mdpo
#' to ignore lines starting with :::
#' @autoglobal
#' @noRd
#'
exclude_fences <- function(md_lines) {
  # Early exit just returning input if no pandoc fences
  if (!any(stringr::str_detect(md_lines, "^\\:\\:\\:"))) {
    return(md_lines)
  }

  # Exclude pandoc fences
  fence_lines <- which(stringr::str_detect(md_lines, "^\\:\\:\\:"))

  if (length(fence_lines) > 0) {
    for (i in seq_along(fence_lines)) {
      md_lines <- append(
        md_lines,
        "<!-- mdpo-disable-next-line -->",
        after = fence_lines[i] - 1)
      # Need to account for newly added line
      fence_lines <- fence_lines + 1
    }
  }

  md_lines

}

#' Fix a YAML header mangled by mdpo
#'
#' mdpo
#' [can't handle YAML headers correctly](https://github.com/mondeja/mdpo/issues/227),
#' and the developer won't fix the bug (out of scope since mdpo only handles
#' CommonMark spec).
#'
#' Work-around is to tweak the resulting MD file.
#'
#' @param md_in Path to MD file with mangled YAML header.
#' @param md_out Path to write MD file with repaired YAML header.
#'
#' @return `md_out` invisibly; externally,
#'   the repaired MD file will be written to md_out
#' @autoglobal
#' @noRd
#'
fix_yaml_header <- function(md_in, md_out) {
  # Read in MD file with malformed YAML header after running po2md
  md_lines <- readr::read_lines(md_in)

  # Early exit just copying the md file if no YAML header
  if (!any(stringr::str_detect(md_lines, "^\\*\\*\\*$"))) {
    fs::file_copy(md_in, md_out, overwrite = TRUE)
    return(TRUE)
  }

  # Check for YAML header that had no content between --- and ---
  if (
    md_lines[[1]] == "---" &&
    md_lines[[2]] == "***" &&
    md_lines[[3]] == "---"
  ) {
    md_lines <- md_lines[-2]
    readr::write_lines(md_lines, md_out)
    return(invisible(md_out))
  }

  yaml_head_start <- which(stringr::str_detect(md_lines, "^\\*\\*\\*$"))[[1]]

  assertthat::assert_that(
    length(yaml_head_start) > 0,
    msg = "No malformed YAML header detected"
  )

  # The header ends at the second blank line
  yaml_head_end <- which(stringr::str_detect(md_lines, "^$"))[[2]]

  # Extract the key-value contents, add correct fences
  yaml_header_contents <- md_lines[(yaml_head_start + 2):(yaml_head_end - 1)] %>% # nolint
    stringr::str_remove_all("##") %>%
    stringr::str_squish() %>%
    c("---", .) %>%
    c(., "---")

  # Append fixed header
  md_lines[-(yaml_head_start:(yaml_head_end - 1))] %>%
    append(yaml_header_contents, after = 0) %>%
    readr::write_lines(md_out)
    return(invisible(md_out))
}

#' Generate a custom error message for {assertr}
#'
#' @param msg Message to print if there is an error
#' @return Stops function and prints error message
#' @noRd
err_msg <- function(msg) stop(msg, .call = FALSE)

#' Find all (R)md files in a folder
#'
#' @param search_path Folder to search for (R)md files
#'
#' @return Tibble
#' @autoglobal
#' @noRd
#'
find_md_files <- function(search_path = ".") {
  # List all md files, use this to format paths
  # for writing PO files
  tibble::tibble(
    md_path = list.files(
      path = search_path,
      pattern = "\\.md$|\\.Rmd$",
      ignore.case = TRUE,
      recursive = TRUE)
  ) %>%
    assertr::verify(
      nrow(.) > 0,
      error_fun = err_msg("No Rmd or md files found")
    ) %>%
    # Exclude any files the wrong folders
    dplyr::filter(
      !stringr::str_detect(md_path, "locale/|site/|po/|renv/")
    ) %>%
    # Format paths
    dplyr::mutate(
      md_file = fs::path_file(md_path),
      md_dir = fs::path_dir(md_path),
      md_name = fs::path_ext_remove(md_file)
    ) %>%
    assertr::assert(
      assertr::is_uniq, md_file,
      error_fun = err_msg("MD file names not unique")
    )
}
