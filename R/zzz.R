### Package Utility Functions
#' On package attach, display a startup message to the user.
#'
#' @keywords internal
.onAttach <- function(...) {
  packageStartupMessage("## legisTaiwan                                            ##")
  packageStartupMessage("## An R package connecting to the Taiwan Legislative API. ##")
}
