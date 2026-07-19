## R CMD check results

0 errors | 1 warning | 1 note

* checking code files for non-ASCII characters ... WARNING

  This package interfaces with the Taiwan Legislative Yuan API and
  necessarily contains Traditional Chinese strings that are integral to
  the package's purpose: column names and category labels returned
  verbatim by the Legislative Yuan's own API/website (e.g. `屆期會期`,
  `代號`, `名稱`, `職掌`, `類別`), and regular-expression separators used
  to split Chinese-language legislator name lists (e.g. `；`, `，`).
  These strings must remain as literal Traditional Chinese to correctly
  match the live data; rewriting them as \uXXXX escapes or removing them
  would not change the check result (the file would still contain
  non-ASCII bytes in Chinese-language roxygen documentation) and risks
  breaking the exact-match logic. `Encoding: UTF-8` is declared in
  DESCRIPTION.

* checking for future file timestamps ... NOTE

  `unable to verify current time` — this is an artifact of the local
  check environment (no NTP time-sync available) and does not occur on
  CRAN's check machines.

## Test environment notes

Most exported functions call the live Taiwan Legislative Yuan API. All
tests and examples that depend on this live API are guarded with
`skip_on_cran()` (and, where relevant, a connectivity check that skips
gracefully if the API is unreachable) so that a transient outage of the
upstream government website cannot fail CRAN's automated checks.
