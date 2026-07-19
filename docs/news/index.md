# Changelog

## `legisTaiwan` 0.2.2

### Major Changes

**Fix SSL connection issues in review_session_info function and example
errors**

- Use system curl command to bypass SSL/TLS certificate validation
  problems
- Improve regex handling of session data to fix “NAs introduced by
  coercion” warnings
- Ensure results are correctly sorted by session number

This fix resolves SSL connection issues with the Legislative Yuan
website, making review_session_info and get_variable_info functions work
reliably.

  

------------------------------------------------------------------------

## `legisTaiwan` 0.2.1

### Major Changes

- Updated API endpoint from ly.govapi.tw to v2.ly.govapi.tw
- Maintained backward compatibility with legacy API functions
- Enhanced documentation for better clarity

### API Migration Notice

The Legislative Yuan API is transitioning from <https://ly.govapi.tw> to
<https://v2.ly.govapi.tw>. While functions using the legacy API will
continue to work for now, we recommend starting to migrate your code to
use the new API endpoint.

  

------------------------------------------------------------------------

## `legisTaiwan` 0.1.7

- Enhanced user experience by implementing progress bars for
  time-intensive operations. Progress bars are now displayed when
  verbose = TRUE.

- Performed comprehensive spelling and typographical corrections
  throughout the package documentation and function names.

  

------------------------------------------------------------------------

## `legisTaiwan` 0.1.6

Corrected spelling errors and standardized terminology across function
documentation.

  

------------------------------------------------------------------------

## `legisTaiwan` 0.1.4 (development version)

- re-documentation and inserting handlers.

- formatting the website and documentation:
  [`get_executive_response()`](https://davidycliao.github.io/legisTaiwan/reference/get_executive_response.md),
  [`get_bills_2()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills_2.md),
  `get_debates()` and
  [`get_speech_video()`](https://davidycliao.github.io/legisTaiwan/reference/get_speech_video.md).

- [`get_bills()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills.md)
  and `get_meeting()`’s starting date are not clear.

- [`get_public_debates()`](https://davidycliao.github.io/legisTaiwan/reference/get_public_debates.md)
  manual information is inconsistent with actual data.

- \~~Two API endpoints,`質詢事項(本院委員質詢部分)` ~~and `國是論壇`,
  are~~ is temporarily down. Therefore, the data retrieved by
  [`get_parlquestions()`](https://davidycliao.github.io/legisTaiwan/reference/get_parlquestions.md)
  ~~and
  [`get_public_debates()`](https://davidycliao.github.io/legisTaiwan/reference/get_public_debates.md)~~
  may not be correct. \[*UPDATE: Feb 5 2023*\]\~~

- [`get_public_debates()`](https://davidycliao.github.io/legisTaiwan/reference/get_public_debates.md)
  is on. \[*UPDATE: Feb 7 2023*\]

  

------------------------------------------------------------------------

## `legisTaiwan` 0.1.3 (development version)

- Fix typo in function name: `get_variabel_infos()` to
  [`get_variable_info()`](https://davidycliao.github.io/legisTaiwan/reference/get_variable_info.md).

- [`get_committee_record()`](https://davidycliao.github.io/legisTaiwan/reference/get_committee_record.md)
  is added to access to the records of reviewed items in the committees
  提供委員會會議審查之議案項目.

- Add funder and copyright holder in NAMESPACE: `國科會` and `立法院`

- Re-documentation and inserting handlers

  

------------------------------------------------------------------------

## `legisTaiwan` 0.1.1 (development version)

- [`get_executive_response()`](https://davidycliao.github.io/legisTaiwan/reference/get_executive_response.md),
  [`get_bills_2()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills_2.md),
  `get_debates()` and
  [`get_speech_video()`](https://davidycliao.github.io/legisTaiwan/reference/get_speech_video.md)
  are added.

- The package is created with
  [`get_meetings()`](https://davidycliao.github.io/legisTaiwan/reference/get_meetings.md),
  [`get_bills()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills.md),
  [`get_legislators()`](https://davidycliao.github.io/legisTaiwan/reference/get_legislators.md),
  [`get_parlquestions()`](https://davidycliao.github.io/legisTaiwan/reference/get_parlquestions.md)

  
