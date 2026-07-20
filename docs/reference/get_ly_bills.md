# Fetch and Parse Legislative Yuan Bills

Retrieves bill information from the Legislative Yuan API with
comprehensive filter options. Supports filtering by term, session, bill
type, status, and other attributes. Returns both metadata and detailed
bill information.

## Usage

``` r
get_ly_bills(
  page = 1,
  per_page = 20,
  term = NULL,
  session = NULL,
  bill_type = NULL,
  current_status = NULL,
  process_status = NULL,
  proposer = NULL,
  cosigner = NULL,
  source = NULL,
  bill_id = NULL,
  law_id = NULL,
  meeting_code = NULL,
  show_progress = TRUE
)
```

## Arguments

- page:

  integer. Page number for pagination (default: 1)

- per_page:

  integer. Number of items per page (default: 20)

- term:

  integer. Legislative term, e.g., 11

- session:

  integer. Legislative session period, e.g., 2

- bill_type:

  string. Type of bill. The API expects the Chinese-language category
  name, e.g.:

  - Law Bill

  - Central Government Budget Bill

  - Budget/Final Account Resolution

  - Regular Report

  - Administrative Order

  - Internal Document

- current_status:

  string. Current bill status, in Chinese (e.g., "scheduled for plenary
  session")

- process_status:

  string. Status in process flow, in Chinese (e.g., "scheduled for
  plenary session, referred to the Interior Committee")

- proposer:

  string. Bill proposer name

- cosigner:

  string. Bill cosigner name

- source:

  string. Source of bill, in Chinese (e.g., "legislator proposal")

- bill_id:

  string. Bill ID number

- law_id:

  string. Related law ID number

- meeting_code:

  string. Meeting code, e.g., a plenary-session meeting in term 11,
  session 2, session-times 3

- show_progress:

  logical. Whether to display progress bar (default: TRUE)

## Value

A list containing:

- metadata - List of pagination info and applied filters

- bills - Data frame of bill details

## Examples

``` r
if (FALSE) { # \dontrun{
# Get law bills
bills <- get_ly_bills(
  term = 11,
  bill_type = "Law Bill",  # pass the Chinese-language category name here
  show_progress = TRUE
)

# Get budget bills
bills <- get_ly_bills(
  term = 11,
  bill_type = "Central Government Budget Bill",  # in Chinese
  show_progress = TRUE
)

# Get administrative orders
bills <- get_ly_bills(
  term = 11,
  bill_type = "Administrative Order",  # in Chinese
  show_progress = TRUE
)
} # }
```
