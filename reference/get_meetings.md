# The Spoken Meeting Records

Provides access to legislators' spoken meeting records through the
Legislative Yuan's V1 API interface.

## Usage

``` r
get_meetings(
  start_date = NULL,
  end_date = NULL,
  meeting_unit = NULL,
  verbose = TRUE
)
```

## Arguments

- start_date:

  numeric Must be formatted in Minguo (Taiwan) calendar, e.g. 1090101.

- end_date:

  numeric Must be formatted in Minguo (Taiwan) calendar, e.g. 1090102.

- meeting_unit:

  NULL The default is NULL, which includes all meeting types between the
  starting date and the ending date.

- verbose:

  logical, indicates whether `get_meetings` should print out detailed
  output when retrieving the data.

## Value

list, which contains:

- `title`:

  the spoken meeting records

- `query_time`:

  the query time

- `retrieved_number`:

  the number of the observation

- `meeting_unit`:

  the meeting unit

- `start_date_ad`:

  the start date in POSIXct

- `end_date_ad`:

  the end date in POSIXct

- `start_date`:

  the start date in ROC Taiwan calendar

- `url`:

  the retrieved json url

- `variable_names`:

  the variables of the tibble dataframe

- `manual_info`:

  the offical manual,
  <https://www.ly.gov.tw/Pages/List.aspx?nodeid=154>; or use
  get_variable_info("get_meetings")

- `data`:

  a tibble dataframe, whose variables include:

  `meeting_status`

  :   Meeting status

  `meeting_name`

  :   Meeting name

  `meeting_content`

  :   Meeting subject

  `speechers`

  :   List of speaking legislators

  `meeting_unit`

  :   Organizing unit

  `date_ad`

  :   Gregorian year

## Details

`get_meetings` produces a list, which contains `title`, `query_time`,
`retrieved_number`, `meeting_unit`, `start_date_ad`, `end_date_ad`,
`start_date`, `end_date`, `url`, `variable_names`, `manual_info` and
`data`.

## Note

To retrieve the user manual and more information about variable of the
data frame, please use `get_variable_info("get_meetings")` or visit the
API manual at <https://www.ly.gov.tw/Pages/List.aspx?nodeid=154>. The
data appears inconsistent and needs verification; the earliest available
date for spoken meeting records is unclear and needs checking.

## See also

`get_variable_info("get_meetings")`

Regarding Minguo calendar, please see
<https://en.wikipedia.org/wiki/Republic_of_China_calendar>.

## Author

Yen-Chieh Liao (davidycliao@gmail.com)

## Examples

``` r
if (FALSE) { # \dontrun{
## query meeting records by a period of the dates in Minguo (Taiwan) calendar
get_meetings(start_date = "1050120", end_date = "1050210")

## query meeting records by a period of the dates in Minguo (Taiwan) calendar format
## and a meeting; meeting_unit is a Chinese committee name, e.g. "Interior Committee"
get_meetings(start_date = 1060120, end_date = 1070310, meeting_unit = "Interior Committee")
} # }
```
