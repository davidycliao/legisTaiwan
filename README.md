
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Real-time and Archives of Taiwan Legislative Data in R <img src="man/figures/logo.png" align="right" width="180"/>

<!-- badges: start -->

[![codecov](https://codecov.io/gh/davidycliao/legisTaiwan/branch/master/graph/badge.svg?token=HVVTCOE90D)](https://codecov.io/gh/davidycliao/legisTaiwan)
[![R-CMD-check](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/R-CMD-check.yaml)
[![Test
coverage](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/test-coverage.yaml)
[![pkgdown](https://github.com/davidycliao/legisTaiwan/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/davidycliao/legisTaiwan/actions/workflows/pkgdown.yaml)
[![CodeFactor](https://www.codefactor.io/repository/github/davidycliao/legistaiwan/badge)](https://www.codefactor.io/repository/github/davidycliao/legistaiwan)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7633962.svg)](https://doi.org/10.5281/zenodo.7633962)
<!-- badges: end -->

<div style="text-align: justify; font-size: 1.1rem; line-height: 1.6; color: #333; max-width: 800px; margin: 1rem auto; padding: 0 1rem; font-family: 'Helvetica Neue', Arial, sans-serif;">

`legisTaiwan` is designed to streamline access to real-time archives of
Taiwan’s legislative data, drawing inspiration from the UK’s
TheyWorkForYou API. As the package interfaces directly with Legislative
Yuan API endpoints, a stable internet connection is required. Users are
welcome to contact
<a href="https://davidycliao.github.io" style="color: #3498db; text-decoration: none; border-bottom: 1px solid #3498db;">the
author</a> for any API implementation assistance.

</div>

<div style="text-align: justify; font-size: 0.95rem; line-height: 1.6; color: #333; max-width: 800px; margin: 1rem auto; padding: 0 1rem; font-family: 'Helvetica Neue', Arial, sans-serif;">

`legisTaiwan` 套件旨在簡化台灣立法院資料的即時存取。透過在 R
環境中提供直接連接立法院開放資料 API
的便捷管道，本套件不僅致力於提升立法問責制和公共透明度，更為學術研究者提供了系統化分析立法數據的工具。研究人員可以輕鬆獲取並分析立法委員的表決紀錄、問政質詢、法案提案等資料，有助於國會研究與量化研究和實證分析。由於套件需要直接與由[歐噴公司](https://openfun.tw/#works)開發開源的立法院
API 介接，使用時請確保網路連線穩定。如有任何 legisTaiwan
R套件使用上的問題，歡迎open issue 在githut
上或<a href="https://davidycliao.github.io" style="color: #3498db; text-decoration: none; border-bottom: 1px solid #3498db;">我們</a>聯繫。

</div>

<br>

### Get Started with Using [`remotes`](https://github.com/r-lib/remotes):

``` r
install.packages("remotes")
remotes::install_github("davidycliao/legisTaiwan", force = TRUE)
```

    library(legisTaiwan)
    #> ## legisTaiwan                                            ##
    #> ## An R package connecting to the Taiwan Legislative API. ##

<br>

### Talks & Presentations:

- **28 Apr 2025:** <u>*R-Ladies Taipei*</u> 讓分析台灣國會數據更透明 —
  `legisTaiwan` R 套件 (Shaka Y.J. Li and Yen-Chieh Liao)
  [![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=white)](https://github.com/davidycliao/r-ladies-tpe-legistaiwan?tab=readme-ov-file)

- **11-14 Sept 2025:** <u>*Legislative Studies Session* </u>, Annual
  Conference of American Political Science Association, Vancouver, CA.
  (Shaka Y.J. Li )

<br>

### Notice:

<div style="text-align: justify; font-size: 1.1rem; line-height: 1.6; color: #333; max-width: 800px; margin: 1rem auto; padding: 0 1rem; font-family: 'Helvetica Neue', Arial, sans-serif;">

- The Legislative Yuan API has transitioned from `https://ly.govapi.tw`
  to `https://v2.ly.govapi.tw`. While we are still supporting functions
  that use the legacy API, please note that according to official
  notice, the old API endpoint will not be maintained. We recommend
  users to gradually transition to [the newer functions]() attached with
  API V2.

</div>

### Support:

<div style="text-align: justify; font-size: 1.1rem; line-height: 1.6; color: #333; max-width: 800px; margin: 1rem auto; padding: 0 1rem; font-family: 'Helvetica Neue', Arial, sans-serif;">

如果您覺得這個套件對您的研究有幫助，歡迎考慮藉由開放文化基金會（OCF）小額或定額捐款給[g0v
揪松團](https://ocf.tw/p/g0vdathon/)、[台灣公民監督國會聯盟](https://ccw.org.tw/donation)或[報導者](https://support.twreporter.org)，支持台灣獨立媒體與數位公民組織的持續營運和國會監督工作。如果您對資料分析有任何問題，也歡迎與我們聯繫。

If you find `legisTaiwan` helpful for your research, you are welcome to
consider making a small donation to [Taiwan g0v
hackathons](https://ocf.tw/p/g0vdathon/), [the Taiwan Congress Watch
Foundation](https://ccw.org.tw/donation) , [the Taiwan Congress Watch
Foundation](https://ccw.org.tw/donation) or [The
Reporter](https://support.twreporter.org) support Taiwan’s independent
media operations, g0v civic community, and parliamentary oversight work.
If you have any questions about data analysis, feel free to contact us
for discussion.

</div>

<br>
