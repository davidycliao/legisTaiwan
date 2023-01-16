# legisTaiwan: An R Package for Downloading Taiwan Legislative Data <img src="https://raw.githack.com/davidycliao/figures/master/hexsticker_tw.png" width="140" align="right" /> <br /> 

[![R](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml)

`legisTaiwan` is an R package for downloading the legislative data of spoken meeting records and bill sponsor/co-sponsor via the [Taiwan Legislative Yuan API](https://www.ly.gov.tw/Home/Index.aspx). Let's make Taiwan and our country more transparent and better. 




## Install from GitHub Using remotes.

```
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan")
```

## Quick Start

### Search Spoken Meetings

- Query by time range
```
get_meetings(start_date = 1060120, end_date = 1070310)
```

- Query without specifying a meeting unit or more

```
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會&院會")
```

### Search Records of Bill Sponsor and Co-sponsor

- Query bill records by time range

```
get_bills(start_date = 1060120, end_date = 1070310)
```

- Query bill records by specifying individual legislator or more

```
get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")
get_bills(start_date = 1060120, end_date = 1060510,  proposer = "孔文吉&鄭天財")
```




