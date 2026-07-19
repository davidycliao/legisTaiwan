# Transforming Minguo (Taiwan) Calendar to A.D. Calendar IIII

[`transformed_date_meeting()`](https://davidycliao.github.io/legisTaiwan/reference/transformed_date_meeting.md)
transforms Minguo (Taiwan) Calendar to A.D. format in POSIXct for
`get_bill()`, e.g. "1050531" to "2016-05-31".

## Usage

``` r
check_date2(roc_date)
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
check_date2("105/05/31")
} # }
```
