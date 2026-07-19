# Calculate Legislative Bill Trends and Metrics

Calculates various trend metrics for legislative bills, including bills
per meeting and bills per day, by joining bill and meeting statistics
across terms.

## Usage

``` r
calculate_bill_trends(stats)
```

## Arguments

- stats:

  A list containing Legislative Yuan statistics with the following
  structure:

  bill\$terms

  :   Data frame containing bill information:

      term

      :   Legislative term number

      count

      :   Number of bills in that term

  meet\$terms

  :   Data frame containing meeting information:

      term

      :   Legislative term number

      count

      :   Number of meetings in that term

      max_meeting_date

      :   Last meeting date of the term

## Value

A data frame containing the following columns:

- term:

  Legislative term number

- bills:

  Total number of bills in term

- meetings:

  Total number of meetings in term

- bills_per_meeting:

  Average number of bills per meeting

- bills_per_day:

  Average number of bills per day

## Examples

``` r
if (FALSE) { # \dontrun{
# Get statistics and calculate trends
stats <- get_ly_stat()
trends <- calculate_bill_trends(stats)

# View trend analysis
print("Bill processing trends:")
print(trends)

# Analyze specific metrics
print("Average bills per meeting by term:")
print(trends[c("term", "bills_per_meeting")])
} # }
```
