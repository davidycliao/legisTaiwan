# legisTaiwan: *Downloading the Real-time and Archives of Taiwan Legislative Data in R*   <img src="https://raw.githack.com/davidycliao/figures/master/hexsticker_tw.png" width="140" align="right" /> <br /> 

[![R](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml) [![codecov](https://codecov.io/gh/davidycliao/legisTaiwan/branch/master/graph/badge.svg?token=HVVTCOE90D)](https://codecov.io/gh/davidycliao/legisTaiwan)
[![R-CMD-check](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml)


&nbsp; 


`legisTaiwan` is an R package for downloading real-time legislative data of spoken meeting records, bill sponsor/co-sponsor, and ***more*** via the [Taiwan Legislative Yuan API](https://www.ly.gov.tw/Home/Index.aspx). 



###### [我們還在測試代碼，如果有任何問個歡迎聯繫我們。]()




&nbsp; 

## Overview

| `legisTaiwan`                 |   Since (AD/ROC)       |  Taiwan Legislative Yuan API |
|-------------------------------|---------------------|------------------------------|
|[`get_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills.html)           |  7th* (2011/100) | [**Spoken Meeting Records (委員發言)**](https://www.ly.gov.tw/Pages/List.aspx?nodeid=154)                         |
|[`get_bills()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills.html)              |  7th* (2011/100) | [**Bill Sponsors and Co-sponsors (法律提案)**](https://www.ly.gov.tw/Pages/List.aspx?nodeid=154)                    |
|[`get_legislators()`](https://davidycliao.github.io/legisTaiwan/reference/get_legislators.html)        |  2th  (1992/81) | [**Legislator Demographics (歷屆委員資料)**](https://data.ly.gov.tw/getds.action?id=16)                |
|[`get_parlquestions()`](https://davidycliao.github.io/legisTaiwan/reference/get_parlquestions.html)      |  8th  (2014/104) | [**Questions Asked by Legislators (立委質詢)**](https://data.ly.gov.tw/getds.action?id=6)     |
| [`get_executive_response()`](https://davidycliao.github.io/legisTaiwan/reference/get_executive_response.html)                |  8th  (2014/104) | [**Questions Answered by the Executives (行政院答復質詢事項)**](https://data.ly.gov.tw/getds.action?id=1) |

&nbsp; 

## Install from GitHub Using `remotes`

```
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan", force = TRUE)
```

```
library(legisTaiwan)
```

&nbsp; 

## Acknowledge
The R pacakge is part of Yen-Chieh Liao's doctoral dissertation project [Electoral Reform, Distributive Politics, and Parties in the Taiwanese Congress
](https://raw.githack.com/davidycliao/phd-thesis/main/Yen_Chieh_Liao_PhD_Dissertation_Jan_2023.pdf) at the [Department of Government](https://www.essex.ac.uk/departments/government) in University of Essex and supported by the 2021 Taiwanese Overseas Pioneers Grants for PhD Candidates from the National Science and Technology Council in Taiwan, August 2021 - August 2022.

&nbsp; 

## Cite
```
@phdthesis{davidycliao2022,
    title    = {Electoral Reform, Distributive Politics, and Parties in the Taiwanese Congress},
    school   = {Department of Government, University of Essex},
    author   = {Yen-Chieh Liao},
    year     = {2022},
    type     = {{PhD} Dissertation},
}
```



