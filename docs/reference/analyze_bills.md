# Analyze Legislative Bills Statistics

Analyzes and visualizes bill statistics from the Legislative Yuan,
including bill counts by term, percentages, and trends. Creates a
visualization and provides summary statistics.

## Usage

``` r
analyze_bills(stats)
```

## Arguments

- stats:

  A list containing Legislative Yuan statistics with the following
  structure:

  bill

  :   A list containing:

      total

      :   Total number of bills

      max_update_time

      :   Last update timestamp

      terms

      :   Data frame with columns:

          term

          :   Legislative term number

          count

          :   Number of bills in that term

## Value

A list containing:

- plot:

  A ggplot object showing bill count trends

- summary:

  A data frame with bill statistics including:

  term

  :   Term number

  count

  :   Bill count

  percentage

  :   Percentage of total

  cumulative

  :   Cumulative count

## Examples

``` r
if (FALSE) { # \dontrun{
stats <- get_ly_stat()
bill_analysis <- analyze_bills(stats)

# View the plot
print(bill_analysis$plot)

# View the summary statistics
print(bill_analysis$summary)
} # }
```
