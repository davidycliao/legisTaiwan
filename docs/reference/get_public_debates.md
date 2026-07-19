# The Records of National Public Debates 國是論壇

The Records of National Public Debates 國是論壇

## Usage

``` r
get_public_debates(term = NULL, session_period = NULL, verbose = TRUE)
```

## Arguments

- term:

  numeric or NULL. The default is set to 10. Legislative term number
  (e.g., 10). Data is officially available from the 8th term onwards,
  but testing shows data starts from the 10th term.

- session_period:

  numeric or NULL. Session period number (1-8). Default is NULL. Use
  [`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)
  to see available session periods in ROC calendar.

- verbose:

  logical. Whether to display download progress and detailed
  information. Default is TRUE.

## Value

A list containing:

- `title`:

  public debates records

- `query_time`:

  query timestamp

- `retrieved_number`:

  number of records retrieved

- `retrieved_term`:

  queried legislative term

- `url`:

  retrieved API URL

- `variable_names`:

  variables in the tibble dataframe

- `manual_info`:

  official manual URL or use get_variable_info("get_public_debates")

- `data`:

  a tibble dataframe containing:

  `term`

  :   屆別

  `sessionPeriod`

  :   會期

  `sessionTimes`

  :   會次

  `meetingTimes`

  :   臨時會會次

  `dateTimeDesc`

  :   日期時間說明

  `meetingRoom`

  :   會議地點

  `chairman`

  :   主持人

  `legislatorName`

  :   委員姓名

  `speakType`

  :   發言類型(paper:書面發言,speak:發言)

  `content`

  :   內容

  `selectTerm`

  :   屆別期別篩選條件

## Details

The function retrieves records from the National Public Debates
(國是論壇), including both spoken and written opinions. While officially
available from the 8th legislative term, testing indicates data is only
available from the 10th term onwards.

## Note

For more details about the data variables and API information, use
`get_variable_info("get_public_debates")` or visit the API manual at
<https://data.ly.gov.tw/getds.action?id=7>. 議事類:
提供公報之國是論壇資訊，並包含書面意見。
自第8屆第1會期起，但實測資料從第10屆。

## See also

- `get_variable_info("get_public_debates")`

- [`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)

- For ROC calendar information:
  <https://en.wikipedia.org/wiki/Republic_of_China_calendar>

## Examples

``` r
if (FALSE) { # \dontrun{
# Query public debates for term 10, session period 2
debates <- get_public_debates(term = 10, session_period = 2)

# Query without specifying session period
debates <- get_public_debates(term = 10)
} # }
```
