#' On package attach, display a startup message
#'
#' @keywords internal
.onAttach <- function(...) {
  # ANSI color codes
  dark_green <- "\033[38;5;22m"  # Deep Green color
  red     <- "\033[31m"
  orange  <- "\033[38;5;214m"
  yellow  <- "\033[33m"
  green   <- "\033[32m"
  blue    <- "\033[34m"
  indigo  <- "\033[38;5;54m"
  violet  <- "\033[35m"
  reset   <- "\033[0m"

  # Coloring Taiwan in rainbow colors
  rainbow_taiwan <- paste0(
    red, "T",
    orange, "a",
    yellow, "i",
    green, "w",
    blue, "a",
    indigo, "n",
    reset
  )

  # Creating the first message
  message1 <- paste0(dark_green, "legis", reset, rainbow_taiwan)

  # Maximum allowed length
  max_len <- 64
  num_spaces <- max_len - nchar(message1, type = "bytes") - 4
  num_spaces <- max(0, num_spaces)

  message1 <- paste0("## ", message1, rep(" ", num_spaces), " ##")

  # Second message
  message2 <- "## An R package connecting to the Taiwan Legislative API. ##"

  packageStartupMessage(message1)
  packageStartupMessage(message2)
}
