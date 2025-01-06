## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval = FALSE-------------------------------------------------------------
#  install.packages("remotes")
#  remotes::install_github("davidycliao/legisTaiwan", force = TRUE)

## -----------------------------------------------------------------------------
library(legisTaiwan)

## ----include=FALSE------------------------------------------------------------
assign("has_internet_via_proxy", TRUE, environment(curl::has_internet))

