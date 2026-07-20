# The Records of the Bills

## An Example of the Records of the Bills

This section demonstrates how to fetch and analyze legislative bills
data from Taiwan’s parliament using the legisTaiwan package. We’ll
explore two different methods of retrieving bill data using specific
date ranges and legislative terms.

``` r

library(legisTaiwan)
#> Error in get(paste0(generic, ".", class), envir = get_method_env()) : 
#>   object 'type_sum.accel' not found
#> ## legisTaiwan                                            ##
#> ## An R package connecting to the Taiwan Legislative API. ##
```

First, we’ll fetch bills within a specific date range. Note that the
dates use the Republic of China (ROC) calendar system:

- Start date: 106/01/20 (ROC calendar)
- End date: 111/03/10 (ROC calendar)

``` r

billdata <- get_bills(start_date = 1030120,end_date = 1110310, verbose = TRUE)
#> 
#> Input Format Information:
#> ------------------------
#> Date format: YYYMMDD (ROC calendar)
#> Example: 1090101 for 2020/01/01
#> ------------------------
#> 
#> Downloading data...
#>   |                                                                        |                                                                |   0%  |                                                                        |===================                                             |  30%  |                                                                        |======================================                          |  60%  |                                                                        |==========================================================      |  90%  |                                                                        |================================================================| 100%
#> 
#> 
#> ====== Retrieved Information ======
#> -----------------------------------
#>  Retrieved URL: 
#>  https://www.ly.gov.tw/WebAPI/LegislativeBill.aspx?from=1030120&to=1110310&proposer=&mode=json 
#>  Total Unique Proposers: 4585 
#>  Retrieved date between: 2014-01-20 and 2022-03-10 
#>  Retrieved Number:  12519 
#>  Total Unique Proposers: 4585
#> ===================================
```

The get_bills() function returns a comprehensive list containing the
metadata and the actual bill data:

``` r

str(billdata,  give.attr = FALSE)
#> List of 12
#>  $ title           : chr "the records of bill sponsor and co-sponsor"
#>  $ query_time      : POSIXct[1:1], format: "2024-12-28 02:56:17"
#>  $ retrieved_number: int 12519
#>  $ proposer        : NULL
#>  $ start_date_ad   : Date[1:1], format: "2014-01-20"
#>  $ end_date_ad     : Date[1:1], format: "2022-03-10"
#>  $ start_date      : num 1030120
#>  $ end_date        : num 1110310
#>  $ url             : chr "https://www.ly.gov.tw/WebAPI/LegislativeBill.aspx?from=1030120&to=1110310&proposer=&mode=json"
#>  $ variable_names  : chr [1:9] "date" "term" "sessionPeriod" "sessionTimes" ...
#>  $ manual_info     : chr "https://www.ly.gov.tw/Pages/List.aspx?nodeid=153"
#>  $ data            : tibble [12,519 × 9] (S3: tbl_df/tbl/data.frame)
#>   ..$ date           : chr [1:12519] "1110304" "1110304" "1110304" "1110304" ...
#>   ..$ term           : chr [1:12519] "10" "10" "10" "10" ...
#>   ..$ sessionPeriod  : chr [1:12519] "05" "05" "05" "05" ...
#>   ..$ sessionTimes   : chr [1:12519] "02" "02" "02" "02" ...
#>   ..$ billName       : chr [1:12519] "公民投票法第三十條及第三十二條條文修正草案" "財政收支劃分法第十六條之二、第三十七條之二及第三十八條之二條文修正草案" "勞工保險條例第六十六條及第六十九條條文修正草案" "中華民國憲法增修條文第九條之一、第十條及第十條之一條文修正草案" ...
#>   ..$ billProposer   : chr [1:12519] "曾銘宗" "曾銘宗 ; 費鴻泰 ; 謝衣鳯" "曾銘宗 ; 費鴻泰 ; 謝衣鳯" "孔文吉" ...
#>   ..$ billCosignatory: chr [1:12519] "萬美玲 ; 鄭天財 ; 林為洲 ; 鄭麗文 ; 楊瓊瓔 ; 吳怡玎 ; 洪孟楷 ; 林德福 ; 溫玉霞 ; 孔文吉 ; 陳雪生 ; 李德維 ; 林"| __truncated__ "廖婉汝 ; 洪孟楷 ; 葉毓蘭 ; 陳玉珍 ; 徐志榮 ; 李貴敏 ; 林文瑞 ; 李德維 ; 溫玉霞 ; 萬美玲 ; 鄭正鈐 ; 鄭天財 ; 林"| __truncated__ "鄭正鈐 ; 洪孟楷 ; 李貴敏 ; 廖婉汝 ; 林思銘 ; 陳玉珍 ; 徐志榮 ; 葉毓蘭 ; 李德維 ; 溫玉霞 ; 萬美玲 ; 林文瑞 ; 吳"| __truncated__ "陳雪生 ; 洪孟楷 ; 林文瑞 ; 賴士葆 ; 廖國棟 ; 曾銘宗 ; 鄭正鈐 ; 陳椒華 ; 傅崐萁 ; 溫玉霞 ; 翁重鈞 ; 萬美玲 ; 賴"| __truncated__ ...
#>   ..$ billStatus     : chr [1:12519] "" "" "" "" ...
#>   ..$ date_ad        : Date[1:12519], format: "2022-03-04" ...
```

