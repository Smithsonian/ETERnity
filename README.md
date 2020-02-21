
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

### Loading ETE Data

The first step to using ETERnity is to load the library, and then use
the `load_ete_data` function to donwload the latest verion of ETE data
from Figshare, and load it into 6 tables.

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
```

### User Functions

We have created a suite of user functions that allow you to pull data
out of the ETE tables by provider. You can pull out yours or anyone
else’s.

**geteteoccur(provider)**: Get your occurrence table in long format.

``` r
amatangelo_occur <- geteteoccur(data_tables, 'Amatangelo')
head(amatangelo_occur)
#>   occurid        sitekey  sitename speciesid observed  sid timeybp
#> 1  849237 Amatan_3034_10 3034_2000    ABIBAL        1 3034      10
#> 2  849238 Amatan_3034_10 3034_2000    ACERUB        0 3034      10
#> 3  849239 Amatan_3034_10 3034_2000    ACESAC       28 3034      10
#> 4  849240 Amatan_3034_10 3034_2000    BETALL        0 3034      10
#> 5  849241 Amatan_3034_10 3034_2000    BETPAP        1 3034      10
#> 6  849242 Amatan_3034_10 3034_2000    CARCAR        0 3034      10
#>         datasetname latitude longitude duration spaceextent   provider
#> 1 Amatan_WI_Pla_Mod 44.96245 -87.19103        1       5e-04 Amatangelo
#> 2 Amatan_WI_Pla_Mod 44.96245 -87.19103        1       5e-04 Amatangelo
#> 3 Amatan_WI_Pla_Mod 44.96245 -87.19103        1       5e-04 Amatangelo
#> 4 Amatan_WI_Pla_Mod 44.96245 -87.19103        1       5e-04 Amatangelo
#> 5 Amatan_WI_Pla_Mod 44.96245 -87.19103        1       5e-04 Amatangelo
#> 6 Amatan_WI_Pla_Mod 44.96245 -87.19103        1       5e-04 Amatangelo
```

**geteteoccurDataset(dataset)**: Get your occurrence table in long
format for one timebin

``` r
amatan_wi_occur <- geteteoccurDataset(data_tables, 'Amatan_WI_Pla_Hist')
head(amatan_wi_occur)
#>   occurid        sitekey  sitename speciesid observed  sid timeybp
#> 1  851577 Amatan_3034_60 3034_1950    ABIBAL        1 3034      60
#> 2  851578 Amatan_3034_60 3034_1950    ACERUB        1 3034      60
#> 3  851579 Amatan_3034_60 3034_1950    ACESAC       31 3034      60
#> 4  851580 Amatan_3034_60 3034_1950    ACESPI        0 3034      60
#> 5  851581 Amatan_3034_60 3034_1950    BETALL        2 3034      60
#> 6  851582 Amatan_3034_60 3034_1950    BETPAP        8 3034      60
#>          datasetname latitude longitude duration spaceextent
#> 1 Amatan_WI_Pla_Hist 44.96245 -87.19103        1       5e-04
#> 2 Amatan_WI_Pla_Hist 44.96245 -87.19103        1       5e-04
#> 3 Amatan_WI_Pla_Hist 44.96245 -87.19103        1       5e-04
#> 4 Amatan_WI_Pla_Hist 44.96245 -87.19103        1       5e-04
#> 5 Amatan_WI_Pla_Hist 44.96245 -87.19103        1       5e-04
#> 6 Amatan_WI_Pla_Hist 44.96245 -87.19103        1       5e-04
```

**unmelt2specXsite(table)**: Put your occurrence table in P/A matrix
format

``` r
PAtable <- unmelt2specXsite(amatan_wi_occur)
PAtable[1:5,1:5]
#>        Amatan_1_60 Amatan_10_60 Amatan_1000_60 Amatan_1002_60
#> ABIBAL         NaN          NaN            NaN            NaN
#> ACENEG           0            0              0              0
#> ACERUB           0            0              0              1
#> ACESAC          11           11             37              0
#> ACESPI         NaN          NaN            NaN            NaN
#>        Amatan_1003_60
#> ABIBAL            NaN
#> ACENEG              0
#> ACERUB              0
#> ACESAC              0
#> ACESPI            NaN
```

**getlatlon(provider)**: Get a list of your sites and their coordinates

``` r
wing_sites <- getlatlon(data_tables, 'Wing')
head(wing_sites)
#>         sitekey sitename latitude longitude
#> 1 Wing_16-4_73m    BCR15  43.8527  -107.536
#> 2 Wing_17-0_73m    BCR16  43.8527  -107.536
#> 3 Wing_17-9_73m    BCR17  43.8524  -107.535
#> 4 Wing_18-0_73m    BCR18  43.8524  -107.535
#> 5 Wing_18-1_73m    BCR19  43.8523  -107.536
#> 6 Wing_18-2_73m    BCR20  43.8523  -107.535
```

**getages(provider)**: Get a list of your sites and their ages

``` r
ages <- getages(data_tables, "Behrensmeyer1")
head(ages)
#>                sitekey  timeybp
#> 1 Behren_D0025_10.474m 10474000
#> 2 Behren_D0027_10.474m 10474000
#> 3 Behren_D0062_10.066m 10066000
#> 4 Behren_GB001_10.768m 10768000
#> 5 Behren_GB002_10.876m 10876000
#> 6 Behren_KL017_10.568m 10568000
```

**getsitetraits(provider)**: Get your site traits matrix

``` r
sitetraits <- getsitetraits(data_tables, "Blois")
head(sitetraits)
#>      sitekey  variablename   numvar discvar
#> 1 Blois_1_1k ANN_PRECIP_MM 283.7258        
#> 2 Blois_1_2k ANN_PRECIP_MM 283.2045        
#> 3 Blois_1_3k ANN_PRECIP_MM 282.3187        
#> 4 Blois_1_4k ANN_PRECIP_MM 282.2152        
#> 5 Blois_1_5k ANN_PRECIP_MM 275.3530        
#> 6 Blois_1_6k ANN_PRECIP_MM 275.3668
```

**getspptraits(provider)**: Get your species trait matrix

``` r
spptraits <- getspptraits(data_tables,"Lyons")
head(spptraits)
#>   speciesid traitname numvalue discvalue
#> 1   Ago_pac    AFR_MO     10.5          
#> 2   Ago_pac    AFR_MO     10.5          
#> 3   Ago_pac    AFR_MO     10.5          
#> 4   Ago_pac    AFR_MO     10.5          
#> 5   Ago_pac    AFR_MO     10.5          
#> 6   Ago_pac    AFR_MO     10.5
```

## Citation

If you use the ETERnity package, please cite accordingly:

## Attribution

The dataset download and load functions all borrowed heavily from
[portalr](https://github.com/weecology/portalr/blob/master/R/download_data.R).

  - [JOSS publication](https://doi.org/10.21105/joss.01098):
    
    Erica M. Christensen, Glenda M. Yenni, Hao Ye, Juniper L. Simonis,
    Ellen K. Bledsoe, Renata M. Diaz, Shawn D. Taylor, Ethan P. White,
    and S. K. Morgan Ernest. (2019). portalr: an R package for
    summarizing and using the Portal Project Data. Journal of Open
    Source Software, 4(33), 1098, <https://doi.org/10.21105/joss.01098>
