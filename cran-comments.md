## R CMD check results

0 errors | 0 warnings | 2 notes

All R source files are now pure ASCII: functionally load-bearing
Chinese content (regex separators for splitting legislator name lists,
column/category names that must match the Legislative Yuan API's own
Traditional Chinese labels verbatim, honorific-stripping patterns) is
expressed as \uXXXX escapes rather than literal characters, so it is
byte-for-byte identical at runtime with no behavior change.

* checking for future file timestamps ... NOTE

  `unable to verify current time` — this is an artifact of the local
  check environment (no NTP time-sync available) and does not occur on
  CRAN's check machines.

* checking HTML version of manual ... NOTE

  The reported issues (`<main> is not recognized!`, `<table> lacks
  "summary" attribute`, etc.) come from R's own Rd-to-HTML renderer and
  the local HTML tidy library version; they appear identically on every
  single Rd page in this package (and are commonly reported as a
  known/environment-dependent artifact unrelated to package content).
  The PDF version of the manual builds without any errors.

## Test environment notes

Most exported functions call the live Taiwan Legislative Yuan API. All
tests and examples that depend on this live API are guarded with
`skip_on_cran()` (and, where relevant, a connectivity check that skips
gracefully if the API is unreachable) so that a transient outage of the
upstream government website cannot fail CRAN's automated checks.
