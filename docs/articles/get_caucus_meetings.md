# An Example of Party Caucus Negotiation

## Fetching Caucus Meeting Data

### Retrive Data

First, load the package:

``` r
library(legisTaiwan)
#> Error in get(paste0(generic, ".", class), envir = get_method_env()) : 
#>   object 'type_sum.accel' not found
#> ## legisTaiwan                                            ##
#> ## An R package connecting to the Taiwan Legislative API. ##
```

Now, let’s retrieve caucus meeting records. Note the special date format
required:

``` r
caucus_df <- get_caucus_meetings(
    start_date = "111/09/23", 
    end_date = "112/01/19", 
    verbose = FALSE
)
```

Important notes about date formatting:

- Dates must be in ROC calendar format
- Format required: “YYY/MM/DD” (with slashes)
- This differs from the format used in get_bills()

### View the Retrieved data:

The returned data includes comprehensive information about caucus
meetings, such as:

- Meeting dates and times
- Participating party caucuses
- Meeting agendas and topics
- Attendance records
- Meeting outcomes and decisions

``` r
caucus_df$data
#> # A tibble: 43 × 15
#>    comYear comVolume comBookId term  sessionPeriod sessionTimes
#>    <chr>   <chr>     <chr>     <chr> <chr>         <chr>       
#>  1 103     43        "四"      08    05            12          
#>  2 103     43        "四"      08    05            12          
#>  3 111     101       "下"      null  null          null        
#>  4 111     104       ""        10    06            08          
#>  5 111     104       ""        10    06            08          
#>  6 111     105       "下"      null  null          null        
#>  7 111     107       ""        null  null          null        
#>  8 111     114       "下"      null  null          null        
#>  9 111     86        ""        10    06            01          
#> 10 111     87        ""        10    06            02          
#> # ℹ 33 more rows
#> # ℹ 9 more variables: meetingTimes <chr>, meetingDate <chr>,
#> #   meetingName <chr>, subject <chr>, pageStart <chr>, pageEnd <chr>,
#> #   docUrl <chr>, htmlUrl <chr>, selectTerm <chr>
```

### Access Original Legislative Documents

The `docUrl` field provides direct access to the original caucus meeting
minutes and documentation. This URL links to the official Legislative
Yuan’s repository where researchers and the public can view detailed
records of caucus deliberations.

``` r
caucus_df$data[c("subject", "docUrl")]
#> # A tibble: 43 × 2
#>    subject                                                          docUrl
#>    <chr>                                                            <chr> 
#>  1 (一)行政院函請審議「運動彩券發行條例部分條文修正草案」；(二)委員蔣乃辛等29人擬具「運動彩券發行條例第十三條及第二十三條條… https…
#>  2 行政院函請審議「植物防疫檢疫法部分條文修正草案」案               https…
#>  3 一、本院社會福利及衛生環境委員會報告併案審查行政院函請審議「精神衛生法修正草案」、委員王婉諭等17人擬具「精神衛生法修正草案」… https…
#>  4 一、本院社會福利及衛生環境委員會報告併案審查行政院函請審議「精神衛生法修正草案」、委員王婉諭等17人擬具「精神衛生法修正草案」… https…
#>  5 一、併案協商(一)司法及法制委員會併案審查(1)行政院、司法院函請審議「中華民國刑法部分條文修正草案」(2)委員李貴敏等19人… https…
#>  6 行政院函請審議、本院台灣民眾黨黨團、時代力量黨團、委員曾銘宗等16人、委員楊瓊瓔等21人、委員謝衣鳯等16人、委員陳亭妃等21… https…
#>  7 一、本院社會福利及衛生環境委員會報告併案審查行政院函請審議「精神衛生法修正草案」、委員王婉諭等17人擬具「精神衛生法修正草案」… https…
#>  8 研商「公務人員個人專戶制退休資遣撫卹法草案」等5案相關事宜（「公務人員退休資遣撫卹法第九十三條及第九十五條條文修正草案」、「公… https…
#>  9 一、本院內政委員會報告併案審查行政院函請審議、委員王美惠等20人、委員蔣萬安等19人、委員賴惠員等19人、委員張宏陸等20人、… https…
#> 10 本院內政委員會報告併案審查民眾黨黨團、委員曾銘宗等18人、民眾黨黨團、時代力量黨團及委員吳玉琴等19人分別擬具「租賃住宅市場發… https…
#> # ℹ 33 more rows
```
