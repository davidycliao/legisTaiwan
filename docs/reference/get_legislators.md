# The Legislator' Demographic Information and Background 提供委員基本資料

Provides access to legislators' basic demographic and background
information through the Legislative Yuan's V1 API interface.

## Usage

``` r
get_legislators(term = NULL, verbose = TRUE)
```

## Arguments

- term:

  numeric or NULL The data is available from the 2nd term.

- verbose:

  logical, indicates whether get_meetings should print out detailed
  output when retrieving the data. The default is set to TRUE.

## Value

list contains:

- `query_time`:

  the queried time

- `queried_term`:

  the queried term

- `url`:

  the retrieved json url

- `variable_names`:

  the variables of the tibble dataframe

- `manual_info`:

  the official manual from <https://data.ly.gov.tw/getds.action?id=16>,
  or use legisTaiwan::get_variable_info("get_legislators")

- `data`:

  a tibble dataframe, whose variables include:

  `name`

  :   委員姓名

  `ename`

  :   委員姓名

  `sex`

  :   性別

  `party`

  :   黨籍

  `partyGroup`

  :   黨團

  `committee`

  :   委員會

  `onboardDate`

  :   到職日(西元年)

  `degree`

  :   學歷

  `experience`

  :   經歷

  `picPath`

  :   照片位址

  `leaveFlag`

  :   離職日期(西元年)

  `leaveReason`

  :   離職原因

## Details

This function retrieves comprehensive data about legislators including
their personal information, political background, and demographic
details. The data is available starting from the 2nd legislative term.

`get_legislators` produces a list, which contains `query_time`,
`queried_term`, `url`, `variable_names`, `manual_info` and `data`.

## Note

To retrieve the user manual and more information about variable of the
data frame, please use `get_variable_info("get_legislators")` or visit
the API manual at <https://data.ly.gov.tw/getds.action?id=16>.
提供委員基本資料，最早資料可追溯至第2屆。

## See also

`get_variable_info("get_legislators")`,
[`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)

## Author

Yen-Chieh Liao (davidycliao@gmail.com)

## Examples

``` r
## query the Executives' answered response by term and the session period.
## 輸入「立委屆期」與「會期」下載「行政院答復」
get_executive_response(term = 8, session_period = 1)
#> 
#> Input Format Information:
#> ------------------------
#> Term: Must be numeric (e.g., 8, 9, 10, 11)
#> Session Period: Must be numeric (1-8)
#> ------------------------
#> 
#> Downloading executive response data...
#> 
  |                                                                   
  |                                                             |   0%
  |                                                                   
  |============                                                 |  20%
  |                                                                   
  |========================                                     |  40%
  |                                                                   
  |=====================================                        |  60%
#> Warning: URL 'https://data.ly.gov.tw/odw/ID2Action.action?term=08&sessionPeriod=01&sessionTimes=&item=&fileType=json': status was 'SSL connect error'
#> 
#> 
#> Error occurred while fetching data:
#> Error: Error in open.connection(con, "rb"): cannot open the connection to 'https://data.ly.gov.tw/odw/ID2Action.action?term=08&sessionPeriod=01&sessionTimes=&item=&fileType=json'
#> 
#> Error in open.connection(con, "rb"): cannot open the connection to 'https://data.ly.gov.tw/odw/ID2Action.action?term=08&sessionPeriod=01&sessionTimes=&item=&fileType=json'

if (FALSE) { # \dontrun{
# Get data for the 9th term
legislators_data <- get_legislators(term = 9)
legislators_data
} # }
```
