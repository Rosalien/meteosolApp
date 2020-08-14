# meteosolApp

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

Shiny app for manage data from biometeorological stations.

## Installation

You can install the released version of dataAccessApp with:

``` r
devtools::install_github("Rosalien/meteosolApp")
```

## Deploy

### Deploy in local

``` r
meteosolApp::run_app()
```

You can try app with this [example file](https://github.com/Rosalien/toolboxMeteosol/raw/master/inst/extdata/compilation/Compile_lgt_bm1_2020.csv)

### Docker

Build : 

```bash

docker build -t meteosolapp .
```

Run :

```bash
docker run meteosolapp
```