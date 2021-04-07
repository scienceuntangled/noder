#' Execute node commands
#'
#' These functions call [sys::exec_wait()], [sys::exec_background()], or [sys::exec_internal()], using the `noder`-installed node executable as the `cmd` argument.
#'
#' @param ...  : as for [sys::exec_wait()], [sys::exec_background()], [sys::exec_internal()]
#'
#' @return As for [sys::exec_wait()], [sys::exec_background()], [sys::exec_internal()]
#'
#' @examples
#'
#' nr_exec_wait("--version")
#'
#' @export
nr_exec_wait <- function(...) {
    sys::exec_wait(cmd = exe_with_err(), ...)
}

#' @export
#' @rdname nr_exec_wait
nr_exec_internal <- function(...) {
    sys::exec_internal(cmd = exe_with_err(), ...)
}

#' @export
#' @rdname nr_exec_wait
nr_exec_background <- function(...) {
    sys::exec_background(cmd = exe_with_err(), ...)
}

exe_with_err <- function() {
    exe <- nr_node_exe()
    if (is.null(exe)) stop("could not find the nodejs executable")
    exe
}
