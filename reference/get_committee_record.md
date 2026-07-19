# The Records of Reviewed Items in the Committees 委員會會議審查之議案項目

The Records of Reviewed Items in the Committees 委員會會議審查之議案項目

## Usage

``` r
get_committee_record(term = 10, session_period = NULL, verbose = TRUE)
```

## Arguments

- term:

  numeric or null. Data is available only from the 8th term. The default
  is set to 10.
  參數必須為數值。提供委員會會議審查之議案項目。(自第10屆第1會期起)

- session_period:

  integer, numeric or NULL.
  [`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)
  provides each session period's available options based on the Minguo
  (Taiwan) calendar.

- verbose:

  logical. This indicates whether `get_executive_response` should print
  a detailed output during data retrieval. Default is TRUE.

## Value

A list containing:

- `title`:

  Records of questions answered by executives

- `query_time`:

  Time of query

- `retrieved_number`:

  Total number of observations

- `retrieved_term`:

  Queried term

- `url`:

  Retrieved JSON URL

- `variable_names`:

  Variables of the tibble dataframe

- `manual_info`:

  Official manual, <https://data.ly.gov.tw/getds.action?id=46>; or use
  get_variable_info("get_committee_record")

- `data`:

  A tibble dataframe with variables:

  `term`

  :   Term number

  `sessionPeriod`

  :   Session

  `meetingNo`

  :   Meeting number

  `billNo`

  :   Bill number

  `selectTerm`

  :   Term selection filter

A list containing:

- `title`:

  Records of questions answered by executives

- `query_time`:

  Time of query

- `retrieved_number`:

  Total number of observations

- `retrieved_term`:

  Queried term

- `url`:

  Retrieved JSON URL

- `variable_names`:

  Variables of the tibble dataframe

- `manual_info`:

  Official manual, <https://data.ly.gov.tw/getds.action?id=46>; or use
  get_variable_info("get_committee_record")

- `data`:

  A tibble dataframe with variables:

  `term`

  :   Term number

  `sessionPeriod`

  :   Session

  `meetingNo`

  :   Meeting number

  `billNo`

  :   Bill number

  `selectTerm`

  :   Term selection filter

## Details

`get_committee_record` provides a list which includes `title`,
`query_time`, `retrieved_number`, `retrieved_term`, `url`,
`variable_names`, `manual_info`, and `data`.

`get_committee_record` provides a list which includes `title`,
`query_time`, `retrieved_number`, `retrieved_term`, `url`,
`variable_names`, `manual_info`, and `data`.

## Note

To access the user manual and more information about the data frame's
variables, please refer to `get_variable_info("get_committee_record")`
or check the API manual at <https://data.ly.gov.tw/getds.action?id=46>.
This provides agenda items reviewed in committee meetings (from the 10th
term, 1st session onwards).

To access the user manual and more information about the data frame's
variables, please refer to `get_variable_info("get_committee_record")`
or check the API manual at <https://data.ly.gov.tw/getds.action?id=46>.
This provides agenda items reviewed in committee meetings (from the 10th
term, 1st session onwards).

## See also

`get_variable_info("get_committee_record")`,
[`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)
The Records of Reviewed Items in the Committees 委員會會議審查之議案項目

`get_variable_info("get_committee_record")`,
[`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)

## Author

David Yen-Chieh Liao

## Examples

``` r
## Query the committee record by term and session period.
## 輸入「立委屆期」與「會期」下載「委員會審議之議案」
get_committee_record(term = 10, session_period = 1)
#> 
#> Input Format Information:
#> ------------------------
#> Term: Must be numeric (e.g., 8, 9, 10)
#> Session Period: Must be numeric (1-8)
#> ------------------------
#> 
#> Downloading committee records data...
#> 
  |                                                                   
  |                                                             |   0%
  |                                                                   
  |============                                                 |  20%
  |                                                                   
  |========================                                     |  40%
  |                                                                   
  |=====================================                        |  60%
#> Warning: URL 'https://data.ly.gov.tw/odw/ID46Action.action?term=10&sessionPeriod=01&sessionTimes=01&meetingTimes=&fileType=json': status was 'SSL connect error'
#> 
#> 
#> Error in open.connection(con, "rb"): cannot open the connection to 'https://data.ly.gov.tw/odw/ID46Action.action?term=10&sessionPeriod=01&sessionTimes=01&meetingTimes=&fileType=json'

## Query the committee record by term and session period.
## 輸入「立委屆期」與「會期」下載「委員會審議之議案」
get_committee_record(term = 10, session_period = 1)
#> 
#> Input Format Information:
#> ------------------------
#> Term: Must be numeric (e.g., 8, 9, 10)
#> Session Period: Must be numeric (1-8)
#> ------------------------
#> 
#> Downloading committee records data...
#> 
  |                                                                   
  |                                                             |   0%
  |                                                                   
  |============                                                 |  20%
  |                                                                   
  |========================                                     |  40%
  |                                                                   
  |=====================================                        |  60%
#> Warning: URL 'https://data.ly.gov.tw/odw/ID46Action.action?term=10&sessionPeriod=01&sessionTimes=01&meetingTimes=&fileType=json': status was 'SSL connect error'
#> 
#> 
#> Error in open.connection(con, "rb"): cannot open the connection to 'https://data.ly.gov.tw/odw/ID46Action.action?term=10&sessionPeriod=01&sessionTimes=01&meetingTimes=&fileType=json'
```
