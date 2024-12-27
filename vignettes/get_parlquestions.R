## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----include=FALSE------------------------------------------------------------
assign("has_internet_via_proxy", TRUE, environment(curl::has_internet))
library(legisTaiwan)

## -----------------------------------------------------------------------------
library(legisTaiwan)

## -----------------------------------------------------------------------------
# Fetch questions from the 11th term
pa_term10 <- get_parlquestions(term = 11, verbose = TRUE)

# Examine the data structure
str(pa_term10)

## -----------------------------------------------------------------------------
# Fetch executive responses from the 10th term, 2nd session
exec_response <- get_executive_response(term = 10, session_period = 2, verbose = TRUE)

# Examine the data structure
head(exec_response$data)

