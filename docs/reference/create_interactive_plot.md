# Create Interactive Plot of Legislative Bill Trends

Creates an interactive plotly visualization showing the trend of bill
counts across different legislative terms. The plot includes hover
information and interactive features.

## Usage

``` r
create_interactive_plot(stats)
```

## Arguments

- stats:

  A list containing Legislative Yuan statistics with the following
  structure:

  bill\$terms

  :   A data frame containing:

      term

      :   Legislative term number

      count

      :   Number of bills in that term

## Value

A plotly object with the following features:

- Plot Type:

  Interactive line plot with markers

- Hover Info:

  Dynamic text showing term and bill count

- Layout:

  Title

  :   Bill count trends chart

  X-axis

  :   Term labels

  Y-axis

  :   Bill count scale

## See also

- analyze_bills:

  For detailed bill statistics analysis

- calculate_bill_trends:

  For trend metrics calculation

## Examples

``` r
if (FALSE) { # \dontrun{
# Create basic interactive plot
stats <- get_ly_stat()
p <- create_interactive_plot(stats)
p  # Display the plot

# Create plot with custom title
p <- create_interactive_plot(stats) %>%
  layout(title = "Legislative Bill Trends Analysis")
p
} # }
```
