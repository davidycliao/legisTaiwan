# Get Legislative Yuan Interpellation Records 取得立法院質詢紀錄

Fetches and parses interpellation records from the Legislative Yuan API.
Supports filtering by legislator, term, session and keyword search.
Returns structured data including metadata and detailed interpellation
records.

## Usage

``` r
get_ly_interpellations(
  page = 1,
  limit = 20,
  legislator = NULL,
  term = NULL,
  session_period = NULL,
  session_times = NULL,
  meet_id = NULL,
  query = NULL,
  show_progress = TRUE
)
```

## Arguments

- page:

  An integer specifying the page number (default: 1)

- limit:

  An integer specifying the number of records per page (default: 20)

- legislator:

  A string specifying the legislator's name

- term:

  An integer specifying the legislative term number

- session_period:

  An integer specifying the session period

- session_times:

  An integer specifying the session times

- meet_id:

  A string specifying the meeting ID (e.g., "院會-9-2-1")

- query:

  A string to search in interpellation reasons or content

- show_progress:

  A logical value indicating whether to show progress bar (default:
  TRUE)

## Value

A list with two components:

- metadata:

  A list containing pagination and filter information:

  total

  :   Total number of records found

  total_page

  :   Total number of pages

  current_page

  :   Current page number

  per_page

  :   Number of records per page

  filters_used

  :   List of filters applied

- interpellations:

  A data frame containing interpellation records:

  id

  :   Interpellation ID

  printed_at

  :   Date when printed

  reason

  :   Interpellation reason

  description

  :   Detailed content

  legislators

  :   Comma-separated list of legislators

  meet_id

  :   Meeting ID

  term

  :   Legislative term

  sessionPeriod

  :   Session period

  sessionTimes

  :   Session times

  ppg_url

  :   URL to the parliamentary record

## See also

<https://ly.govapi.tw/> for API documentation

## Examples

``` r
if (FALSE) { # \dontrun{
# Get interpellations by legislator
zhao_records <- get_ly_interpellations(
  legislator = "趙天麟",
  limit = 5
)

# Get interpellations for specific term and session
session_records <- get_ly_interpellations(
  term = 9,
  session_period = 2,
  session_times = 1
)

# Search interpellations by keyword
search_results <- get_ly_interpellations(
  query = "氫能",
  page = 1,
  limit = 20
)

# View results
print(paste("Total records:", search_results$metadata$total))
head(search_results$interpellations)
} # }
```
