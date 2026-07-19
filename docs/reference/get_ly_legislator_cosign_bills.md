# Fetch Bills Cosigned by a Legislator 取得立法委員連署法案

Retrieves bills that were cosigned by a specific legislator by term and
name from the Legislative Yuan API.

## Usage

``` r
get_ly_legislator_cosign_bills(
  term,
  name,
  page = 1,
  limit = 20,
  show_progress = TRUE
)
```

## Arguments

- term:

  required integer. Legislative term number (e.g. 9)

- name:

  required string. Legislator name (e.g. "王金平")

- page:

  integer. Page number for pagination (default: 1)

- limit:

  integer. Number of records per page (default: 20)

- show_progress:

  logical. Whether to display progress info (default: TRUE)

## Value

A list containing two components:

- metadata:

  A list containing pagination information:

  total

  :   Total number of cosigned bills

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

  :   Source

  meet_id

  :   Meeting ID

  會期

  :   Session period

  字號

  :   Case number

  提案編號

  :   Proposal number

  屆期

  :   Term

  mtime

  :   Last modified time

## Details

Get Legislator's Cosigned Bills 取得立法委員連署法案

## See also

- get_ly_legislator_bills:

  [`get_ly_legislator_bills`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_legislator_bills.md)
  for retrieving bills proposed by a legislator

- get_ly_legislator_detail:

  [`get_ly_legislator_detail`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_legislator_detail.md)
  for legislator's detailed information

## Examples

``` r
if (FALSE) { # \dontrun{
# Get cosigned bills
bills <- get_ly_legislator_cosign_bills(
  term = 9,
  name = "王金平",
  limit = 5
)

# Print results
print(paste("Total cosigned bills:", bills$metadata$total))
print("Latest cosigned bill:")
print(bills$bills[1, c("議案名稱", "議案狀態")])

# Get second page of results
bills_page2 <- get_ly_legislator_cosign_bills(
  term = 9,
  name = "王金平",
  page = 2,
  limit = 20
)
} # }
```
