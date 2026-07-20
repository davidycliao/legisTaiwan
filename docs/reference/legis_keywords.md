# Legislative Keywords for Text Analysis

A dataset containing common keywords used in Taiwan's legislative text
analysis. These keywords are carefully selected to cover major policy
domains including disaster management, social welfare, housing policy,
and regional development.

## Usage

``` r
legis_keywords

data("legis_keywords")
```

## Format

A character vector containing 10 keywords, all in Traditional Chinese
(the language of the source legislative documents), grouped here by
policy domain for reference:

- disaster management:

  3 keywords, e.g. terms for the "823 Artillery Bombardment", the "921
  earthquake", and "earthquake" in general

- social welfare:

  3 keywords, e.g. terms for "childcare", "adult day care", and
  "long-term care"

- housing policy:

  2 keywords, e.g. terms for "military dependents' village
  redevelopment" and "village relocation"

- regional development:

  1 keyword, e.g. the term for "remote/rural areas"

- financial policy:

  1 keyword, e.g. the term for "bank/ATM card"

## Source

Keywords compiled based on common policy discussions in Taiwan
Legislative Yuan

## Details

Taiwan Legislative Keywords for Text Analysis

These keywords can be used with quanteda or other text analysis packages
to analyze legislative documents. They are particularly useful for:

- Creating document-term matrices

- Analyzing policy focus in legislative texts

- Tracking policy discussions over time

- Identifying key themes in parliamentary questions or texts

## References

Legislative Yuan, Taiwan. <https://www.ly.gov.tw/>

## Examples

``` r
# Load the keywords
data(legis_keywords)
```
