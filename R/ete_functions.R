#' @title Extract site coordinates by provider
#'
#' @description This extracts the site coordinates by provider.
#' @param data_tables Variable that holds the ete data tables
#' @param provider_name Name of the dataset provider
#'
#' @return A dataframe of site coordinates from a given provider
#'
#' @examples
#' \donttest{
#'   wing_sites <- getlatlon('Wing')
#' }
#'
#' @export

getlatlon <- function(data_tables, provider_name) {
  sites <- data_tables$dataset_table %>%
                dplyr::left_join(data_tables$sites_table, by="datasetname") %>%
                dplyr::filter(provider == provider_name) %>%
                dplyr::select(sitekey, sitename, latitude, longitude)
  return(sites)
}
