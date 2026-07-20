## R CMD check results

0 errors | 1 warning | 3 notes

* checking code files for non-ASCII characters ... WARNING

  All roxygen-generated documentation (titles, descriptions, parameter
  docs, examples) is now pure ASCII, so this warning no longer affects
  the PDF/HTML reference manual. The remaining non-ASCII bytes are inside
  a handful of R function *bodies* (not documentation): regular-expression
  separators used to split Chinese-language legislator name lists (e.g.
  `；`, `，`), a few `gsub()` patterns that strip Chinese honorific prefixes
  from names, and default/example values that must match category labels
  returned verbatim by the Legislative Yuan's own API (e.g. `屆期會期`,
  `代號`, `名稱`, `職掌`, `類別`). These strings must remain literal
  Traditional Chinese to correctly match the live data; rewriting them as
  \uXXXX escapes is not effective inside R code comments/strings for this
  purpose without changing behavior, and removing them would break the
  matching logic. `Encoding: UTF-8` is declared in DESCRIPTION.

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
