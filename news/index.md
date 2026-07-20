# Changelog

## `legisTaiwan` 0.2.2

### Major Changes

**CRAN submission readiness: license, encoding, and dead-code fixes**

- **License corrected to MIT.** `DESCRIPTION` incorrectly declared
  `GPL-3 + file LICENSE`, but the `LICENSE` file used the MIT license
  stub format (flagged by CRAN reviewer Uwe Ligges). Switched to
  `MIT + file LICENSE` and added `LICENSE.md` with the full license
  text.
- **Removed all non-ASCII characters from package documentation and
  code**, resolving a CRAN `WARNING` and a PDF-manual build failure.
  Chinese characters in `Authors@R` and roxygen documentation broke
  LaTeX rendering of the PDF reference manual entirely (no CJK font
  support in CRAN’s build environment); all documentation was translated
  to English. Remaining Chinese that is functionally required to match
  the Legislative Yuan API’s own column/category names, or to split
  Chinese-language legislator name lists, is now expressed as `\uXXXX`
  escapes — byte-for-byte identical at runtime, with no behavior change.
- **[`bill_to_network()`](https://davidycliao.github.io/legisTaiwan/reference/bill_to_network.md)**:
  new function to convert bill proposer/cosigner data into an `igraph`
  network object (centrality measures, community detection). Added the
  missing `igraph` dependency to `DESCRIPTION` and fixed several
  `@importFrom` omissions (`V`, `V<-`, `E`, `membership`) that caused
  runtime errors; switched off the now-deprecated
  [`igraph::get.edgelist()`](https://r.igraph.org/reference/get.edgelist.html).
- **Removed dead code**:
  [`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)
  and
  [`get_committee_record()`](https://davidycliao.github.io/legisTaiwan/reference/get_committee_record.md)
  each had an orphaned, unused duplicate function/doc block left over
  from a previous refactor; the duplicate documentation for
  [`review_session_info()`](https://davidycliao.github.io/legisTaiwan/reference/review_session_info.md)
  was silently merged into the Rd file ahead of its `\dontrun{}` guard,
  causing an unguarded live API call during every `R CMD check`.
  [`get_legislators()`](https://davidycliao.github.io/legisTaiwan/reference/get_legislators.md)’s
  docs also had a stray, unrelated
  [`get_executive_response()`](https://davidycliao.github.io/legisTaiwan/reference/get_executive_response.md)
  example call sitting outside `\dontrun{}`.
- **Tests are now CRAN-safe**: all tests that call the live Legislative
  Yuan API are guarded with `skip_on_cran()` and gracefully skip
  (instead of failing) when the API is unreachable or returns an
  unexpected error, so a transient outage of the upstream government
  website can no longer fail automated checks.
- Misc.: fixed a broken `README` link left as `[the newer functions]()`,
  updated the `codecov.io` badge link to `app.codecov.io`, removed a
  stale `inst/README.Rmd`/`.md` duplicate from v0.1.6 that CRAN’s URL
  checker was scanning instead of the current README, and excluded
  generated/local files (`.codefactor.yml`, `README.html`) from the
  built package via `.Rbuildignore`.

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

- Two API endpoints,`質詢事項(本院委員質詢部分)` ~~and `國是論壇`, are~~
  is temporarily down. Therefore, the data retrieved by
  [`get_parlquestions()`](https://davidycliao.github.io/legisTaiwan/reference/get_parlquestions.md)
  ~~and
  [`get_public_debates()`](https://davidycliao.github.io/legisTaiwan/reference/get_public_debates.md)~~
  may not be correct. \[*UPDATE: Feb 5 2023*\]

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

  
