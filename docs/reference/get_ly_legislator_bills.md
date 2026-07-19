# Get Bill by legislator 取得立法委員提案資料

Retrieves comprehensive information for a specific legislator from the
Legislative Yuan API. This includes personal details, committee
assignments, educational background, and work experience.

## Usage

``` r
get_ly_legislator_bills(term, name, page = 1, limit = 20, show_progress = TRUE)
```

## Arguments

- term:

  integer. Required. The legislative term number (e.g., 9)

- name:

  string. Required. The legislator's name in Chinese (e.g., "王金平")

- page:

  integer. Page number for pagination (default: 1)

- limit:

  integer. Number of records per page (default: 20)

- show_progress:

  logical. Whether to display progress information (default: TRUE)

## Value

A list containing two components:

- metadata:

  A list containing pagination information:

  total

  :   Total number of bills

  total_page

  :   Total number of pages

  current_page

  :   Current page number

  per_page

  :   Number of records per page

- bills:

  A data frame containing bill information:

  billNo

  :   Bill number

  議案名稱

  :   Bill name

  提案單位

  :   Proposing unit/legislator

  議案狀態

  :   Bill status

  議案類別

  :   Bill type

  提案來源

  :   Bill source

  meet_id

  :   Meeting ID

  會期

  :   Session number

  字號

  :   Reference number

  提案編號

  :   Proposal number

  屆期

  :   Legislative term

  mtime

  :   Last modified time

## Details

Get Bill by legislator 取得立法委員提案資料

## API Details

The function accesses the Legislative Yuan's open data API. The API
endpoint format is:
`https://ly.govapi.tw/legislator/{term}/{name}/propose_bill`

## Data Usage

The returned data can be used for:

- Analysis:

  Analyzing legislator's bill proposal patterns

- Tracking:

  Tracking bill status and progress

- Research:

  Studying legislative priorities

- Policy:

  Conducting policy research

## See also

- get_ly_legislators_by_term:

  [`get_ly_legislators_by_term`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_legislators_by_term.md)
  for listing all legislators in a term

- get_ly_legislator_detail:

  [`get_ly_legislator_detail`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_legislator_detail.md)
  for detailed legislator information

## Examples

``` r
if (FALSE) { # \dontrun{
# Get bills for a specific legislator
bills <- get_ly_legislator_bills(
  term = 9,
  name = "王金平",
  limit = 10
)

# Get second page of bills
bills_page2 <- get_ly_legislator_bills(
  term = 9,
  name = "王金平",
  page = 2,
  limit = 20
)

# Display summary statistics
cat(sprintf(
  "Total Bills: %d\nCurrent Page: %d\nBills per page: %d\n",
  bills$metadata$total,
  bills$metadata$current_page,
  bills$metadata$per_page
))
} # }
```
