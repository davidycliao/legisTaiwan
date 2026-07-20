# Analyze Legislative Meeting Statistics

Analyzes and visualizes meeting statistics from the Legislative Yuan,
including meeting counts by term, minutes completion rates, and produces
a comparison visualization between total meetings and available meeting
minutes.

## Usage

``` r
analyze_meetings(stats)
```

## Arguments

- stats:

  A list containing Legislative Yuan statistics with the following
  structure:

  meet

  :   A list containing:

      total

      :   Total number of meetings

      terms

      :   Data frame with columns:

          term

          :   Legislative term number

          count

          :   Number of meetings in that term

          max_meeting_date

          :   Last meeting date of the term

          meetdata_count

          :   Number of meetings with data

          minutes_count

          :   Number of meetings with minutes (the API's raw column name
              is a Traditional Chinese label)

## Value

A list containing:

- plot:

  A ggplot object showing meeting statistics comparison

- summary:

  A data frame with meeting statistics including:

  term

  :   Term number

  count

  :   Total meetings

  minutes_ratio

  :   Percentage of meetings with minutes

  last_meeting_date

  :   Formatted date of last meeting

## Examples

``` r
if (FALSE) { # \dontrun{
# Get statistics and analyze meetings
stats <- get_ly_stat()
meeting_analysis <- analyze_meetings(stats)

# View the plot
print(meeting_analysis$plot)

# View meeting statistics
print(meeting_analysis$summary)
} # }
```
