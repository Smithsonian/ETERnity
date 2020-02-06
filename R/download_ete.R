#' @title Full Path
#' @description Return normalized path for all operating systems
#' @param reference_path a path to join with current working directory
#' @param base_path Current working directory else path given
#'
#' @return Full path
#'
#' @examples
#' full_path('PortalData/Rodents/Portal_rodent.csv')
#' full_path('PortalData/Rodents/Portal_rodent.csv', '~')
#'
#' @noRd
full_path <- function(reference_path, base_path = getwd()) {
  base_path <- normalizePath(base_path)
  path <- normalizePath(file.path(base_path, reference_path), mustWork = FALSE)
  return(path)
}

#' @title Download the PortalData repo
#'
#' @description This downloads the latest portal data regardless if they are
#'   actually updated or not.
#' @param path Folder into which data will be downloaded
#' @param version Version of the data to download (default = "latest")
#' @param quiet logical, whether to download data silently
#' @inheritParams get_data_versions
#'
#' @return None
#'
#' @examples
#' \donttest{
#'   download_observations()
#'   download_observations("~/old-data", version = "1.50.0")
#' }
#'
#' @export
download_ete <- function(path = get_default_data_path(),
                         version = "latest",
                         quiet = FALSE)
{
  # get version info
  releases <- get_data_versions()
  # match version
  if (version == "latest")
  {
    match_idx <- 1
  } else {
    # Normalize version number
    if (grepl("^[0-9]+\\.[0-9]+$", version))
    {
      version <- paste0(version, ".0")
    }
    if (!grepl("^[0-9]+\\.[0-9]+\\.0$", version))
    {
      stop("Invalid version number; given, ", version, call. = FALSE)
    }

    match_idx <- match(version, releases$version)
    if (length(match_idx) != 1 || is.na(match_idx))
    {
      stop("Did not find a version of the data matching, ", version, call. = FALSE)
    }
  }

  # Attemt to download the zip file
  if (!quiet)
    message("Downloading version ", releases$version[match_idx], " of the data...")
  zip_download_path <- releases$zipball_url[match_idx]
  zip_download_dest <- full_path("ETEData.zip", tempdir())
  final_data_folder <- full_path(".ete", path)

  download.file(zip_download_path, zip_download_dest, quiet = FALSE, mode = "wb")

  if (!quiet)
    message("Unzipping file to ",final_data_folder,'...')

  # Clear out the old files in the data folder without doing potentially dangerous
  # recursive deleting.
  if (file.exists(final_data_folder)) {
    old_files <- list.files(
      final_data_folder,
      full.names = TRUE,
      all.files = TRUE,
      recursive = TRUE,
      include.dirs = FALSE
    )
    file.remove(normalizePath(old_files))
    unlink(final_data_folder, recursive = TRUE)
  }
  unzip(zip_download_dest, exdir = final_data_folder)
  file.remove(zip_download_dest)
}

#' @title get version and download info for PortalData
#'
#' @description Check either Zenodo or GitHub for the version and download link
#'   for PortalData.
#'
#' @param from_zenodo logical; if `TRUE`, get info from Zenodo, otherwise GitHub
#' @param halt_on_error logical; if `FALSE`, return NULL on errors, otherwise
#'   whatever got returned (could be an error or warning)
#' @return A data.frame with two columns, `version` (string with the version #) and
#'   `zipball_url` (download URLs for the corresponding zipped release).
#'
#' @export
get_data_versions <- function()
{
  releases <- data.frame('version' = c(1),
                         'zipball_url' = c('https://ndownloader.figshare.com/articles/11409957?private_link=5423bff4cf21c83d836b'),
                         stringsAsFactors = FALSE)
  if (!is.data.frame(releases))
  {
    return(NULL)
  }
  return(releases)
}

#' @rdname use_default_data_path
#'
#' @description \code{check_default_data_path} checks if a default data path is
#'   set, and prompts the user to set it if it is missing.
#'
#' @inheritParams use_default_data_path
#' @param MESSAGE_FUN the function to use to output messages
#' @param DATA_NAME the name of the dataset to use in output messages
#' @return FALSE if there is no path set, TRUE otherwise
#'
#' @export
#'
check_default_data_path <- function(ENV_VAR = "ETE_DATA_PATH",
                                    MESSAGE_FUN = message, DATA_NAME = "ETE data")
{
  if (is.na(get_default_data_path(fallback = NA, ENV_VAR)))
  {
    MESSAGE_FUN("You don't appear to have a defined location for storing ", DATA_NAME, ".")
    code_call_str <- (crayon::make_style("darkgrey"))(encodeString('use_default_data_path(\"<path>\")', quote = "`"))
    MESSAGE_FUN(crayon::red(clisymbols::symbol$bullet),
                " Call ", code_call_str, " if you wish to set the default data path.")
    default_path_str <- (crayon::make_style("darkgrey"))(encodeString(path.expand("~"), quote = "`"))
    MESSAGE_FUN(DATA_NAME, " will be downloaded into ", default_path_str, " otherwise.")
    return(FALSE)
  }
  return(TRUE)
}

#' @rdname use_default_data_path
#'
#' @description \code{get_default_data_path} gets the value of the data path
#'   environmental variable
#'
#' @inheritParams use_default_data_path
#' @param fallback the default value to use if the setting is missing
#'
#' @export
#'
get_default_data_path <- function(fallback = "~", ENV_VAR = "ETE_DATA_PATH")
{
  Sys.getenv(ENV_VAR, unset = fallback)
}

#' @name use_default_data_path
#' @aliases get_default_data_path
#'
#' @title Manage the default path for downloading Portal Data into
#'
#' @description \code{use_default_data_path} has 3 steps. First, it checks for
#'   the presence of a pre-existing setting for the environmental variable.
#'   Then it checks if the folder exists and creates it, if needed. Then it
#'   provides instructions for setting the environmental variable.
#' @inheritParams download_observations
#' @param ENV_VAR the environmental variable to check (by default
#'   `"ETE_DATA_PATH"``)
#'
#' @return None
#'
#' @export
use_default_data_path <- function(path = NULL, ENV_VAR = "ETE_DATA_PATH")
{
  # check for prexisting setting
  curr_data_path <- Sys.getenv(ENV_VAR, unset = NA)
  if (!is.na(curr_data_path))
  {
    warning("A default data path exists:", Sys.getenv(ENV_VAR), ".")
  }

  # check if a path is provided
  if (is.null(path))
  {
    usethis::ui_stop("Please provide a path to store downloaded data.")
  }

  # check if path is valid
  if (!dir.exists(path))
  {
    dir.create(path)
  }

  # copy new path setting to clipboard
  path_setting_string <- paste0(ENV_VAR, "=", '"', path, '"')

  usethis::ui_todo("Call {usethis::ui_code('usethis::edit_r_environ()')} to open {usethis::ui_path('.Renviron')}")
  usethis::ui_todo("Store your data path with a line like:")
  usethis::ui_code_block(path_setting_string)
  usethis::ui_todo("Make sure {usethis::ui_value('.Renviron')} ends with a newline!")
  return()
}
