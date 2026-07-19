# Analyze Legislative Video (IVOD) Statistics

Analyzes and visualizes video records (IVOD - Internet Video on Demand)
statistics from the Legislative Yuan, including video counts by term,
daily averages, and time period coverage.

## Usage

``` r
analyze_ivod(stats)
```

## Arguments

- stats:

  A list containing Legislative Yuan statistics with the following
  structure:

  ivod

  :   A list containing:

      total

      :   Total number of video records

      date_range

      :   A list containing:

          start

          :   Start date of video archive

          end

          :   End date of video archive

      terms

      :   Data frame with columns:

          term

          :   Legislative term number

          count

          :   Number of videos in that term

          start_date

          :   Start date of term

          end_date

          :   End date of term

## Value

A list containing:

- plot:

  A ggplot object showing video count distribution by term

- summary:

  A data frame with video statistics including:

  term

  :   Term number

  count

  :   Video count

  start_date_fmt

  :   Formatted start date

  end_date_fmt

  :   Formatted end date

  period_days

  :   Duration in days

  avg_daily_videos

  :   Average videos per day

## Examples

``` r
if (FALSE) { # \dontrun{
# Get statistics and analyze videos
stats <- get_ly_stat()
video_analysis <- analyze_ivod(stats)

# View the plot
print(video_analysis$plot)

# View video statistics
print(video_analysis$summary)
} # }
```
