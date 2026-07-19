# Transforming Minguo (Taiwan) Calendar to A.D. Calendar I

`transformed_date_meeting()` transforms Minguo (Taiwan) Calendar to A.D.
calendar in POSIXct for
[`get_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/get_meetings.md),
[`get_caucus_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/get_caucus_meetings.md),
and
[`get_speech_video()`](https://davidycliao.github.io/legisTaiwan/reference/get_speech_video.md),

## Usage

``` r
transformed_date_meeting(roc_date)
```

## Arguments

- roc_date:

  Date format in Minguo (Taiwan) calendar (e.g., "105/05/31") as a
  string vector

## Value

date in POSIXct

## Details

`check_date` transforms ROC date to a date in POSIXct, e.g. "105/05/31"
to "2016-05-31".

## Examples

``` r
if (FALSE) { # \dontrun{
transformed_date_meeting("105/05/31")
} # }
```
