# The Spoken Meeting Records 委員發言

Provides access to legislators' spoken meeting records through the
Legislative Yuan's V1 API interface.

## Usage

``` r
get_meetings(
  start_date = NULL,
  end_date = NULL,
  meeting_unit = NULL,
  verbose = TRUE
)
```

## Arguments

- start_date:

  numeric Must be formatted in Minguo (Taiwan) calendar, e.g. 1090101.

- end_date:

  numeric Must be formatted in Minguo (Taiwan) calendar, e.g. 1090102.

- meeting_unit:

  NULL The default is NULL, which includes all meeting types between the
  starting date and the ending date.

- verbose:

  logical, indicates whether `get_meetings` should print out detailed
  output when retrieving the data.

## Value

list, which contains:

- `title`:

  the spoken meeting records

- `query_time`:

  the query time

- `retrieved_number`:

  the number of the observation

- `meeting_unit`:

  the meeting unit

- `start_date_ad`:

  the start date in POSIXct

- `end_date_ad`:

  the end date in POSIXct

- `start_date`:

  the start date in ROC Taiwan calendar

- `url`:

  the retrieved json url

- `variable_names`:

  the variables of the tibble dataframe

- `manual_info`:

  the offical manual,
  <https://www.ly.gov.tw/Pages/List.aspx?nodeid=154>; or use
  get_variable_info("get_meetings")

- `data`:

  a tibble dataframe, whose variables include:

  `meeting_status`

  :   會議狀態

  `meeting_name`

  :   會議名稱

  `meeting_content`

  :   會議事由

  `speechers`

  :   委員發言名單

  `meeting_unit`

  :   主辦單位

  `date_ad`

  :   西元年

## Details

`get_meetings` produces a list, which contains `title`, `query_time`,
`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`,
`start_date`, `end_date`, `url`, `variable_names`, `manual_info` and
`data`.

## Note

To retrieve the user manual and more information about variable of the
data frame, please use `get_variable_info("get_meetings")` or visit the
API manual at <https://www.ly.gov.tw/Pages/List.aspx?nodeid=154>.
資料似乎不一致，待確認。委員發言（取得最早時間不詳，待檢查。）

## See also

`get_variable_info("get_meetings")`

Regarding Minguo calendar, please see
<https://en.wikipedia.org/wiki/Republic_of_China_calendar>.

## Author

Yen-Chieh Liao (davidycliao@gmail.com)

## Examples

