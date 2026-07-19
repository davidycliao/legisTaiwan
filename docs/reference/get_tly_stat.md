# Fetch and Parse Legislative Yuan Statistics 取得並解析立法院統計資料

Retrieves statistical data from the Legislative Yuan API and parses it
into a structured format. The function fetches data about bills,
legislators, gazettes, meetings, and IVOD records.

## Usage

``` r
get_tly_stat()
```

## Value

A list containing five main components:

- bill - Statistics about legislative bills, including total count and
  term-wise breakdown

- legislator - Information about legislators across different terms

- gazette - Statistics about legislative gazettes and agendas

- meet - Meeting statistics including counts and dates

- ivod - Video recording statistics with date ranges

## Examples

``` r
if (FALSE) { # \dontrun{
stats <- get_tly_stat()
# View total number of bills
print(stats$bill$total)
# View legislator counts by term
print(stats$legislator$terms)
} # }
```
