# The Records of the Bills

The Records of the Bills

## Usage

``` r
get_bills(start_date = NULL, end_date = NULL, proposer = NULL, verbose = TRUE)
```

## Arguments

- start_date:

  numeric. Must be formatted in the ROC Taiwan calendar, e.g., 1090101.

- end_date:

  numeric. Must be formatted in the ROC Taiwan calendar, e.g., 1090102.

- proposer:

  The default value is NULL, indicating that bills proposed by all
  legislators are included between the start and end dates.

- verbose:

  logical. Specifies whether `get_bills` should print out detailed
  output when retrieving the data. The default value is TRUE.

## Value

A list, which contains:

- `title`:

  Records of cross-caucus sessions

- `query_time`:

  Query timestamp

- `retrieved_number`:

  Number of observations retrieved

- `meeting_unit`:

  Meeting unit

- `start_date_ad`:

  Start date in POSIXct format

- `end_date_ad`:

  End date in POSIXct format

- `start_date`:

  Start date in the ROC Taiwan calendar

- `url`:

  URL of the retrieved JSON data

- `variable_names`:

  Variable names of the tibble dataframe

- `manual_info`:

  Official manual. See
  <https://www.ly.gov.tw/Pages/List.aspx?nodeid=153> or use
  get_variable_info("get_bills")

- `data`:

  A tibble dataframe with the following variables:

  `sessionPeriod`

  :   Session period

  `sessionTimes`

  :   Session count

  `meetingTimes`

  :   Proposal date

  `billName`

  :   Bill name

  `billProposer`

  :   Primary proposer

  `billCosignatory`

  :   Co-signatories of the bill

  `billStatus`

  :   Status of the bill

  `date_ad`

  :   Date in the Gregorian calendar

## Details

The `get_bills` function returns a list that contains `query_time`,
`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`,
`start_date`, `end_date`, `url`, `variable_names`, `manual_info`, and
`data`.

## Note

To retrieve the user manual and more details about the data frame, use
`get_variable_info("get_bills")`. Further checks are required as the
user manual seems to be inconsistent with the actual data.

## See also

<https://www.ly.gov.tw/Pages/List.aspx?nodeid=153>

## Author

David Liao (davidycliao@gmail.com)

## Examples

``` r
if (FALSE) { # \dontrun{
## Query bill records by a date range in the Taiwan ROC calendar format
get_bills(start_date = 1060120, end_date = 1070310, verbose = TRUE)

## Query bill records by a date range and a specific legislator
get_bills(start_date = 1060120, end_date = 1070310,  proposer = "Kung Wen-chi")

## Query bill records by a date range and multiple legislators
get_bills(start_date = 1060120, end_date = 1060510,  proposer = "Kung Wen-chi&Cheng Tien-tsai")
} # }
```