``` r
## query meeting records by a period of the dates in Minguo (Taiwan) calendar
## 輸入「中華民國民年」下載「委員發言」
get_meetings(start_date = "1050120", end_date = "1050210")
#> 
#> Input Format Information:
#> ------------------------
#> Date Format: YYYMMDD (ROC calendar)
#> Example: 1090101 for 2020/01/01
#> ------------------------
#> 
#> Downloading meeting records data...
#> 
  |                                                                   
  |                                                             |   0%
  |                                                                   
  |============                                                 |  20%
  |                                                                   
  |========================                                     |  40%
  |                                                                   
  |=====================================                        |  60%
  |                                                                   
  |=================================================            |  80%
  |                                                                   
  |=============================================================| 100%
#> 
#> 
#> ====== Retrieved Information ======
#> -----------------------------------
#>  URL: 
#>  https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=1050120&to=1050210&meeting_unit=&mode=json 
#>  Date Range:  2016-01-20  to  2016-02-10 
#>  Total Records:  1 
#> ===================================
#> $title
#> [1] "Meeting Records"
#> 
#> $query_time
#> [1] "2026-07-20 00:25:13 CST"
#> 
#> $retrieved_number
#> [1] 1
#> 
#> $meeting_unit
#> NULL
#> 
#> $start_date_ad
#> [1] "2016-01-20"
#> 
#> $end_date_ad
#> [1] "2016-02-10"
#> 
#> $start_date
#> [1] "1050120"
#> 
#> $end_date
#> [1] "1050210"
#> 
#> $url
#> [1] "https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=1050120&to=1050210&meeting_unit=&mode=json"
#> 
#> $variable_names
#> [1] "smeeting_date"   "meeting_status"  "meeting_name"   
#> [4] "meeting_content" "speechers"       "meeting_unit"   
#> [7] "date_ad"        
#> 
#> $manual_info
#> [1] "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154"
#> 
#> $data
#> # A tibble: 1 × 7
#>   smeeting_date meeting_status meeting_name   meeting_content speechers
#>   <chr>         <chr>          <chr>          <chr>           <lgl>    
#> 1 105/02/01     散會(15:55)    第9屆立法院預備會議…… 第9屆立法委員報到、就職宣誓… NA       
#> # ℹ 2 more variables: meeting_unit <chr>, date_ad <date>
#> 

## query meeting records by a period of the dates in Minguo (Taiwan) calendar format
## and a meeting
## 輸入「中華民國民年」與「審查會議或委員會名稱」下載會議審查資訊
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "內政委員會")
#> 
#> Input Format Information:
#> ------------------------
#> Date Format: YYYMMDD (ROC calendar)
#> Example: 1090101 for 2020/01/01
#> ------------------------
#> 
#> Downloading meeting records data...
#> 
  |                                                                   
  |                                                             |   0%
  |                                                                   
  |============                                                 |  20%
  |                                                                   
  |========================                                     |  40%
  |                                                                   
  |=====================================                        |  60%
  |                                                                   
  |=================================================            |  80%
  |                                                                   
  |=============================================================| 100%
#> 
#> 
#> ====== Retrieved Information ======
#> -----------------------------------
#>  URL: 
#>  https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=1060120&to=1070310&meeting_unit=內政委員會&mode=json 
#>  Meeting Unit:  內政委員會 
#>  Date Range:  2017-01-20  to  2018-03-10 
#>  Total Records:  104 
#> ===================================
#> $title
#> [1] "Meeting Records"
#> 
#> $query_time
#> [1] "2026-07-20 00:25:13 CST"
#> 
#> $retrieved_number
#> [1] 104
#> 
#> $meeting_unit
#> [1] "內政委員會"
#> 
#> $start_date_ad
#> [1] "2017-01-20"
#> 
#> $end_date_ad
#> [1] "2018-03-10"
#> 
#> $start_date
#> [1] 1060120
#> 
#> $end_date
#> [1] 1070310
#> 
#> $url
#> [1] "https://www.ly.gov.tw/WebAPI/LegislativeSpeech.aspx?from=1060120&to=1070310&meeting_unit=內政委員會&mode=json"
#> 
#> $variable_names
#> [1] "smeeting_date"   "meeting_status"  "meeting_name"   
#> [4] "meeting_content" "speechers"       "meeting_unit"   
#> [7] "date_ad"        
#> 
#> $manual_info
#> [1] "https://www.ly.gov.tw/Pages/List.aspx?nodeid=154"
#> 
#> $data
#> # A tibble: 104 × 7
#>    smeeting_date meeting_status meeting_name  meeting_content speechers
#>    <chr>         <chr>          <chr>         <chr>           <chr>    
#>  1 107/03/08     散會(10:58)    立法院第9屆第5會期內政… "選舉本會召集委員"……  NA      
#>  2 106/12/28     散會(17:05)    立法院第9屆第4會期內政… "一、繼續審查原住民族委員會…  NA      
#>  3 106/12/27     散會(17:36)    立法院第9屆第4會期內政… "一、繼續審查委員王榮璋等1…  NA      
#>  4 106/12/25     散會(12:50)    立法院第9屆第4會期內政… "一、都市更新條例：（一）審… " 0001 曾…
#>  5 106/12/25     散會(16:56)    立法院第9屆第4會期內政… " "              NA      
#>  6 106/12/22     會議結束       立法院朝野黨團協商…… "本院內政委員會報告併案審查…  NA      
#>  7 106/12/21     散會(16:46)    立法院第9屆第4會期內政… "一、審查「國籍法」：\r\… " 0001 曾…
#>  8 106/12/20     休息           立法院第9屆第4會期內政… "一、繼續審查「原住民身分法… " 0001 黃…
#>  9 106/12/18     散會(16:15)    立法院第9屆第4會期內政… "一、繼續審查107年度中央…  NA      
#> 10 106/12/14     散會(14:30)    立法院第9屆第4會期內政… "一、審查委員洪宗熠等18人… " 0001 曾…
#> # ℹ 94 more rows
#> # ℹ 2 more variables: meeting_unit <chr>, date_ad <date>
#> 
```
