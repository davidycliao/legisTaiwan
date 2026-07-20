# Fetch Legislative Yuan IVOD (Video) Records

Retrieves IVOD (Internet Video on Demand) records from the Legislative
Yuan API. Returns video records sorted by date in descending order.

## Usage

``` r
get_ly_ivod(
  page = 1,
  limit = 20,
  term = NULL,
  session_period = NULL,
  show_progress = TRUE
)
```

## Arguments

- page:

  integer. Page number for pagination (default: 1)

- limit:

  integer. Number of records per page (default: 20)

- term:

  integer. Legislative term (e.g. 9)

- session_period:

  integer. Session period

- show_progress:

  logical. Whether to display progress bar (default: TRUE)

## Value

A list containing two components:

- metadata:

  A list containing pagination and filter information:

  total

  :   Total number of records found

  total_page

  :   Total number of available pages

  current_page

  :   Current page number

  per_page

  :   Number of records per page

  filters_used

  :   List of filters applied to the query

- ivods:

  A data frame containing:

  id

  :   IVOD record ID

  url

  :   URL to view video on IVOD website

  video_url

  :   Direct streaming URL for the video

  meeting_time

  :   Original meeting date and time

  meeting_name

  :   Name of the legislative meeting

  type

  :   Type of video record

  date

  :   Meeting date in YYYY-MM-DD format

  start_time

  :   Video start timestamp

  end_time

  :   Video end timestamp

  duration

  :   Video duration in seconds

  video_length

  :   Formatted video length (HH:MM:SS)

## Details

Get Legislative Yuan IVOD Records

## Examples

``` r
if (FALSE) { # \dontrun{
# Get videos from term 9
videos <- get_ly_ivod(
  term = 9,
  limit = 5
)

# Get videos from specific session
session_videos <- get_ly_ivod(
  term = 9,
  session_period = 1,
  page = 1,
  limit = 20
)

# Access the results
print(paste("Total videos:", videos$metadata$total))
print("First video details:")
print(videos$ivods[1, c("meeting_name", "date", "video_length")])
} # }
```
