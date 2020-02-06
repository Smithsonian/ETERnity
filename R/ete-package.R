#' @title Allows access to ETE database
#'
#' @description This package is designed to be an interface to the ETE database.
#'
#' @name ete
#' @docType package
#' @keywords package
#'
#' @importFrom utils download.file unzip

NULL

## quiets concerns of R CMD check re: variables used in NSE functions
if (getRversion() >= "2.15.1") utils::globalVariables(
  c(".", "n")
)
