# Fetching Parliarmentary Questions

## Accessing Parliamentary Questions

This tutorial demonstrates how to use the legisTaiwan package to access
parliamentary questions and executive responses from Taiwan’s
Legislative Yuan. The package provides convenient functions to fetch
publicly available data.

### Loading the Package

First, install and load the legisTaiwan package:

``` r

library(legisTaiwan)
```

### Fetching Parliamentary Questions

Use the
[`get_parlquestions()`](https://davidycliao.github.io/legisTaiwan/reference/get_parlquestions.md)
function to retrieve parliamentary questions from legislators:

``` r

# Fetch questions from the 11th term
pa_term10 <- get_parlquestions(term = 11, verbose = TRUE)
#> 
#> Input Format Information:
#> ------------------------
#> Term: Must be numeric (e.g., 8, 9, 10)
#> Session Period: Must be numeric (1-8)
#> ------------------------
#> 
#> Downloading parliamentary questions data...
#>   |                                                                        |                                                                |   0%  |                                                                        |=============                                                   |  20%  |                                                                        |==========================                                      |  40%  |                                                                        |======================================                          |  60%  |                                                                        |===================================================             |  80%  |                                                                        |================================================================| 100%
#> 
#> 
#> ====== Retrieved Information ======
#> -----------------------------------
#>  URL: 
#>  https://data.ly.gov.tw/odw/ID6Action.action?term=11&sessionPeriod=&sessionTimes=&item=&fileType=json 
#>  Term:  11 
#>  Total Questions:  105 
#> 
#> Session Distribution:
#>  Session 01: 74
#>  Session 02: 31
#> ===================================

# Examine the data structure
str(pa_term10)
#> List of 8
#>  $ title           : chr "Parliamentary Questions Records"
#>  $ query_time      : POSIXct[1:1], format: "2024-12-28 02:56:46"
#>  $ retrieved_number: int 105
#>  $ retrieved_term  : chr "11"
#>  $ url             : chr "https://data.ly.gov.tw/odw/ID6Action.action?term=11&sessionPeriod=&sessionTimes=&item=&fileType=json"
#>  $ variable_names  : chr [1:5] "term" "sessionPeriod" "sessionTimes" "item" ...
#>  $ manual_info     : chr "https://data.ly.gov.tw/getds.action?id=6"
#>  $ data            : tibble [105 × 5] (S3: tbl_df/tbl/data.frame)
#>   ..$ term         : chr [1:105] "11" "11" "11" "11" ...
#>   ..$ sessionPeriod: chr [1:105] "01" "01" "01" "01" ...
#>   ..$ sessionTimes : chr [1:105] "01" "01" "05" "05" ...
#>   ..$ item         : chr [1:105] "乙、本院委員質詢部分" "一、本院羅委員智強，就文化部發放文化成年禮金政策屢傳遭濫用" "乙、本院委員質詢部分" "一、本院謝委員龍介，鑑於我國主要消費市場位處北臺灣，常需大型車輛南來北往載運暢貨，串聯產業供應鏈。惟民眾反映，"| __truncated__ ...
#>   ..$ selectTerm   : chr [1:105] "all" "all" "all" "all" ...
```

**Function parameters:**

- `term`: Legislative term (must be numeric, e.g., 11)
- `session_period`: Session period (optional)
- `verbose = TRUE`: Display download progress and information

**The returned data contains:**

- `title`: Data title
- `query_time`: Query timestamp
- `_retrieved_number`: Number of records retrieved
- `data`: A dataframe containing:
  - `term`: Legislative term
  - `sessionPeriod`: Session period
  - `sessionTimes`: Session count
  - `item`: Question items

### Retrieving Executive Responses

Use the get_executive_response() function to fetch responses from the
Executive Yuan:

``` r

# Fetch executive responses from the 10th term, 2nd session
exec_response <- get_executive_response(term = 10, session_period = 2, verbose = TRUE)
#> 
#> Input Format Information:
#> ------------------------
#> Term: Must be numeric (e.g., 8, 9, 10, 11)
#> Session Period: Must be numeric (1-8)
#> ------------------------
#> 
#> Downloading executive response data...
#>   |                                                                        |                                                                |   0%  |                                                                        |=============                                                   |  20%  |                                                                        |==========================                                      |  40%  |                                                                        |======================================                          |  60%  |                                                                        |===================================================             |  80%  |                                                                        |================================================================| 100%
#> 
#> 
#> ====== Retrieved Information ======
#> -----------------------------------
#>  URL: 
#>  https://data.ly.gov.tw/odw/ID2Action.action?term=10&sessionPeriod=02&sessionTimes=&item=&fileType=json 
#>  Term:  10 
#>  Session Period:  2 
#>  Total Responses:  1083 
#> 
#> Session Distribution:
#>  Session 02: 1083
#> ===================================

# Examine the data structure
head(exec_response$data)
#> # A tibble: 6 × 10
#>   term  sessionPeriod sessionTimes meetingTimes eyNumber  lyNumber subject
#>   <chr> <chr>         <chr>        <chr>        <chr>     <chr>    <chr>  
#> 1 10    02            01           null         （行政院函　中華… （立法院函　編… （一）行政院…
#> 2 10    02            01           null         （行政院函　中華… （立法院函　編… （二）行政院…
#> 3 10    02            01           null         （行政院函　中華… （立法院函　編… （三）行政院…
#> 4 10    02            01           null         （行政院函　中華… （立法院函　編… （四）行政院…
#> 5 10    02            01           null         （行政院函　中華… （立法院函　編… （五）行政院…
#> 6 10    02            01           null         （行政院函　中華… （立法院函　編… （六）行政院…
#> # ℹ 3 more variables: content <chr>, docUrl <chr>, selectTerm <chr>
```

**Function parameters:**

- `term`: Legislative term
- `session_period`: Session period
- `verbose = TRUE`: Display download progress and information

**The returned data includes:**

- `title`: Data title
- `query_time`: Query timestamp
- `retrieved_number`: Number of records retrieved
- `data`: A dataframe containing response information
