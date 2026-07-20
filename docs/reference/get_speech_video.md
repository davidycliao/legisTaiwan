# The Video Information of Meetings and Committees

Retrieves video records and information of legislative meetings and
committee sessions, including speech segments, meeting details, and
video URLs. Data is available in both JSON and CSV formats from the 9th
legislative term onwards.

## Usage

``` r
get_speech_video(
  term = NULL,
  session_period = NULL,
  start_date = NULL,
  end_date = NULL,
  verbose = TRUE,
  format = "json"
)
```

## Arguments

- term:

  numeric or NULL. Legislative term number (e.g., 10). Data is available
  from the 9th term onwards. Default is NULL.

- session_period:

  numeric or NULL. Session period number (1-8). Default is NULL.

- start_date:

  character. Must be formatted in ROC calendar with forward slashes
  between year, month and day, e.g., "110/10/01".

- end_date:

  character. Must be formatted in ROC calendar with forward slashes
  between year, month and day, e.g., "110/10/30".

- verbose:

  logical. Whether to display download progress and detailed
  information. Default is TRUE.

- format:

  character. Data format to retrieve, either "json" or "csv". Default is
  "json".

## Value

A list containing:

- `title`:

  speech video records

- `query_time`:

  query timestamp

- `retrieved_number`:

  number of videos retrieved

- `term`:

  queried legislative term

- `session_period`:

  queried session period

- `start_date`:

  start date in ROC calendar

- `end_date`:

  end date in ROC calendar

- `format`:

  data format ("json" or "csv")

- `url`:

  retrieved API URL

- `variable_names`:

  variables in the tibble dataframe

- `manual_info`:

  official manual URL

- `data`:

  a tibble dataframe containing:

  `term`

  :   Term number

  `sessionPeriod`

  :   Session period

  `meetingDate`

  :   Meeting date (Gregorian year)

  `meetingTime`

  :   Meeting time

  `meetingTypeName`

  :   Organizing unit

  `meetingName`

  :   Meeting name

  `meetingContent`

  :   Meeting subject

  `legislatorName`

  :   Legislator's name

  `areaName`

  :   Represented area

  `speechStartTime`

  :   Speech start time

  `speechEndTime`

  :   Speech end time

  `speechRecordUrl`

  :   Speech record URL

  `videoLength`

  :   Video length

  `videoUrl`

  :   Video URL

  `selectTerm`

  :   Term/session filtering criteria

## Details

The function retrieves video information from legislative meetings and
committee sessions. Data is available from the 9th legislative term
onwards (2016, Minguo year 105). The date parameters must use the ROC
calendar format with forward slashes. Data can be retrieved in either
JSON or CSV format.

## Note

For more details about the data variables and API information, use
`get_variable_info("get_speech_video")` or visit:
<https://data.ly.gov.tw/getds.action?id=148>

Category: Provides video records of legislators' speech segments from
plenary sessions and committee meetings (available from the 9th term,
1st session, onwards).

## See also

- `get_variable_info("get_speech_video")`

- Example API URL:
  <https://data.ly.gov.tw/odw/ID148Action.action?term=10&sessionPeriod=4&meetingDateS=110/10/01&meetingDateE=110/10/30&meetingTime=&legislatorName=&fileType=csv>

## Examples

``` r
if (FALSE) { # \dontrun{
# Query video information in JSON format
videos <- get_speech_video(
  term = 10,
  session_period = 4,
  start_date = "110/10/01",
  end_date = "110/10/30"
)

# Query in CSV format
videos_csv <- get_speech_video(
  term = 10,
  session_period = 4,
  start_date = "110/10/01",
  end_date = "110/10/30",
  format = "csv"
)

# Query without specifying term/session
videos <- get_speech_video(
  start_date = "110/10/01",
  end_date = "110/10/30"
)
} # }
```
