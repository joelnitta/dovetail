#' Create the folder and file hierarchy needed to translate a lesson
#'
#' This will create a folder called `locale/{lang}`, where `{lang}` is provided
#' via the `lang` argument, and populate it with all files needed to translate
#' into that language; these are initially **copies** of the files in the
#' original language.
#'
#' @param lang Name of language. Should be formatted as
#' [ISO 639 two-letter language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes),
#' OR the language code followed by an underscore and the
#' [ISO 3166 two-letter country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
#' for region-specific translations. Should be
#' lowercase.
#'
#' @return Nothing; externally, files will be written to `locale/{lang}`.
#' @export
#'
#' @examples
#' \dontrun{
#' # This example assumes the command is being run from the root of a
#' # carpentries lesson.
#' create_locale("ja")
#' }
create_locale <- function(lang) {

  # Add locale/ to .gitignore
  gitignore <- readr::read_lines(".gitignore")
  if (!any(stringr::str_detect(gitignore, "locale"))) {
    gitignore <- c(gitignore, "# Translations", "locale/")
    writeLines(gitignore, ".gitignore")
    message("Added locale/ to .gitignore")
  }

  # Create locale/{lang} dir
  fs::dir_create(glue::glue("locale/{lang}"))

  # Copy dirs and files
  fs::dir_copy(
    "episodes", glue::glue("locale/{lang}/episodes"), overwrite = TRUE)
  fs::dir_copy(
    "instructors", glue::glue("locale/{lang}/instructors"), overwrite = TRUE)
  fs::dir_copy(
    "learners", glue::glue("locale/{lang}/learners"), overwrite = TRUE)
  fs::dir_copy(
    "profiles", glue::glue("locale/{lang}/profiles"), overwrite = TRUE)

  fs::file_copy(
    c(
      "CODE_OF_CONDUCT.md",
      "config.yaml",
      "CONTRIBUTING.md",
      "index.md",
      "LICENSE.md",
      "links.md"
    ),
    glue::glue("locale/{lang}"),
    overwrite = TRUE
  )

}
