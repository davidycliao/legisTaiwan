
#' Register S3 methods and set up package
#' @keywords internal
.onLoad <- function(libname, pkgname) {
  # 檢查並註冊 S3 方法
  if (requireNamespace("vctrs", quietly = TRUE)) {
    vctrs::s3_register("pillar::type_sum", "accel")
  }
}


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

  # Coloring Taiwan
  rainbow_taiwan <- paste0(
    red, "T",
    orange, "a",
    yellow, "i",
    green, "w",
    blue, "a",
    indigo, "n",
    reset
  )

  # Creating the messages
  base_message1 <- paste0(dark_green, "legis", reset, rainbow_taiwan, " v0.2.1")
  message2 <- "## An R package connecting to the Taiwan Legislative API. ##"

  # Calculate padding to align message1 with message2
  message2_width <- nchar(message2)
  base_message1_width <- nchar(base_message1) - (6 * 9)  # Subtract length of color codes (9 codes * 6 characters)
  padding_needed <- message2_width - base_message1_width - 1  # -4 for the "## " and " ##"

  # Create aligned message1
  message1 <- paste0("## ", base_message1, paste(rep(" ", padding_needed), collapse = ""), " ##")

  # Display messages
  packageStartupMessage(message1)
  packageStartupMessage(message2)
}

#' @export
type_sum.accel <- function(x) {
  "accel"
}