`billdata` is a list containing 12 elements:

- `$title` “the records of bill sponsor and co-sponsor”
- `$query_time`: imestamp of when the data was retrieved
- `$retrieved_number`: Total number of records retrieved
- `$proposer`: Filter condition for bill proposers
- `$start_date_ad` and `end_date_ad`:
- `$url`: source API URL for the data
- `$variable_names`: List of column names in the dataset
- `$manual_info`: Link to official documentation page
- `$data`: tibble \[12,519 × 9\]

`billdata$data` returns tibble table containing relevent information.

``` r

billdata$data
#> # A tibble: 12,519 × 9
#>    date    term  sessionPeriod sessionTimes billName          billProposer
#>    <chr>   <chr> <chr>         <chr>        <chr>             <chr>       
#>  1 1110304 10    05            02           公民投票法第三十條及第三十二條條… 曾銘宗      
#>  2 1110304 10    05            02           財政收支劃分法第十六條之二、第三… 曾銘宗 ; 費鴻泰 ;…
#>  3 1110304 10    05            02           勞工保險條例第六十六條及第六十九… 曾銘宗 ; 費鴻泰 ;…
#>  4 1110304 10    05            02           中華民國憲法增修條文第九條之一、… 孔文吉      
#>  5 1110304 10    05            02           公平交易法第四十二條條文修正草案… 洪孟楷      
#>  6 1110304 10    05            02           國民教育法第二條、第三條及第六條… 洪孟楷      
#>  7 1110304 10    05            02           職業安全衛生法第一條、第六條及第… 洪孟楷      
#>  8 1110304 10    05            02           耕地三七五減租條例第十九條及第三… 張育美      
#>  9 1110304 10    05            02           建築法第七十七條之一及第九十一條… 張育美      
#> 10 1110304 10    05            02           道路交通管理處罰條例第三十一條條… 張育美      
#> # ℹ 12,509 more rows
#> # ℹ 3 more variables: billCosignatory <chr>, billStatus <chr>,
#> #   date_ad <date>
```

- `query_time`: When the data was retrieved
- `retrieved_number`: Number of records fetched
- `meeting_unit`: Legislative unit information
- `start_date_ad/end_date_ad`: Dates in Western calendar
- `start_date/end_date`: Dates in ROC calendar
- `url`: Source URL
- `variable_names`: Column names in the dataset
- `manual_info`: Additional documentation
- `data`: The actual bill records

