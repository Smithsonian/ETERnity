
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ETERnity

<!-- badges: start -->

<!-- badges: end -->

The goal of ete is to provide an interface to the Evolution of
Terrestrial Ecosystems (ETE) Program database.

## Installation

You can install the released version of ete from GitHub with:

``` r
devtools::install_github("smithsonian/ETERnity")
```

## Examples

This is a basic example which shows you how to solve a common problem:

``` r
library(ETERnity)

data_tables <- load_ete_data(download_if_missing = TRUE)
#> Downloading version 1 of the data...
#> trying URL 'https://ndownloader.figshare.com/articles/[...]'
#> Content type 'application/zip' length 53537971 bytes (51.1 MB)
#> ==================================================
#> downloaded 51.1 MB
#> Unzipping file to /Users/[username]/.ete...

names(data_tables)
#> [1] "dataset_table"      "occurrence_table"   "sites_table"       
#> [4] "sitetrait_table"    "species_table"      "speciestrait_table"
#> [1] "dataset_table"      "occurrence_table"   "sites_table"        "sitetrait_table"   
#> [5] "species_table"      "speciestrait_table"
```

## Citation

If you use the eteRnity package, please cite accordingly:

## Attribution

The dataset download and load functions all borrowed heavily from
[portalr](https://github.com/weecology/portalr/blob/master/R/download_data.R).

  - [JOSS publication](https://doi.org/10.21105/joss.01098):
    
    Erica M. Christensen, Glenda M. Yenni, Hao Ye, Juniper L. Simonis,
    Ellen K. Bledsoe, Renata M. Diaz, Shawn D. Taylor, Ethan P. White,
    and S. K. Morgan Ernest. (2019). portalr: an R package for
    summarizing and using the Portal Project Data. Journal of Open
    Source Software, 4(33), 1098, <https://doi.org/10.21105/joss.01098>
