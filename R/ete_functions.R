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
#'   wing_sites <- getlatlon(data_tables, 'Wing')
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

#' @title Extract occurrence data by provider in long format
#'
#' @description This extracts the occurrence data by provider.
#' @param data_tables Variable that holds the ete data tables
#' @param provider_name Name of the dataset provider
#'
#' @return A dataframe of occurrence data from a given provider
#'
#' @examples
#' \donttest{
#'   amatangelo_occur <- geteteoccur(data_tables, 'Amatangelo')
#' }
#'
#' @export

geteteoccur <- function(data_tables, provider_name) {
  occurrences <- data_tables$occurrence_table %>%
    dplyr::left_join(data_tables$sites_table, by="sitekey") %>%
    dplyr::left_join(data_tables$dataset_table, by="datasetname",
                     suffix = c("", ".d")) %>%
    dplyr::filter(provider == provider_name) %>%
    dplyr::select(occurid, sitekey, sitename, speciesid, observed,
                  sid, timeybp, datasetname, latitude, longitude,
                  duration, spaceextent, provider)
  return(occurrences)
}

#' @title Extract occurrence data by dataset
#'
#' @description This extracts the occurrence data by dataset.
#' @param data_tables Variable that holds the ete data tables
#' @param pdataset_name Name of the dataset
#'
#' @return A dataframe of occurrence data from a given dataset
#'
#' @examples
#' \donttest{
#'   occur <- geteteoccurDataset(data_tables, 'Amatan_WI_Pla_Mod')
#' }
#'
#' @export

geteteoccurDataset <- function(data_tables, dataset_name) {
  occurrences <- data_tables$occurrence_table %>%
    dplyr::left_join(data_tables$sites_table, by="sitekey") %>%
    dplyr::filter(datasetname == dataset_name) %>%
    dplyr::select(occurid, sitekey, sitename, speciesid, observed, sid,
                  timeybp, datasetname, latitude, longitude, duration, spaceextent)
  return(occurrences)
}

#' @title Put your occurrence table in P/A matrix format
#'
#' @description This melts your occurrence table in P/A matrix format
#' @param dataframe Dataframe to unmelt
#'
#' @return A dataframe of occurrence data in P/A matrix format
#'
#' @examples
#' \donttest{
#'   PAtable <- unmelt2specXsite(occurrences)
#' }
#'
#' @export

unmelt2specXsite<-function(df) {
  ary <- reshape2::acast(df,speciesid~sitekey,
                         value.var="observed", fun.aggregate = mean)
  return(ary)
}

#' @title Extract site ages in ybp
#'
#' @description This extracts the site ages by provider.
#' @param data_tables Variable that holds the ete data tables
#' @param provider_name Name of the dataset provider
#'
#' @return A dataframe of sitekey and ages from a given provider
#'
#' @examples
#' \donttest{
#'   ages <- getages(data_tables, "Amatangelo")
#' }
#'
#' @export

getages <- function(data_tables, provider_name) {
  ages <- data_tables$sites_table %>%
    dplyr::left_join(data_tables$dataset_table, by="datasetname") %>%
    dplyr::filter(provider == provider_name) %>%
    dplyr::select(sitekey, timeybp)
  return(ages)
}

#' @title Extract site trait matrix
#'
#' @description This extracts a site trait matrix by provider.
#' @param data_tables Variable that holds the ete data tables
#' @param provider_name Name of the dataset provider
#'
#' @return A dataframe of site traits
#'
#' @examples
#' \donttest{
#'   sitetraits <- getsitetraits(data_tables, "Amatangelo")
#' }
#'
#' @export

getsitetraits <- function(data_tables, provider_name) {
  sitetraits <- data_tables$sitetrait_table %>%
    dplyr::left_join(data_tables$sites_table, by="sitekey") %>%
    dplyr::left_join(data_tables$dataset_table, by="datasetname",
                     suffix = c("", ".d")) %>%
    dplyr::filter(provider == provider_name) %>%
    dplyr::select(sitekey, variablename, numvar, discvar)
  return(sitetraits)
}

#' @title Extract sprecies trait matrix
#'
#' @description This extracts a species trait matrix by provider.
#' @param data_tables Variable that holds the ete data tables
#' @param provider_name Name of the dataset provider
#'
#' @return A dataframe of species traits
#'
#' @examples
#' \donttest{
#'   spptraits <- getspptraits(data_tables,"Amatangelo")
#' }
#'
#' @export

getspptraits <- function(data_tables, provider_name) {
  spptraits <- data_tables$speciestrait_table %>%
    dplyr::left_join(data_tables$species_table, by="speciesid") %>%
    dplyr::left_join(data_tables$occurrence_table, by="speciesid") %>%
    dplyr::left_join(data_tables$sites_table, by="sitekey") %>%
    dplyr::left_join(data_tables$dataset_table, by="datasetname") %>%
    dplyr::filter(provider == provider_name) %>%
    dplyr::select(speciesid, traitname, numvalue, discvalue)
  return(spptraits)
}