Alternatively, you can fetch bills by legislative term using
[`get_bills_2()`](https://davidycliao.github.io/legisTaiwan/reference/get_bills_2.md):

``` r

full_term <- get_bills_2(term = 11)
#> 
#> Input Format Information:
#> ------------------------
#> Term: Must be numeric (e.g., 8, 9, 10, 11)
#> Session Period: Must be numeric (1-8)
#> ------------------------
#> 
#> Downloading legislative bills data...
#>   |                                                                        |                                                                |   0%  |                                                                        |=============                                                   |  20%  |                                                                        |==========================                                      |  40%  |                                                                        |======================================                          |  60%  |                                                                        |===================================================             |  80%  |                                                                        |================================================================| 100%
#> 
#> 
#> ====== Retrieved Information ======
#> -----------------------------------
#>  Retrieved URL: 
#>  https://data.ly.gov.tw/odw/ID20Action.action?term=11&sessionPeriod=&sessionTimes=&meetingTimes=&billName=&billOrg=&billProposer=&billCosignatory=&fileType=json 
#>  Retrieved Term:  11 
#>  Total Bills: 2880
#>  Total Unique Proposers: 115
#> ===================================
full_term
#> $title
#> [1] "The records of the questions answered by the executives"
#> 
#> $query_time
#> [1] "2024-12-28 02:56:29 GMT"
#> 
#> $retrieved_number
#> [1] 2880
#> 
#> $budget_bills
#> [1] 18
#> 
#> $budget_percentage
#> [1] 0.625
#> 
#> $retrieved_term
#> [1] "11"
#> 
#> $url
#> [1] "https://data.ly.gov.tw/odw/ID20Action.action?term=11&sessionPeriod=&sessionTimes=&meetingTimes=&billName=&billOrg=&billProposer=&billCosignatory=&fileType=json"
#> 
#> $variable_names
#>  [1] "term"            "sessionPeriod"   "sessionTimes"   
#>  [4] "meetingTimes"    "billNo"          "billName"       
#>  [7] "billOrg"         "billProposer"    "billCosignatory"
#> [10] "billStatus"      "pdfUrl"          "docUrl"         
#> [13] "selectTerm"     
#> 
#> $manual_info
#> [1] "https://data.ly.gov.tw/getds.action?id=2"
#> 
#> $data
#> # A tibble: 2,880 × 13
#>    term  sessionPeriod sessionTimes meetingTimes billNo   billName billOrg
#>    <chr> <chr>         <chr>        <chr>        <chr>    <chr>    <chr>  
#>  1 11    01            01           ""           2021100… 「立法委員互選… 本院委員羅智…
#>  2 11    01            01           ""           2021100… 「再生醫療法草… 本院委員邱議…
#>  3 11    01            01           ""           2021100… 「再生醫療製劑… 本院委員邱議…
#>  4 11    01            01           ""           2021100… 「癌症防治法第… 本院委員邱議…
#>  5 11    01            01           ""           2021100… 「不在籍投票法… 本院委員王鴻…
#>  6 11    01            01           ""           2021100… 「預算法第八十… 本院委員王鴻…
#>  7 11    01            01           ""           2021100… 「核子反應器設… 本院委員王鴻…
#>  8 11    01            01           ""           2021100… 「立法院職權行… 本院台灣民眾…
#>  9 11    01            01           ""           2021100… 「貪污治罪條例… 本院台灣民眾…
#> 10 11    01            01           ""           2021100… 「立法委員互選… 本院台灣民眾…
#> # ℹ 2,870 more rows
#> # ℹ 6 more variables: billProposer <chr>, billCosignatory <chr>,
#> #   billStatus <chr>, pdfUrl <chr>, docUrl <chr>, selectTerm <chr>
```

This retrieves all bills from the specified legislative term (in this
case, the 11th term), providing a convenient way to analyze legislative
activities within specific parliamentary periods.

The returned data includes detailed information about each bill, such
as:

- Bill status and progress
- Sponsoring legislators
- Committee referrals
- Dates of various legislative actions
- Bill content and explanatory notes
