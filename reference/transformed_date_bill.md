# Transforming Minguo (Taiwan) Calendar to A.D. Calendar II

[`transformed_date_meeting()`](https://davidycliao.github.io/legisTaiwan/reference/transformed_date_meeting.md)
transforms Minguo (Taiwan) Calendar to A.D. format in POSIXct for
`get_bill()`, e.g. "1050531" to "2016-05-31".

## Usage

``` r
transformed_date_bill(roc_date)
```

## Arguments

- roc_date:

  date format in Taiwan ROC calendar (e.g., "1050531") in a character
  vector

## Value

date in POSIXct

## Examples

``` r
if (FALSE) { # \dontrun{
transformed_date_bill("1050531")
} # }
```
