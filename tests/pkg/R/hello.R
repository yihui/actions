#' Return a greeting
#' @export
hello <- function() xfun::file_string(system.file("DESCRIPTION", package = "testpkg"))
