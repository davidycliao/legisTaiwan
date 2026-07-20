# Fetch Bills Cosigned by a Legislator

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

  required string. Legislator name in Chinese (e.g. the legislator
  romanized as "Wang Jin-pyng")

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

  billName

  :   Bill name (raw column name is a Chinese label)

  billOrg

  :   Proposing unit/legislator (raw column name is a Chinese label)

  billStatus

  :   Bill status (raw column name is a Chinese label)

  billType

  :   Bill type (raw column name is a Chinese label)

  billSource

  :   Source (raw column name is a Chinese label)

  meet_id

  :   Meeting ID

  session

  :   Session period (raw column name is a Chinese label)

  caseNo

  :   Case number (raw column name is a Chinese label)

  proposalNo

  :   Proposal number (raw column name is a Chinese label)

  term

  :   Term (raw column name is a Chinese label)

  mtime

  :   Last modified time

## Details

Get Legislator's Cosigned Bills

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
  name = "Wang Jin-pyng",  # a legislator's Chinese name goes here
  limit = 5
)

# Print results
print(paste("Total cosigned bills:", bills$metadata$total))
print("Latest cosigned bill:")
print(bills$bills[1, c("billName", "billStatus")])  # actual columns are named in Chinese

# Get second page of results
bills_page2 <- get_ly_legislator_cosign_bills(
  term = 9,
  name = "Wang Jin-pyng",  # a legislator's Chinese name goes here
  page = 2,
  limit = 20
)
} # }
```
