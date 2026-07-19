# The Records of Legislation and the Executives Proposals: 委員及政府議案提案資訊

The Records of Legislation and the Executives Proposals:
委員及政府議案提案資訊

## Usage

``` r
get_bills_2(term = 8, session_period = NULL, verbose = TRUE)
```

## Arguments

- term:

  A numeric or NULL value. Data is available from the 8th term onwards.
  Default is set to 8. 參數必須為數值。資料從第8屆開始，預設值為8。

- session_period:

  An integer, numeric, or NULL. Valid options for the session are: 1, 2,
  3, 4, 5, 6, 7, and 8. Default is set to NULL. 參數必須為數值。
  [`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)
  provides available session periods based on the Minguo (Taiwan)
  calendar.

- verbose:

  Default value is TRUE. Displays details of the retrieved data,
  including the number, URL, and computing time.

## Value

A list containing:

- `title`:

  Records of questions answered by the executives

- `query_time`:

  Query time

- `retrieved_number`:

  Number of observations

- `retrieved_term`:

  Retrieved term

- `url`:

  Retrieved JSON URL

- `variable_names`:

  Variables of the tibble dataframe

- `manual_info`:

  Official manual: <https://data.ly.gov.tw/getds.action?id=20> or use
  `get_variable_info("get_bills_2")`

- `data`:

  A tibble dataframe with variables such as:

  `term`

  :   屆別

  `sessionPeriod`

  :   會期

  `sessionTimes`

  :   會次

  `meetingTimes`

  :   臨時會會次

  `billNo`

  :   議案編號

  `billName`

  :   提案名稱

  `billOrg`

  :   提案單位/委員

  `billProposer`

  :   主提案人

  `billCosignatory`

  :   連署提案

  `billStatus`

  :   議案狀態

  `pdfUrl`

  :   PDF download link for related documents

  `docUrl`

  :   DOC download link for related documents

  `selectTerm`

  :   Filtering criteria based on term

## Details

The `get_bills_2` function produces a list, which includes `query_time`,
`retrieved_number`, `retrieved_term`, `url`, `variable_names`,
`manual_info`, and `data`. For the user manual and more information
about the dataframe, use `get_variable_info("get_bills_2")`.

## Note

For more details about the dataframe's variables, use
`get_variable_info("get_bills_2")` or visit the API manual at
<https://data.ly.gov.tw/getds.action?id=20>. 議事類:
提供委員及政府之議案提案資訊 (從第8屆第1會期開始)。

## See also

`get_variable_info("get_bills_2")`,[`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)

## Author

David Liao (davidycliao@gmail.com)

## Examples

``` r
if (FALSE) { # \dontrun{
## Query the executives' responses by term and session period.
## 輸入「立委屆期」與「會期」以下載「質詢事項 (行政院答復部分)」
get_bills_2(term = 8, session_period = 1)
} # }
```
