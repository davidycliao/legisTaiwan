# Validate Date Formats

This function checks if the provided start and end dates are in the
correct numeric format.

## Usage

``` r
validate_dates_format(start_date, end_date)
```

## Arguments

- start_date:

  A string representing the start date. Expected format is numeric,
  e.g., "1090101".

- end_date:

  A string representing the end date. Expected format is numeric, e.g.,
  "1090101".

## Value

NULL. If the dates are not in the expected format, an error is thrown.

## Examples

``` r
# This should throw an error:
if (FALSE) { # \dontrun{
validate_dates_format("10901", "1100101")
} # }
```
