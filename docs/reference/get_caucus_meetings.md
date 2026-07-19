# The Meeting Records of Cross-caucus Session 黨團協商資訊

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

  :   期

  `comBookId`

  :   冊別

  `term`

  :   屆別

  `sessionPeriod`

  :   會期

  `meetingTimes`

  :   臨時會會次

  `meetingDate`

  :   會議日期(民國年)

  `meetingName`

  :   會議名稱

  `subject`

  :   案由

  `pageStart`

  :   起始頁

  `pageEnd`

  :   結束頁

  `docUrl`

  :   檔案下載位置

  `htmlUrl`

  :   html網址

  `selectTerm`

  :   屆別期別篩選條件

## Details

`get_caucus_meetings` produces a list, which contains `title`,
`query_time`, `retrieved_number`, `meeting_unit`, `start_date_ad`,
`end_date_ad`, `start_date`, `end_date`, `url`, `variable_names`,
`manual_info` and `data.`

## Note

To retrieve the user manual and more information about variable of the
data frame, please use `get_variable_info("get_caucus_meetings")` or
visit the API manual at <https://data.ly.gov.tw/getds.action?id=8>.
議事類:提供公報之黨團協商資訊 (自第8屆第1會期起)

## See also

`get_variable_info("get_caucus_meetings")` Regarding Minguo calendar,
please see <https://en.wikipedia.org/wiki/Republic_of_China_calendar>.

## Author

Yen-Chieh Liao (davidycliao@gmail.com)

## Examples

``` r
## query the meeting records of cross-caucus session using a period of
## the dates in Taiwan ROC calender format with forward slash (/).
## 輸入「中華民國民年」下載「黨團協商」，輸入時間請依照該格式 "106/10/20"，
## 需有「正斜線」做隔開。
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
#> Warning: URL 'https://data.ly.gov.tw/odw/ID8Action.action?comYear=&comVolume=&comBookId=&term=&sessionPeriod=&sessionTimes=&meetingTimes=&meetingDateS=106/10/20&meetingDateE=107/03/10&fileType=json': status was 'SSL connect error'
#> 
#> 
#> Error in open.connection(con, "rb"): cannot open the connection to 'https://data.ly.gov.tw/odw/ID8Action.action?comYear=&comVolume=&comBookId=&term=&sessionPeriod=&sessionTimes=&meetingTimes=&meetingDateS=106/10/20&meetingDateE=107/03/10&fileType=json'
```
