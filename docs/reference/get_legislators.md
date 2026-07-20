# The Legislator' Demographic Information and Background

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

  :   Legislator's name (Chinese)

  `ename`

  :   Legislator's name (English)

  `sex`

  :   Gender

  `party`

  :   Political party affiliation

  `partyGroup`

  :   Party group/caucus

  `committee`

  :   Committee assignment

  `onboardDate`

  :   Onboard date (Gregorian year)

  `degree`

  :   Education background

  `experience`

  :   Work experience

  `picPath`

  :   Photo URL/path

  `leaveFlag`

  :   Leave date (Gregorian year)

  `leaveReason`

  :   Reason for leaving

## Details

This function retrieves comprehensive data about legislators including
their personal information, political background, and demographic
details. The data is available starting from the 2nd legislative term.

`get_legislators` produces a list, which contains `query_time`,
`queried_term`, `url`, `variable_names`, `manual_info` and `data`.

## Note

To retrieve the user manual and more information about variable of the
data frame, please use `get_variable_info("get_legislators")` or visit
the API manual at <https://data.ly.gov.tw/getds.action?id=16>. Provides
legislators' basic information; the earliest available data goes back to
the 2nd term.

## See also

`get_variable_info("get_legislators")`,
[`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)

## Author

Yen-Chieh Liao (davidycliao@gmail.com)

## Examples

``` r
if (FALSE) { # \dontrun{
# Get data for the 9th term
legislators_data <- get_legislators(term = 9)
legislators_data
} # }
```
