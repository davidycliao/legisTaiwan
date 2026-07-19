# The Records of Response to the Questions by the Executives 公報質詢事項行政院答復資訊

Provides access to the records of parliamentary questions through the
Legislative Yuan's V1 API interface.

## Usage

``` r
get_executive_response(term = NULL, session_period = NULL, verbose = TRUE)
```

## Arguments

- term:

  integer, numeric or NULL. The default is NULL. The data is only
  available from 8th term. 參數必須為數值。資料從自第8屆起，預設值為8。

- session_period:

  integer, numeric or NULL. Available options for the session is: 1, 2,
  3, 4, 5, 6, 7, and 8. The default is set to NULL. 參數必須為數值。
  [`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)
  generates each session period available option period in Minguo
  (Taiwan) calendar.

- verbose:

  logical, indicates whether `get_executive_response` should print out
  detailed output when retrieving the data. The default is set to TRUE

## Value

list contains:

- `title`:

  the records of the questions answered by the executives

- `query_time`:

  the queried time

- `retrieved_number`:

  the total number of observations

- `retrieved_term`:

  the queried term

- `url`:

  the retrieved json url

- `variable_names`:

  the variables of the tibble dataframe

- `manual_info`:

  the offical manual

- `data`:

  a tibble dataframe, whose variables include:

  `sessionPeriod`

  :   會期

  `sessionTimes`

  :   會次

  `meetingTimes`

  :   臨時會會次

  `eyNumber`

  :   行政院函公文編號

  `lyNumber`

  :   立法院函編號

  `subject`

  :   案由

  `content`

  :   內容

  `docUrl`

  :   案由

  `item`

  :   檔案下載位置

  `item`

  :   檔案下載位置

  `selectTerm`

  :   屆別期別篩選條件

## Details

**`get_executive_response`** produces a list, which contains `title`,
`query_time`, `retrieved_number`, `retrieved_term`, `url`,
`variable_names`, `manual_info` and `data`. To retrieve the user manual
and more information, please use
`get_variable_info("get_executive_response")`.

\#'@note To retrieve the user manual and more information about variable
of the data frame, please use
`get_variable_info("get_executive_response")` or visit the API manual at
<https://data.ly.gov.tw/getds.action?id=2>. 質詢類:
提供公報質詢事項行政院答復資訊 (自第8屆第1會期起)。

## See also

`get_variable_info("get_executive_response")`,
[`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)

## Author

Yen-Chieh Liao (davidycliao@gmail.com)

## Examples

``` r
if (FALSE) { # \dontrun{
## query the Executives' answered response by term and the session period.
## 輸入「立委屆期」與「會期」下載「行政院答復」
term8 <- get_executive_response(term = 8, session_period = 1)
term8
} # }
```
