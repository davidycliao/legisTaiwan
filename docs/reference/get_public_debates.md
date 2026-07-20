# The Records of National Public Debates

The Records of National Public Debates

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

  :   Term number

  `sessionPeriod`

  :   Session period

  `sessionTimes`

  :   Session times

  `meetingTimes`

  :   Extraordinary session times

  `dateTimeDesc`

  :   Date/time description

  `meetingRoom`

  :   Meeting room

  `chairman`

  :   Chairperson

  `legislatorName`

  :   Legislator's name

  `speakType`

  :   Speech type (paper: written statement, speak: spoken)

  `content`

  :   Content

  `selectTerm`

  :   Term/session filtering criteria

## Details

The function retrieves records from the National Public Debates,
including both spoken and written opinions. While officially available
from the 8th legislative term, testing indicates data is only available
from the 10th term onwards.

## Note

For more details about the data variables and API information, use
`get_variable_info("get_public_debates")` or visit the API manual at
<https://data.ly.gov.tw/getds.action?id=7>. Category: Provides National
Public Debate records from the gazette, including written opinions.
Officially available from the 8th term, 1st session, onwards, but
testing shows data only starts from the 10th term.

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
