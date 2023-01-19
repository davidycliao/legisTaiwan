# legisTaiwan <img src="https://raw.githack.com/davidycliao/figures/master/hexsticker_tw.png" width="140" align="right" /> <br /> 

[![R](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml)

`legisTaiwan` is an R package for downloading the legislative data of spoken meeting records, bill sponsor/co-sponsor, and more via the [Taiwan Legislative Yuan API](https://www.ly.gov.tw/Home/Index.aspx). 



&nbsp; 
&nbsp; 


| Taiwan Legislative Yuan API    | `legisTaiwan`   |     Since   |
| ---------------------------------------------------------------------------------------------------------------- | ------------------------------ | --------------------------- |
|[**Spoken Meeting Records (委員發言)**](https://www.ly.gov.tw/Pages/List.aspx?nodeid=154)                         | [`get_meetings()`]()           |  7th* (西2011民100)         |
|[**Bill Sponsor and Co-sponsor (法律提案)**](https://www.ly.gov.tw/Pages/List.aspx?nodeid=154)                    | [`get_bills()`]()              |  7th* (西2011民100)         |
|[**Original Proceedings  (議事錄原始檔案)**](https://data.ly.gov.tw/getds.action?id=45)                           | Coming soon                    |  8th  (西2014民104)         |
|[**Legislator Demographic Information (歷屆委員資料)**](https://data.ly.gov.tw/getds.action?id=16)                | [`get_legislators()`]()        |  2th  (西1992民 81)         |
|[**The Questions Answered by the Legislative Yuan (立委質詢部分)**](https://data.ly.gov.tw/getds.action?id=6)     | [`get_parlquestions()`]()      |  8th  (西2014民104)         |
|[**The Questions Answered by the Executive Yuan (行政院答復質詢事項)**](https://data.ly.gov.tw/getds.action?id=1) | Coming soon                    |  8th  (西2014民104)         |

&nbsp; 

## Install from GitHub Using `remotes`

```
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan", force = TRUE)
library(legisTaiwan)
```
