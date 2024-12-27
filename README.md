
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

### Summary Descriptive of Current Bills (法案提案統計)

``` r
get_variable_info("get_bills_2")
#> $page_info
#> # A tibble: 12 × 2
#>    `資料集名稱：議案提案` 資料集描述                                            
#>    <chr>                  <chr>                                                 
#>  1 資料目錄               "議事類"                                              
#>  2 資料集說明             "提供委員及政府之議案提案資訊。(自第8屆第1會期起)"    
#>  3 資料提供者             "議事暨公報資訊網"                                    
#>  4 欄位說明               "term：屆別,sessionPeriod：會期,sessionTimes：會次,meetingTime…
#>  5 資料集預覽             "HTML預覽<aclass=\"btn_yellow\"href='/openDatasetJson.a…
#>  6 資料集使用             "使用方式及列表"                                      
#>  7 API說明                "API提供參數分別為屆別(term)、會期(sessionPeriod)、會次(sessionTimes…
#>  8 連結說明               "https://data.ly.gov.tw/odw/ID20Action.action?term=10…
#>  9 更新頻率               "每日04時15分"                                        
#> 10 資料筆數               "30766"                                               
#> 11 建立時間               "2014-09-03WedSep0310:38:36CST2014"                   
#> 12 更新時間               "2024-12-26ThuDec2604:21:02CST2024"                   
#> 
#> $reference_url
#> [1] "https://data.ly.gov.tw/getds.action?id=20"
```

### Summary Descriptive of Parliamentary Questions (委員質詢事項統計分析)

``` r
get_variable_info("get_parlquestions")
#> $page_info
#> # A tibble: 12 × 2
#>    `資料集名稱：質詢事項(本院委員質詢部分)` 資料集描述                          
#>    <chr>                                    <chr>                               
#>  1 資料目錄                                 "質詢類"                            
#>  2 資料集說明                               "提供議事日程本院委員之質詢事項資訊。(自第10屆第1會期起)"……
#>  3 資料提供者                               "議事暨公報資訊網"                  
#>  4 欄位說明                                 "term：屆別,sessionPeriod：會期,sessionTi…
#>  5 資料集預覽                               "HTML預覽<aclass=\"btn_yellow\"href='…
#>  6 資料集使用                               "使用方式及列表"                    
#>  7 API說明                                  "API提供參數分別為屆別(term)、會期(sessionPerio…
#>  8 連結說明                                 "https://data.ly.gov.tw/odw/ID6Acti…
#>  9 更新頻率                                 "每日01時55分"                      
#> 10 資料筆數                                 "1689"                              
#> 11 建立時間                                 "2014-08-18MonAug1806:00:00CST2014" 
#> 12 更新時間                                 "2024-12-27FriDec2701:56:46CST2024" 
#> 
#> $reference_url
#> [1] "https://data.ly.gov.tw/getds.action?id=6"
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
