
<!-- README.md is generated from README.Rmd. Please edit that file -->

# The Real-time Archives of Taiwan Legislative Data <img src="man/figures/logo.png" align="right" width="140"/>

<!-- badges: start -->

[![R](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml)
[![codecov](https://codecov.io/gh/davidycliao/legisTaiwan/branch/master/graph/badge.svg?token=HVVTCOE90D)](https://codecov.io/gh/davidycliao/legisTaiwan)
[![R-CMD-check](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml)
[![Test
coverage](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml)
[![LifeCycle](https://img.shields.io/badge/lifecycle-experimental-orange)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`legisTaiwan` is designed to make it quick and easy to download the real-time archives of Taiwan legislative data via Taiwan Legislative Yuan API.

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

## Quick Start

### Install from GitHub Using `remotes`

``` r
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan", force = TRUE)
```

``` r
library(legisTaiwan)
#> ## legisTaiwan                                            ###
#> ## An R package connecting to the Taiwan Legislative API. ###
```

#### Request Question Record

``` r
parlquestions <- get_parlquestions(term = 8, verbose = FALSE)
parlquestions_df <- parlquestions$data
```

#### Using `str_detect` from `stringr` to Find Topics

``` r
# 找看看「原住民」主題
library(stringr)
df <- parlquestions_df[str_detect(parlquestions_df[["item"]], "原住民", negate = FALSE),]
print(df[c("term", "item")])
#> # A tibble: 48 × 2
#>    term  item                                                                   
#>    <chr> <chr>                                                                  
#>  1 08    二十八、本院孔委員文吉，鑑於莫拉克颱風侵襲台灣中南部及東南部的山區，成…
#>  2 08    二十九、本院孔委員文吉、鑑於國立故宮博物院除持續致力於國內、外文物展出…
#>  3 08    三十、本院孔委員文吉，鑑於故宮博物院除應依據原住民族工作權保障法晉用原…
#>  4 08    五十八、本院黃委員昭順，針對日來「申請外籍看護」困難、「巴式量表」衍生…
#>  5 08    三、本院江委員惠貞，針對原住民同胞為我國重要族群，不僅傳承了悠久的文化…
#>  6 08    三十、本院徐委員欣瑩，有鑑於馬告國家公園在劃定範圍後因無法取得當地原住…
#>  7 08    五十七、本院黃委員昭順，對於莫拉克風災後，突顯我國山林保育沒有做好、樹…
#>  8 08    五十三、本院徐委員欣瑩，有鑑於幼兒教育及照顧法第十條規定，「離島、偏鄉…
#>  9 08    五十七、本院黃委員昭順，對於莫拉克風災後，突顯我國山林保育沒有做好、樹…
#> 10 08    一一六、本院徐委員欣瑩，有鑑於幼兒教育及照顧法第十條規定，「離島、偏鄉…
#> # … with 38 more rows
```

## Acknowledgement

The package is part of Yen-Chieh Liao’s doctoral dissertation project
[`Electoral Reform, Distributive Politics, and Parties in the Taiwanese Congress`](https://raw.githack.com/davidycliao/phd-thesis/main/Yen_Chieh_Liao_PhD_Dissertation_Jan_2023.pdf)
at the [Department of
Government](https://www.essex.ac.uk/departments/government) in
University of Essex and supported by the 2021 Taiwanese Overseas
Pioneers Grants for PhD Candidates from the National Science and
Technology Council in Taiwan.
