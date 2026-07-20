# The Records of Parliamentary Questions

Provides access to the records of parliamentary questions through the
Legislative Yuan's V1 API interface.

## Usage

``` r
get_parlquestions(term = NULL, session_period = NULL, verbose = TRUE)
```

## Arguments

- term:

  numeric or NULL. The default is set to NULL.

- session_period:

  integer, numeric or NULL. Available options for the session is: 1, 2,
  3, 4, 5, 6, 7, and 8. The default is set to 8
  [`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)
  generates each session period available option period in Minguo
  (Taiwan) calendar.

- verbose:

  logical, indicates whether `get_parlquestions` should print out
  detailed output when retrieving the data. The default is TRUE.

## Value

A list containing:

- `title`:

  the records of parliamentary questions

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

  the offical manual from <https://data.ly.gov.tw/getds.action?id=6>, or
  use get_variable_info("get_parlquestions")

- `data`:

  a tibble dataframe, whose variables include:

  `term`

  :   Term number

  `sessionPeriod`

  :   Session period

  `sessionTimes`

  :   Session times

  `item`

  :   Item

  `selectTerm`

  :   Term/session filtering criteria

## Details

`get_parlquestions` produces a list, which contains `title`,
`query_time`, `retrieved_number`, `retrieved_term`, `url`,
`variable_names`, `manual_info`, and `data`.

## Note

To retrieve the user manual and more information about variable of the
data frame, please use `get_variable_info("get_parlquestions")` or visit
the API manual at <https://data.ly.gov.tw/getds.action?id=6>. Category:
Provides records of legislators' questions from the meeting agenda
(available from the 8th term, 1st session, onwards).

## See also

`get_variable_info("get_parlquestions")`

## Author

Yen-Chieh Liao (davidycliao@gmail.com)

## Examples

``` r
if (FALSE) { # \dontrun{
term10 <- get_parlquestions(term = 10, session_period = 1)
term10
} # }
```
