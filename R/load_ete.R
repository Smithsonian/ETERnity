#' The functions load_ete_data and load_datafile were both borrowed
#' heavily from https://github.com/weecology/portalr/blob/master/R/load_data.R,
#' with permission of the portalr maintainers.

#' @rdname load_ete_data
#' @description loads the ETE data files
#'
#' @return \code{\link{load_ete_data}} returns a list of 6 dataframes:
#'   \tabular{ll}{
#'     \code{dataset_table} \tab description\cr
#'     \code{occurrence_table} \tab description\cr
#'     \code{sites_table} \tab description\cr
#'     \code{sitetrait_table} \tab description\cr
#'     \code{species_table} \tab description\cr
#'     \code{speciestrait_table} \tab description\cr
#'   }
#'
#' @examples
#' \donttest{
#' ete_data <- load_ete_data()
#' }
#' @export
load_ete_data <- function(path = get_default_data_path(),
                               download_if_missing = TRUE, clean = TRUE,
                               quiet = FALSE)
{
  dataset_table <- load_datafile(file.path("dataset.csv"),
                                  na.strings = "NA", path, download_if_missing, quiet = quiet)
  occurrence_table <- load_datafile(file.path("occurrence.csv"),
                                 na.strings = "NA", path, download_if_missing, quiet = quiet)
  sites_table <- load_datafile(file.path("sites.csv"),
                                 na.strings = "NA", path, download_if_missing, quiet = quiet)
  sitetrait_table <- load_datafile(file.path("sitetrait.csv"),
                                 na.strings = "NA", path, download_if_missing, quiet = quiet)
  species_table <- load_datafile(file.path("species.csv"),
                                 na.strings = "NA", path, download_if_missing, quiet = quiet)
  speciestrait_table <- load_datafile(file.path("speciestrait.csv"),
                                 na.strings = "NA", path, download_if_missing, quiet = quiet)

  return(mget(c("dataset_table", "occurrence_table", "sites_table",
                "sitetrait_table","species_table","speciestrait_table")))
}

#' @name load_datafile
#'
#' @title read in a raw datafile from the downloaded data or the GitHub repo
#'
#' @description does checking for whether a particular datafile exists and then
#'   reads it in, using na_strings to determine what gets converted to NA. It
#'   can also download the dataset if it's missing locally.
#'
#' @param datafile the path to the datafile within the folder for Portal data
#' @param quiet logical, whether to perform operations silently
#' @inheritParams utils::read.table
#'
#' @examples
#' \donttest{
#' species_df <- load_datafile("ETE/species.csv")
#' }
#' @export
load_datafile <- function(datafile, na.strings = "", path = get_default_data_path(),
                          download_if_missing = TRUE, quiet = TRUE)
{

  ## define file paths
  tryCatch(base_path <- file.path(normalizePath(path, mustWork = TRUE), ".ete"),
           error = function(e) stop("Specified path ", path, "does not exist. Please create it first."),
           warning = function(w) w)

  datafile <- file.path(base_path, datafile)

  ## check if files exist and download if appropriate
  if (!file.exists(datafile))
  {
    if (download_if_missing) {
      warning("Proceeding to download data into specified path", path, "\n")
      download_ete(path)
    } else {
      stop("Data files were not found in specified path", path, "\n")
    }
  }

  ## read in the data table and return
  read.csv(datafile, na.strings = na.strings, stringsAsFactors = FALSE)
}
