# Check Each Function's Manual

`get_variable_info` generate each API's endpoint manual returned from
the website of Taiwan Legislative Yuan. The avalaible options is:
`get_bills`, `get_bills_2`, `get_meetings`, `get_caucus_meetings`,
`get_speech_video` , `get_public_debates`, `get_parlquestions`,
`get_executive_response` and `get_committee_record`. Only supports
legacy API parameters.

## Usage

``` r
get_variable_info(param_)
```

## Arguments

- param\_:

  characters. Must be one of options below:

  get_bills

  :   get_bills: the records of the bills, see
      <https://data.ly.gov.tw/getds.action?id=6>

  get_bills_2

  :   the records of legislators and the government proposals, see
      <https://data.ly.gov.tw/getds.action?id=6>

  get_meetings

  :   the spoken meeting records, see
      <https://www.ly.gov.tw/Pages/List.aspx?nodeid=154>

  get_caucus_meetings

  :   the meeting records of cross-caucus session, see
      <https://data.ly.gov.tw/getds.action?id=8>

  get_speech_video

  :   the full video information of meetings and committees, see
      <https://data.ly.gov.tw/getds.action?id=148>

  get_public_debates

  :   the records of national public debates, see
      <https://data.ly.gov.tw/getds.action?id=7>

  get_parlquestions

  :   the records of parliamentary questions, see
      <https://data.ly.gov.tw/getds.action?id=6>

  get_executive_response

  :   the records of the questions answered by the executives, see
      <https://data.ly.gov.tw/getds.action?id=2>

## Value

list

- `page_info`:

  information of the end point

- `reference_url`:

  the url of the page

## Details

`get_variable_info` produces a list, which contains `page_info` and
`reference_url`.

## See also

[`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md).

## Author

Yen-Chieh Liao (davidycliao@gmail.com)

## Examples

``` r
if (FALSE) { # \dontrun{
  # This example requires internet connection and is not run during package checks
  check_caucus <- get_variable_info("get_caucus_meetings")
} # }
```
