# Legislator's Demographic Data

## Using `get_legislators()` as an Example to Fetch Legislator Data

The get_legislators() function provides a straightforward way to access
Taiwan’s legislator data from the official parliamentary database.
Here’s a step-by-step demonstration:

``` r
library(legisTaiwan)
#> Error in get(paste0(generic, ".", class), envir = get_method_env()) : 
#>   object 'type_sum.accel' not found
#> ## legisTaiwan                                            ##
#> ## An R package connecting to the Taiwan Legislative API. ##
```

First, we load the legisTaiwan package which contains tools for
accessing Taiwan’s legislative data.

``` r
info <- get_legislators(verbose = FALSE)
#> 
#> Term is not defined...
#> Requesting full data from the API. Please ensure stable connectivity.
```

Here, we call get_legislators() and store the results in info. The
verbose = FALSE parameter suppresses the progress bar during data
fetching. This makes the function run quietly without displaying
download progress.

``` r
info$data
#> # A tibble: 1,649 × 15
#>    term  name  ename sex   party partyGroup areaName committee onboardDate
#>    <chr> <chr> <chr> <chr> <chr> <chr>      <chr>    <chr>     <chr>      
#>  1 00    ""    ""    ""    ""    00         全國不分區…… ""        ""         
#>  2 10    "王定宇… "Wan… "男"  "民主進… 民主進步黨 臺南市第6選舉… "第10屆第1會… "2020/02/0…
#>  3 10    "孔文吉… "Kun… "男"  "中國國… 中國國民黨 山地原住民選舉… "第10屆第1會… "2020/02/0…
#>  4 10    "王美惠… "Wan… "女"  "民主進… 民主進步黨 嘉義市選舉區…… "第10屆第1會… "2020/02/0…
#>  5 10    "王婉諭… "Wan… "女"  "時代力… 時代力量   全國不分區及僑… "第10屆第1會… "2020/02/0…
#>  6 10    "伍麗華… "WuL… "女"  "民主進… 民主進步黨 山地原住民選舉… "第10屆第1會… "2020/02/0…
#>  7 10    "江永昌… "Chi… "男"  "民主進… 民主進步黨 新北市第8選舉… "第10屆第1會… "2020/02/0…
#>  8 10    "江啟臣… "Chi… "男"  "中國國… 中國國民黨 臺中市第8選舉… "第10屆第1會… "2020/02/0…
#>  9 10    "何志偉… "Ho … "男"  "民主進… 民主進步黨 臺北市第2選舉… "第10屆第1會… "2020/02/0…
#> 10 10    "何欣純… "Ho … "女"  "民主進… 民主進步黨 臺中市第7選舉… "第10屆第1會… "2020/02/0…
#> # ℹ 1,639 more rows
#> # ℹ 6 more variables: degree <chr>, experience <chr>, picUrl <chr>,
#> #   leaveFlag <chr>, leaveDate <chr>, leaveReason <chr>
```

This command displays the retrieved data which includes comprehensive
information about legislators. The returned data frame contains various
fields about each legislator, such as:

- Personal information (name, gender, birth date)
- Electoral district details
- Party affiliation
- Committee and more!

Each row represents a unique legislator, making it easy to analyze or
extract specific information about Taiwan’s parliamentary
representatives.
