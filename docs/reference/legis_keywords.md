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

A character vector containing 10 keywords:

- 災害管理:

  八二三砲戰, 九二一大地震, 地震

- 社會福利:

  托育, 日間托老, 長照

- 住宅政策:

  眷村改建, 遷村

- 區域發展:

  偏鄉

- 金融政策:

  金融卡

## Source

Keywords compiled based on common policy discussions in Taiwan
Legislative Yuan

## Details

Taiwan Legislative Keywords for Text Analysis 常用立法關鍵字

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
