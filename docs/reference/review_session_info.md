# Check Session Periods in Each Year

Examines session periods in the Taiwan Minguo calendar

## Usage

``` r
review_session_info(term)
```

## Arguments

- term:

  numeric The term number (1-11) of Legislative Yuan

## Value

A dataframe containing session information

## Details

Check Session Periods in Each Year (Minguo Calendar)

The review_session_info function produces a dataframe, displaying each
session period in year formatted in Minguo calendar. This implementation
uses system curl command with –insecure option to bypass SSL/TLS issues.

## See also

Regarding Minguo calendar, please see
<https://en.wikipedia.org/wiki/Republic_of_China_calendar>.

## Author

David Liao (davidycliao@gmail.com)

## Examples

``` r
if (FALSE) { # \dontrun{
# Show the session information for the 7th Legislative Yuan term periods in ROC calendar year
review_session_info(7)
} # }
```
