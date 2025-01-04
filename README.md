
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Real-time and Archives of Taiwan Legislative Data in R <img src="man/figures/logo.png" align="right" width="180"/>

<!-- badges: start -->

[![codecov](https://codecov.io/gh/davidycliao/legisTaiwan/branch/master/graph/badge.svg?token=HVVTCOE90D)](https://codecov.io/gh/davidycliao/legisTaiwan)
[![R-CMD-check](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml)
[![Test
coverage](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml)
[![pkgdown](https://github.com/davidycliao/legisTaiwan/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/pkgdown.yaml)
[![CodeFactor](https://www.codefactor.io/repository/github/davidycliao/legistaiwan/badge)](https://www.codefactor.io/repository/github/davidycliao/legistaiwan)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7633962.svg)](https://doi.org/10.5281/zenodo.7633962)
<!-- badges: end -->

<!-- <div style="text-align: justify"> -->

<!-- `legisTaiwan` is designed to streamline access to real-time archives of Taiwan's legislative data, drawing inspiration from the UK's TheyWorkForYou API. By providing straightforward access to the Taiwan Legislative Yuan API in R, this package not only aims to enhance legislative accountability and public transparency but also serves as a powerful tool for academic research. Scholars can easily retrieve and analyze legislative data including voting records, parliamentary questions, and bill proposals, facilitating quantitative research and empirical analysis. As the package interfaces directly with Legislative Yuan API endpoints, a stable internet connection is required. Users are welcome to contact [the author](https://davidycliao.github.io) for any API implementation assistance. -->

<!-- </div> -->

<div style="text-align: justify; font-size: 1.1rem; line-height: 1.6; color: #333; max-width: 800px; margin: 1rem auto; padding: 0 1rem; font-family: 'Helvetica Neue', Arial, sans-serif;">

`legisTaiwan` is designed to streamline access to real-time archives of
Taiwan’s legislative data, drawing inspiration from the UK’s
TheyWorkForYou API. By providing straightforward access to the Taiwan
Legislative Yuan API in R, this package not only aims to enhance
legislative accountability and public transparency but also serves as a
powerful tool for academic research. Scholars can easily retrieve and
analyze legislative data including voting records, parliamentary
questions, and bill proposals, facilitating quantitative research and
empirical analysis. As the package interfaces directly with Legislative
Yuan API endpoints, a stable internet connection is required. Users are
welcome to contact
<a href="https://davidycliao.github.io" style="color: #3498db; text-decoration: none; border-bottom: 1px solid #3498db;">the
author</a> for any API implementation assistance.

</div>

<div style="text-align: justify; font-size: 0.95rem; line-height: 1.6; color: #333; max-width: 800px; margin: 1rem auto; padding: 0 1rem; font-family: 'Helvetica Neue', Arial, sans-serif;">

`legisTaiwan`
套件旨在簡化台灣立法院資料的即時存取，其設計理念來自於英國的
TheyWorkForYou API。透過在 R 環境中提供直接連接立法院開放資料 API
的便捷管道，本套件不僅致力於提升立法問責制和公共透明度，更為學術研究者提供了系統化分析立法數據的工具。研究人員可以輕鬆獲取並分析立法委員的表決紀錄、問政質詢、法案提案等資料，有助於量化研究和實證分析。由於套件需要直接與立法院
API 介接，使用時請確保網路連線穩定。如有任何 API
使用上的問題，歡迎與套件<a href="https://davidycliao.github.io" style="color: #3498db; text-decoration: none; border-bottom: 1px solid #3498db;">作者</a>聯繫。

</div>

<br>

### Get Started with Using [`remotes`](https://github.com/r-lib/remotes):

``` r
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan", force = TRUE)
```

    library(legisTaiwan)
    #> ## legisTaiwan                                            ##
    #> ## An R package connecting to the Taiwan Legislative API. ##

### Summary Descriptive of Taiwan Legilative Yuan API

**Legislative Bills Statistics**

``` r
analyze_bills(stats)
#> 
#> === Bill Statistics Summary ===
#> Total Bills: 131762
#> Last Updated: 2025-01-04 19:18:56
#> 
#> First Five Terms Bill Count:
#>   term count percentage cumulative
#> 1   11  8270       6.28       8270
#> 2   10 43018      32.65      51288
#> 3    9 30792      23.37      82080
#> 4    8 26284      19.95     108364
#> 5    7 15726      11.94     124090
```

**Legislative Meeting Statistics**

``` r
analyze_meetings(stats)
#> 
#> === Meeting Statistics Summary ===
#> Total Meetings: 7111
#> 
#> Meeting Records Statistics by Term:
#>   term count    max_meeting_date meetdata_count 議事錄_count minutes_ratio
#> 1   11   635 2025-01-09 00:00:00            610          417         65.67
#> 2   10  2267 2024-05-17 01:00:00           2146         1602         70.67
#> 3    9  2390 2020-01-22 00:00:00           2237         1614         67.53
#> 4    8  1818 2015-12-18 00:00:00           1434         1468         80.75
#> 5    6     1                <NA>              0            1        100.00
#>   last_meeting_date
#> 1        2025-01-09
#> 2        2024-05-17
#> 3        2020-01-22
#> 4        2015-12-18
#> 5              <NA>
```

**Legislative Video (IVOD) Statistics**

``` r
analyze_ivod(stats)
#> 
#> === Video Statistics Summary ===
#> Total Videos: 88986
#> Data Period: 2005-03-14 to 2025-01-03
#> 
#> Video Statistics by Term:
#>   term count          start_date            end_date start_date_fmt
#> 1   11  9961 2024-02-05 07:00:00 2025-01-03 01:00:00     2024-02-05
#> 2   10 33852 2020-02-14 06:00:00 2024-01-09 01:00:00     2020-02-14
#> 3    9 34167 2016-02-19 01:00:00 2020-01-20 01:00:00     2016-02-19
#> 4    8  9608 2012-02-24 01:00:00 2015-12-18 01:00:00     2012-02-24
#> 5    7  1364 2008-02-29 01:00:00 2011-12-14 01:00:00     2008-02-29
#>   end_date_fmt period_days avg_daily_videos
#> 1   2025-01-03     332.750            29.94
#> 2   2024-01-09    1424.792            23.76
#> 3   2020-01-20    1431.000            23.88
#> 4   2015-12-18    1393.000             6.90
#> 5   2011-12-14    1384.000             0.99
```

<!-- ```{r include=FALSE} -->

<!-- create_interactive_plot(stats) -->

<!-- ``` -->

<br>

### Important Notice: API Migration

<div style="text-align: justify; font-size: 1.1rem; line-height: 1.6; color: #333; max-width: 800px; margin: 1rem auto; padding: 0 1rem; font-family: 'Helvetica Neue', Arial, sans-serif;">

<!-- `legisTaiwan` requires a stable internet connection to retrieve data -->

<!-- from the API. While most functions can fetch data spanning a long -->

<!-- period, they tend to be bandwidth-intensive due to the size of the -->

<!-- datasets. If you plan to download data over an extended period, I -->

<!-- recommend using `get_variable_info()` first to verify the current file -->

<!-- sizes on the API. Also, consider writing a batch retrieval -->

<!-- process with appropriate handlers to track the progress of file input, -->

<!-- ensuring the completeness of the requested data. -->

The Legislative Yuan API has transitioned from `https://ly.govapi.tw` to
`https://v2.ly.govapi.tw`. While we are maintaining support for
functions that use the legacy API, please note that the old API endpoint
will eventually be deprecated. We recommend users to gradually
transition to the newer API versions as they become available.

</div>

<br>

<!-- ### Acknowledgments -->

<!-- <div style="text-align: justify"> -->

<!-- This package supported the author's doctoral dissertation *"Electoral Reform, Distributive Politics, and Parties in the Taiwanese Congress"* at the University of Essex. The PhD project was made possible through the generous funding of the 2022 Taiwan Ministry of Science and Technology (MOST) TOP Grant and a full PhD fellowship from the Ministry of Education (2018-2021), Taiwan. The author extends sincere gratitude to the Legislative Yuan API Center for their technical assistance and commitment to data transparency. -->

<!-- </div> -->
