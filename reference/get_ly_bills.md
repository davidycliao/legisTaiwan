# Fetch and Parse Legislative Yuan Bills 取得並解析立法院議案資料

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

  string. Type of bill:

  - "法律案" (Law Bill)

  - "中央政府總預算案" (Central Government Budget Bill)

  - "預(決) 算決議案" (Budget/Final Account Resolution)

  - "定期報告" (Regular Report)

  - "行政命令(層級)" (Administrative Order)

  - "院內單位來文" (Internal Document)

- current_status:

  string. Current bill status, e.g., "排入院會"

- process_status:

  string. Status in process flow, e.g., "排入院會 (交內政委員會)"

- proposer:

  string. Bill proposer name

- cosigner:

  string. Bill cosigner name

- source:

  string. Source of bill, e.g., "委員提案"

- bill_id:

  string. Bill ID number

- law_id:

  string. Related law ID number

- meeting_code:

  string. Meeting code, e.g., "院會-11-2-3"

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
  bill_type = "法律案",
  show_progress = TRUE
)

# Get budget bills
bills <- get_ly_bills(
  term = 11,
  bill_type = "中央政府總預算案",
  show_progress = TRUE
)

# Get administrative orders
bills <- get_ly_bills(
  term = 11,
  bill_type = "行政命令(層級)",
  show_progress = TRUE
)
} # }
```
