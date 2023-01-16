# legisTaiwan: An R Package for Downloading Taiwan Legislative Data <img src="https://raw.githack.com/davidycliao/figures/master/hexsticker_tw.png" width="140" align="right" /> <br /> 

[![R](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/r.yml)

`legisTaiwan` is an R package for downloading the legislative data of spoken meeting records and bill sponsor/co-sponsor via the [Taiwan Legislative Yuan API](https://www.ly.gov.tw/Home/Index.aspx). 


使用上有任何問題歡迎email我 ~

Let's make Taiwan and our country more transparent and better. 




## Install from GitHub Using remotes.

```
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan", force = TRUE)
library(legisTaiwan)
```

## Quick Start

### Search Spoken Meetings

```
# query meeting records by a period of the dates in Taiwan ROC calender format
# 輸入「中華民國民年」下載會議審查資訊
get_meetings(start_date = 1060120, end_date = 1070310)
```
<p align="center">
  <img width="950" height="280" src="https://raw.githack.com/davidycliao/figures/master/1.png" >
</p>

```
# query meeting records by a period of the dates in Taiwan ROC calender format 
# and a meeting
# 輸入「中華民國民年」與「審查會議或委員會名稱」下載會議審查資訊
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
```
<p align="center">
  <img width="950" height="280" src="https://raw.githack.com/davidycliao/figures/master/2.png" >
</p>

```
# query meeting records by a period of the dates in Taiwan ROC calender format 
# and multiple meetings
# 輸入「中華民國民年」與「多個審查會議或委員會名稱」下載會議審查資訊
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會&朝野協商")
```
<p align="center">
  <img width="950" height="280" src="https://raw.githack.com/davidycliao/figures/master/3.png" >
</p>

### Search Records of Bill Sponsor and Co-sponsor

```
# query bill records by a period of the dates in Taiwan ROC calender format
# 輸入「中華民國民年」下載立法委員提案資料
get_bills(start_date = 1060120, end_date = 1070310)
```
<p align="center">
  <img width="950" height="280" src="https://raw.githack.com/davidycliao/figures/master/4.png" >
</p>

```
# query bill records by a period of the dates in Taiwan ROC calender format 
# and a specific legislator 
# 輸入「中華民國民年」與「指定立法委員」下載立法委員提案資料
get_bills(start_date = 1060120, end_date = 1070310,  proposer = "孔文吉")
```
<p align="center">
  <img width="950" height="280" src="https://raw.githack.com/davidycliao/figures/master/5.png" >
</p>

```
# query bill records by a period of the dates in Taiwan ROC calender format 
# and multiple legislators 
# 輸入「中華民國民年」與「指定多個立法委員」下載立法委員提案資料
get_bills(start_date = 1060120, end_date = 1060510,  proposer = "孔文吉&鄭天財")
```
<p align="center">
  <img width="950" height="260" src="https://raw.githack.com/davidycliao/figures/master/6.png" >
</p>


