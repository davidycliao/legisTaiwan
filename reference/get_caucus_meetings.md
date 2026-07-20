# The Meeting Records of Cross-caucus Session

Retrieves cross-caucus negotiation meeting records from the Legislative
Yuan's V1 API.

## Usage

``` r
get_caucus_meetings(start_date = NULL, end_date = NULL, verbose = TRUE)
```

## Arguments

- start_date:

  character Must be formatted in Minguo (ROC) calendar with three
  forward slashes between year, month and day, e.g. "106/10/20".

- end_date:

  character Must be formatted in Minguo (ROC) calendar with three
  forward slashes between year, month and day, e.g. "109/01/10".

- verbose:

  logical, indicates whether `get_caucus_meetings` should print out
  detailed output when retrieving the data.

## Value

list, which contains:

- `title`:

  the meeting records of cross-caucus session

- `query_time`:

  the query time

- `retrieved_number`:

  the number of observation

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

  the official manual, <https://data.ly.gov.tw/getds.action?id=8>; or
  use get_variable_info("get_caucus_meetings")

- `data`:

  a tibble dataframe, whose variables include:

  `comVolume`

  :   Issue

  `comBookId`

  :   Book ID

  `term`

  :   Term number

  `sessionPeriod`

  :   Session period

  `meetingTimes`

  :   Extraordinary session times

  `meetingDate`

  :   Meeting date (Minguo calendar)

  `meetingName`

  :   Meeting name

  `subject`

  :   Subject

  `pageStart`

  :   Starting page

  `pageEnd`

  :   Ending page

  `docUrl`

  :   File download location

  `htmlUrl`

  :   HTML URL

  `selectTerm`

  :   Term/session filtering criteria

## Details

`get_caucus_meetings` produces a list, which contains `title`,
`query_time`, `retrieved_number`, `meeting_unit`, `start_date_ad`,
`end_date_ad`, `start_date`, `end_date`, `url`, `variable_names`,
`manual_info` and `data.`

## Note

To retrieve the user manual and more information about variable of the
data frame, please use `get_variable_info("get_caucus_meetings")` or
visit the API manual at <https://data.ly.gov.tw/getds.action?id=8>.
Category: Provides cross-caucus negotiation records from the gazette
(available from the 8th term, 1st session, onwards)

## See also

`get_variable_info("get_caucus_meetings")` Regarding Minguo calendar,
please see <https://en.wikipedia.org/wiki/Republic_of_China_calendar>.

## Author

Yen-Chieh Liao (davidycliao@gmail.com)

## Examples

``` r
## query the meeting records of cross-caucus session using a period of
## the dates in Taiwan ROC calender format with forward slash (/).
get_caucus_meetings(start_date = "106/10/20", end_date = "107/03/10")
#> Downloading caucus meetings data...
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
#>  https://data.ly.gov.tw/odw/ID8Action.action?comYear=&comVolume=&comBookId=&term=&sessionPeriod=&sessionTimes=&meetingTimes=&meetingDateS=106/10/20&meetingDateE=107/03/10&fileType=json 
#>  Date Range:  2017-10-20  to  2018-03-10 
#>  Total Meetings:  27 
#> ===================================
#> $title
#> [1] "the meeting records of cross-caucus session"
#> 
#> $query_time
#> [1] "2026-07-21 06:51:35 CST"
#> 
#> $retrieved_number
#> [1] 27
#> 
#> $start_date_ad
#> [1] "2017-10-20"
#> 
#> $end_date_ad
#> [1] "2018-03-10"
#> 
#> $start_date
#> [1] "106/10/20"
#> 
#> $end_date
#> [1] "107/03/10"
#> 
#> $url
#> [1] "https://data.ly.gov.tw/odw/ID8Action.action?comYear=&comVolume=&comBookId=&term=&sessionPeriod=&sessionTimes=&meetingTimes=&meetingDateS=106/10/20&meetingDateE=107/03/10&fileType=json"
#> 
#> $variable_names
#>  [1] "comYear"       "comVolume"     "comBookId"     "term"         
#>  [5] "sessionPeriod" "sessionTimes"  "meetingTimes"  "meetingDate"  
#>  [9] "meetingName"   "subject"       "pageStart"     "pageEnd"      
#> [13] "docUrl"        "htmlUrl"       "selectTerm"   
#> 
#> $manual_info
#> [1] "https://data.ly.gov.tw/getds.action?id=8"
#> 
#> $data
#> # A tibble: 27 × 15
#>    comYear comVolume comBookId term  sessionPeriod sessionTimes
#>    <chr>   <chr>     <chr>     <chr> <chr>         <chr>       
#>  1 103     43        "四"      08    05            12          
#>  2 103     43        "四"      08    05            12          
#>  3 106     103       "下"      null  null          null        
#>  4 106     108       ""        09    04            10          
#>  5 106     108       ""        09    04            10          
#>  6 106     113       "下"      null  null          null        
#>  7 106     113       "下"      null  null          null        
#>  8 106     116       "下"      09    04            12          
#>  9 106     87        "下"      09    04            06          
#> 10 106     87        "下"      09    04            null        
#> # ℹ 17 more rows
#> # ℹ 9 more variables: meetingTimes <chr>, meetingDate <chr>,
#> #   meetingName <chr>, subject <chr>, pageStart <chr>, pageEnd <chr>,
#> #   docUrl <chr>, htmlUrl <chr>, selectTerm <chr>
#> 
```
