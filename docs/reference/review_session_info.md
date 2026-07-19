# Check Session Periods in Each Year (Minguo Calendar) 檢查每年會期 (民國曆)

Examines session periods in Taiwan Minguo calendar (檢查每年會期民國曆)

## Usage

``` r
review_session_info(term)

review_session_info(term)
```

## Arguments

- term:

  numeric The term number (1-11) of Legislative Yuan

## Value

dataframe

A dataframe containing session information

## Details

`review_session_info` produces a dataframe, displaying each session
period in year formatted in Minguo (Taiwan) calendar.

Check Session Periods in Each Year (Minguo Calendar)

The review_session_info function produces a dataframe, displaying each
session period in year formatted in Minguo calendar. This implementation
uses system curl command with –insecure option to bypass SSL/TLS issues.

## See also

Regarding Minguo calendar, please see
<https://en.wikipedia.org/wiki/Republic_of_China_calendar>.

Regarding Minguo calendar, please see
<https://en.wikipedia.org/wiki/Republic_of_China_calendar>.

## Author

David Liao (davidycliao@gmail.com)

## Examples

``` r
# Show the session information for the 7th Legislative Yuan term periods in ROC calendar year
review_session_info(7)
#> Downloading data from Legislative Yuan website...
#> Error in value[[3L]](cond): Error retrieving session information: Failed to download the HTML content. The website might be down.
if (FALSE) { # \dontrun{
# Show the session information for the 7th Legislative Yuan term periods in ROC calendar year
review_session_info(7)
} # }
```
