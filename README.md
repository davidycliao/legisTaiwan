
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The Real-time Archives of Taiwan Legislative Data <img src="man/figures/logo.png" align="right" width="140"/>

<!-- badges: start -->

[![R](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml)
[![codecov](https://codecov.io/gh/davidycliao/legisTaiwan/branch/master/graph/badge.svg?token=HVVTCOE90D)](https://codecov.io/gh/davidycliao/legisTaiwan)
[![R-CMD-check](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml)
[![LifeCycle](https://img.shields.io/badge/lifecycle-experimental-orange)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Test
coverage](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml)
<!-- badges: end -->

`legisTaiwan` is an R package for downloading the real-time archives of
Taiwan legislative data.

## Overview

| `legisTaiwan`                                                                                                 | Since (AD/ROC)   | Taiwan Legislative Yuan API                                                                                           |
|---------------------------------------------------------------------------------------------------------------|------------------|-----------------------------------------------------------------------------------------------------------------------|
| [`get_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills.html)                        | 7th\* (2011/100) | [**Spoken Meeting Records (委員發言)**](https://www.ly.gov.tw/Pages/List.aspx?nodeid=154)                             |
| [`get_caucus_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/get_caucus_meetings.html)       | 8th\* (2014/100) | [**the Meeting Records of Cross-caucus Session 黨團協商**](https://data.ly.gov.tw/getds.action?id=8)                  |
| [`get_bills()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills.html)                           | 7th\* (2011/100) | [**the Records of the Bills 法律提案(API)**](https://www.ly.gov.tw/Pages/List.aspx?nodeid=154)                        |
| [`get_bills_2()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills_2.html)                       | 8th\* (2014/100) | [**the Records of Legislators and the Government Bill Proposals 議案提案**](https://data.ly.gov.tw/getds.action?id=1) |
| [`get_legislators()`](https://davidycliao.github.io/legisTaiwan/reference/get_legislators.html)               | 2th (1992/81)    | [**Legislator Demographics (歷屆委員資料)**](https://data.ly.gov.tw/getds.action?id=16)                               |
| [`get_parlquestions()`](https://davidycliao.github.io/legisTaiwan/reference/get_parlquestions.html)           | 8th (2014/104)   | [**Questions Asked by Legislators (立委質詢)**](https://data.ly.gov.tw/getds.action?id=6)                             |
| [`get_executive_response()`](https://davidycliao.github.io/legisTaiwan/reference/get_executive_response.html) | 8th (2014/104)   | [**Questions Answered by the Executives 質詢事項(行政院答復部分)**](https://data.ly.gov.tw/getds.action?id=1)         |
| [`get_debates()`](https://davidycliao.github.io/legisTaiwan/reference/get_public_debates.html)                | 8th (2014/104)   | [**Public Debates 國是論壇**](https://data.ly.gov.tw/getds.action?id=7)                                               |

## Install from GitHub Using `remotes`

``` r
# install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan", force = TRUE)
#> Downloading GitHub repo davidycliao/legisTaiwan@HEAD
#> 
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>      checking for file ‘/private/var/folders/5n/clfp8vwj01bcy2hpncvffm0r0000gn/T/RtmpVACFLI/remotesc5253efbb02/davidycliao-legisTaiwan-38bff7d/DESCRIPTION’ ...  ✔  checking for file ‘/private/var/folders/5n/clfp8vwj01bcy2hpncvffm0r0000gn/T/RtmpVACFLI/remotesc5253efbb02/davidycliao-legisTaiwan-38bff7d/DESCRIPTION’
#>   ─  preparing ‘legisTaiwan’:
#>      checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>      Omitted ‘LazyData’ from DESCRIPTION
#>   ─  building ‘legisTaiwan_0.1.1.tar.gz’
#>      
#> 
```

``` r
library(legisTaiwan)
#> ## legisTaiwan                                            ###
#> ## An R package connecting to the Taiwan Legislative API. ###
```

#### View `get_caucus_meetings()`

``` r
caucus_meetings <- get_infos("get_caucus_meetings")$page_info
print(caucus_meetings)
#> # A tibble: 12 × 2
#>    `資料集名稱：黨團協商` 資料集描述                                            
#>    <chr>                  <chr>                                                 
#>  1 資料目錄               "議事類"                                              
#>  2 資料集說明             "提供公報之黨團協商資訊。(自第8屆第1會期起)"          
#>  3 資料提供者             "議事暨公報管理系統(資訊處)"                          
#>  4 欄位說明               "comYear：卷,comVolume：期,comBookId：冊別,term：屆別…
#>  5 資料集預覽             "HTML預覽<aclass=\"btn_yellow\"href='/openDatasetJson…
#>  6 資料集使用             "使用方式及列表"                                      
#>  7 API說明                "API提供參數分別為卷(comYear)、期(comVolume)、冊別(co…
#>  8 連結說明               "https://data.ly.gov.tw/odw/ID8Action.action?comYear=…
#>  9 更新頻率               "每日01時30分"                                        
#> 10 資料筆數               "787"                                                 
#> 11 建立時間               "2014-08-18MonAug1806:00:00CST2014"                   
#> 12 更新時間               "2023-01-27FriJan2701:31:31CST2023"
```

## Acknowledgement

The package is part of Yen-Chieh Liao’s doctoral dissertation project
[`Electoral Reform, Distributive Politics, and Parties in the Taiwanese Congress`](https://raw.githack.com/davidycliao/phd-thesis/main/Yen_Chieh_Liao_PhD_Dissertation_Jan_2023.pdf)
at the [Department of
Government](https://www.essex.ac.uk/departments/government) in
University of Essex and supported by the 2021 Taiwanese Overseas
Pioneers Grants for PhD Candidates from the National Science and
Technology Council in Taiwan.
