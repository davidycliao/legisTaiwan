# Fetch Legislators List for a Specific Term

Retrieves a paginated list of legislators for a specific Legislative
Yuan term. The function provides detailed information about legislators
including their names, parties, and represented areas. It also includes
metadata about the total number of legislators and pagination
information.

## Usage

``` r
get_ly_legislators_by_term(term, page = 1, limit = 20, show_progress = TRUE)
```

## Arguments

- term:

  required integer. Legislative term number (e.g., 9)

- page:

  integer. Page number for pagination (default: 1)

- limit:

  integer. Number of records per page (default: 20)

- show_progress:

  logical. Whether to display progress bar and summary statistics
  (default: TRUE)

## Value

A list with two components:

- metadata:

  A list containing:

  total

  :   Total number of legislators

  total_page

  :   Total number of pages

  current_page

  :   Current page number

  per_page

  :   Number of records per page

- legislators:

  A data frame containing legislator information:

  term

  :   Legislative term

  name

  :   Legislator's name

  party

  :   Political party affiliation

  areaName

  :   Represented area (if available)

  columns

  :   Additional columns as provided by the API

## Details

Get Legislative Yuan Legislators by Term

The function includes a progress bar and detailed summary statistics
when show_progress is TRUE. The summary includes:

- Total Statistics:

  Total number of legislators

- Pagination:

  Current page and total pages

- Page Size:

  Records per page

- Distribution:

  Party and area distribution (if available)

## See also

- get_ly_legislator_detail:

  [`get_ly_legislator_detail`](https://davidycliao.github.io/legisTaiwan/reference/get_ly_legislator_detail.md)
  for getting detailed information about a specific legislator

## Examples

``` r
if (FALSE) { # \dontrun{
# Get first page of legislators for term 9
result <- get_ly_legislators_by_term(term = 9)

# Get second page with 30 records per page
result <- get_ly_legislators_by_term(
  term = 9,
  page = 2,
  limit = 30
)

# Access the results
metadata <- result$metadata
legislators_df <- result$legislators

# Display total number of legislators
cat("Total legislators:", metadata$total, "\n")

# Show first few rows of legislator data
head(legislators_df)
} # }
```
