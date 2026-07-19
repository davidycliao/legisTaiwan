# Check for the Website Availability II

This function checks the availability of a specified website by trying
to read the first line of the site's content.

## Usage

``` r
website_availability2(
  site = "https://npl.ly.gov.tw/do/www/appDate?status=0&expire=02&startYear=0"
)
```

## Arguments

- site:

  A website URL to check. Default is
  "https://npl.ly.gov.tw/do/www/appDate?status=0&expire=02&startYear=0".

## See also

[`check_internet()`](https://davidycliao.github.io/legisTaiwan/reference/check_internet.md)
and
[`website_availability()`](https://davidycliao.github.io/legisTaiwan/reference/website_availability.md).
