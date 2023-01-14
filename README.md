# legisTaiwan: An Interface to Access Taiwan Legislative API <img src="https://github.com/yl17124/legisTaiwan/blob/master/images/hexsticker_tw.png" width="140" align="right" /> <br /> 

`legisTaiwan` is an R package for downloading spoken record and bill data from the [Taiwan Legislative Yuan](https://www.ly.gov.tw/Home/Index.aspx).


## Install from GitHub Using remotes.

```
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan")
```

## Quick Start

### Search Spoken Meetings

- Query without specifying meeting unit
```
get_meetings(start_date = 1060120, end_date = 1070310)
```

- Query without specifying meeting unitㄋ

```
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會&院會")

```

### Search Records of Bill Sponsor and Co-sponsor

- Query bill records without specifying legislator

```
get_bills(start_date = 1060120, end_date = 1070310)
```

- Query bill records by looking at individual legislator or more

```
get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉&鄭天財")
```




