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
<p align="center">
  <img width="550" height="320" src="https://raw.githack.com/davidycliao/figures/master/1.png" >
</p>

- Query by specifying a meeting

```
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
```
<p align="center">
  <img width="550" height="320" src="https://raw.githack.com/davidycliao/figures/master/2.png" >
</p>

- Query by specifying more meetings

```
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會&朝野協商")
```
<p align="center">
  <img width="550" height="320" src="https://raw.githack.com/davidycliao/figures/master/3.png" >
</p>

### Search Records of Bill Sponsor and Co-sponsor

- Query bill records by time range

```
get_bills(start_date = 1060120, end_date = 1070310)
```
<p align="center">
  <img width="550" height="320" src="https://raw.githack.com/davidycliao/figures/master/4.png" >
</p>

- Query the bill records by individual legislator 

```
get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")
```

<p align="center">
  <img width="550" height="320" src="https://raw.githack.com/davidycliao/figures/master/5.png" >
</p>


- Query the bill records by more legislators

```
get_bills(start_date = 1060120, end_date = 1060510,  proposer = "孔文吉&鄭天財")
```

<p align="center">
  <img width="550" height="320" src="https://raw.githack.com/davidycliao/figures/master/6.png" >
</p>


