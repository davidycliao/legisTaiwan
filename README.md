
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Real-time and Archives of Taiwan Legislative Data in R <img src="man/figures/logo.png" align="right" width="180"/>

<!-- badges: start -->

[![R](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml)
[![codecov](https://codecov.io/gh/davidycliao/legisTaiwan/branch/master/graph/badge.svg?token=HVVTCOE90D)](https://codecov.io/gh/davidycliao/legisTaiwan)
[![R-CMD-check](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml)
[![Test
coverage](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml)
[![pkgdown](https://github.com/davidycliao/legisTaiwan/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/pkgdown.yaml)
[![CodeFactor](https://www.codefactor.io/repository/github/davidycliao/legistaiwan/badge)](https://www.codefactor.io/repository/github/davidycliao/legistaiwan)
<!-- badges: end -->

<div style="text-align: justify">

`legisTaiwan` is designed to download the real-time archives of Taiwan
legislative data easily. This package includes many streamlined
functions to access [Taiwan Legislative Yuan
API](https://data.ly.gov.tw/index.action) and efficiently perform
analysis and natural language processing tasks in R without any hassle
or runarounds.

</div>

<br>

## Get Started with Using [`remotes`](https://github.com/r-lib/remotes):

``` r
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan", force = TRUE)
```

``` r
library(legisTaiwan)
#> ## legisTaiwan                                            ###
#> ## An R package connecting to the Taiwan Legislative API. ###
```

## Caution:

<div style="text-align: justify">

`legisTaiwan` requires stable internet connectivity for any data
retrieval function from the API. Most functions can be directly used to
retrieve a long period of data but are extremely bandwidth-intensive,
given the download sizes of these data stores. When downloading a more
extended period of data, I suggest using **get_variable_info()** to
double-check the current size of files on the API manual and write a
loop with appropriate handlers recording the progress of file input to
make sure the requested data is complete.

</div>
