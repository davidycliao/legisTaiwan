# The Records of Response to the Questions by the Executives

Provides access to the records of parliamentary questions through the
Legislative Yuan's V1 API interface.

## Usage

``` r
get_executive_response(term = NULL, session_period = NULL, verbose = TRUE)
```

## Arguments

- term:

  integer, numeric or NULL. The default is NULL. The data is only
  available from 8th term.

- session_period:

  integer, numeric or NULL. Available options for the session is: 1, 2,
  3, 4, 5, 6, 7, and 8. The default is set to NULL.
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

  :   Session period

  `sessionTimes`

  :   Session times

  `meetingTimes`

  :   Extraordinary session times

  `eyNumber`

  :   Executive Yuan document reference number

  `lyNumber`

  :   Legislative Yuan document reference number

  `subject`

  :   Subject

  `content`

  :   Content

  `docUrl`

  :   Subject

  `item`

  :   File download location

  `item`

  :   File download location

  `selectTerm`

  :   Term/session filtering criteria

## Details

**`get_executive_response`** produces a list, which contains `title`,
`query_time`, `retrieved_number`, `retrieved_term`, `url`,
`variable_names`, `manual_info` and `data`. To retrieve the user manual
and more information, please use
`get_variable_info("get_executive_response")`.

\#'@note To retrieve the user manual and more information about variable
of the data frame, please use
`get_variable_info("get_executive_response")` or visit the API manual at
<https://data.ly.gov.tw/getds.action?id=2>. Category: Provides records
of the Executive Yuan's responses to legislators' questions in the
gazette (available from the 8th term, 1st session, onwards).

## See also

`get_variable_info("get_executive_response")`,
[`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)

## Author

Yen-Chieh Liao (davidycliao@gmail.com)

## Examples

``` r
if (FALSE) { # \dontrun{
## query the Executives' answered response by term and the session period.
term8 <- get_executive_response(term = 8, session_period = 1)
term8
} # }
```
