# The Records of Legislation and the Executives Proposals

The Records of Legislation and the Executives Proposals

## Usage

``` r
get_bills_2(term = 8, session_period = NULL, verbose = TRUE)
```

## Arguments

- term:

  A numeric or NULL value. Data is available from the 8th term onwards.
  Default is set to 8.

- session_period:

  An integer, numeric, or NULL. Valid options for the session are: 1, 2,
  3, 4, 5, 6, 7, and 8. Default is set to NULL.
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

  :   Legislative term number

  `sessionPeriod`

  :   Session period

  `sessionTimes`

  :   Session times

  `meetingTimes`

  :   Extraordinary session times

  `billNo`

  :   Bill number

  `billName`

  :   Bill title

  `billOrg`

  :   Proposing unit/legislator

  `billProposer`

  :   Primary proposer

  `billCosignatory`

  :   Co-signed proposal

  `billStatus`

  :   Bill status

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
<https://data.ly.gov.tw/getds.action?id=20>. Category: Provides
bill-proposal records for legislators and the executive (available from
the 8th term, 1st session, onwards).

## See also

`get_variable_info("get_bills_2")`,[`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)

## Author

David Liao (davidycliao@gmail.com)

## Examples

``` r
if (FALSE) { # \dontrun{
## Query the executives' responses by term and session period.
get_bills_2(term = 8, session_period = 1)
} # }
```
