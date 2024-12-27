
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Real-time and Archives of Taiwan Legislative Data in R <img src="/man/figures/logo.png" align="right" width="180"/>

<!-- badges: start -->

[![codecov](https://codecov.io/gh/davidycliao/legisTaiwan/branch/master/graph/badge.svg?token=HVVTCOE90D)](https://codecov.io/gh/davidycliao/legisTaiwan)
[![R-CMD-check](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml)
[![Test
coverage](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml)
[![pkgdown](https://github.com/davidycliao/legisTaiwan/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/pkgdown.yaml)
[![CodeFactor](https://www.codefactor.io/repository/github/davidycliao/legistaiwan/badge)](https://www.codefactor.io/repository/github/davidycliao/legistaiwan)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7633962.svg)](https://doi.org/10.5281/zenodo.7633962)
<!-- badges: end -->

<div style="text-align: justify">

`legisTaiwan` is designed to download the real-time archives of Taiwan
legislative data easily. This package includes many streamlined
functions to access [Taiwan Legislative Yuan
API](https://data.ly.gov.tw/index.action) in R without any hassle or
runarounds.

</div>

<br>

## Get Started with Using [`remotes`](https://github.com/r-lib/remotes):

``` r
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan", force = TRUE)
```

``` r
library(legisTaiwan)
#> ## legisTaiwan                                            ##
#> ## An R package connecting to the Taiwan Legislative API. ##
```

<br>

## Caution:

<div style="text-align: justify">

`legisTaiwan` requires a stable internet connection to retrieve data
from the API. While most functions can fetch data spanning a long
period, they tend to be bandwidth-intensive due to the size of the
datasets. If you plan to download data over an extended period, I
recommend using get_variable_info() first to verify the current file
sizes on the API manual. Also, consider writing a batch retrieval
process with appropriate handlers to track the progress of file input,
ensuring the completeness of the requested data.

</div>
