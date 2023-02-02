
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The Real-time and Archives of Taiwan Legislative Data <img src="man/figures/pkg.png" align="right" width="140"/>

<!-- badges: start -->

[![R](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml)
[![codecov](https://codecov.io/gh/davidycliao/legisTaiwan/branch/master/graph/badge.svg?token=HVVTCOE90D)](https://codecov.io/gh/davidycliao/legisTaiwan)
[![R-CMD-check](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml)
[![Test
coverage](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml)
[![pkgdown](https://github.com/davidycliao/legisTaiwan/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/pkgdown.yaml)
[![LifeCycle](https://img.shields.io/badge/lifecycle-experimental-orange)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`legisTaiwan` is designed to make it quick and easy to download the
real-time and archives of Taiwan legislative data via [Taiwan
Legislative Yuan API](https://data.ly.gov.tw/index.action).

## Overview

| `legisTaiwan`                                                                                                 | Since (AD/ROC)   | Taiwan Legislative Yuan API                                                                                                  |
|---------------------------------------------------------------------------------------------------------------|------------------|------------------------------------------------------------------------------------------------------------------------------|
| [`get_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills.html)                        | 7th\* (2011/100) | [**Spoken Meeting Records (委員發言)**](https://www.ly.gov.tw/Pages/List.aspx?nodeid=154)                                    |
| [`get_caucus_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/get_caucus_meetings.html)       | 8th\* (2014/100) | [**the Meeting Records of Cross-caucus Session 黨團協商**](https://data.ly.gov.tw/getds.action?id=8)                         |
| [`get_bills()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills.html)                           | 7th\* (2011/100) | [**the Records of the Bills 法律提案(API)**](https://www.ly.gov.tw/Pages/List.aspx?nodeid=154)                               |
| [`get_bills_2()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills_2.html)                       | 8th\* (2014/100) | [**the Records of Legislators and the Government Bill Proposals 議案提案**](https://data.ly.gov.tw/getds.action?id=1)        |
| [`get_legislators()`](https://davidycliao.github.io/legisTaiwan/reference/get_legislators.html)               | 2th (1992/81)    | [**Legislator Demographics (提供委員基本資料)**](https://data.ly.gov.tw/getds.action?id=16)                                  |
| [`get_parlquestions()`](https://davidycliao.github.io/legisTaiwan/reference/get_parlquestions.html)           | 8th (2014/104)   | [**Questions Asked by Legislators 提供議事日程本院委員之質詢事項資訊**](https://data.ly.gov.tw/getds.action?id=6)            |
| [`get_executive_response()`](https://davidycliao.github.io/legisTaiwan/reference/get_executive_response.html) | 8th (2014/104)   | [**Questions Answered by the Executives 提供公報質詢事項行政院答復資訊**](https://data.ly.gov.tw/getds.action?id=1)          |
| [`get_public_debates()`](https://davidycliao.github.io/legisTaiwan/reference/get_public_debates.html)         | 8th (2014/104)   | [**Public Debates 國是論壇**](https://data.ly.gov.tw/getds.action?id=7)                                                      |
| [`get_speech_video()`](https://davidycliao.github.io/legisTaiwan/reference/get_speech_video.html)             | 8th (2014/104)   | [**Full Video Information of Meetings and Committees 委員發言片段相關影片資訊**](https://data.ly.gov.tw/getds.action?id=148) |
| [`get_variable_info()`](https://davidycliao.github.io/legisTaiwan/reference/get_variable_info.html)           | 8th (2014/104)   | [**API’s Endpoint Manual API使用說明文件**](https://davidycliao.github.io/legisTaiwan/reference/get_variable_info.html)      |

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
