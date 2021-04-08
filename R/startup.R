.onAttach <- function(libname, pkgname) {
    if (get_os() %in% c("osx", "linux") && is.null(nr_node_exe()) && !requireNamespace("archive", quietly = TRUE)) {
        msg <- "the 'archive' package is required to install node: install 'archive' with\n"
        if (!requireNamespace("remotes", quietly = TRUE)) msg <- paste0(msg, "  install.packages(\"remotes\")\n")
        msg <- paste0(msg, "  remotes::install_github(\"jimhester/archive\")")
        packageStartupMessage(msg)
    }
}
