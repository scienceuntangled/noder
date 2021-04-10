#' Install nodeJS
#'
#' This is a helper function to install node. The node binaries will be downloaded from <https://nodejs.org/en/download/> and saved to your user appdata directory.
#'
#' @references <https://nodejs.org/en/download/>
#' @param version string: "LTS" (long-term support, recommended) or "current"
#' @param bits integer: 32 or 64, for 32- or 64-bit install. If missing or `NULL`, will be guessed based on `.Machine$sizeof.pointer`
#' @param force logical: force reinstallation if node already exists
#'
#' @return the path to the installed executable
#'
#' @examples
#' \dontrun{
#'   nr_install_node()
#' }
#'
#' @export
nr_install_node <- function(version = "LTS", bits, force = FALSE) {
    assert_that(is.string(version))
    version <- match.arg(version, c("LTS", "current"))
    assert_that(is.flag(force), !is.na(force))
    if (missing(bits) || is.null(bits) || !bits %in% c(32, 64)) {
        bits <- tryCatch(if (.Machine$sizeof.pointer==8) 64 else 32, error = function(e) 64)
    }
    assert_that(bits %in% c(32, 64))
    bits <- paste0("x", if (bits == 32) "86" else "64")
    if (get_os() %in% c("osx", "linux")) {
        if (!requireNamespace("archive", quietly = TRUE)) {
            msg <- "the 'archive' package is required: install it with\n"
            if (!requireNamespace("remotes", quietly = TRUE)) msg <- paste0(msg, "  install.packages(\"remotes\")\n")
            stop(paste0(msg, "  remotes::install_github(\"jimhester/archive\")"))
        }
    }
    existing_exe <- nr_node_exe()
    path <- file.path(noder_app_dir(), "node")
    if (!force) {
        if (!is.null(existing_exe)) {
            message("node already exists and force is FALSE, not reinstalling")
            return(existing_exe)
        }
    } else {
        if (dir.exists(path)) {
            ## remove existing
            unlink(path, recursive = TRUE)
        }
    }
    if (!dir.exists(path)) dir.create(path, recursive = TRUE)
    if (!dir.exists(path)) stop("could not create directory ", path, " for node")
    dl_url <- "https://nodejs.org/en/download/"
    if (version == "current") dl_url <- paste0(dl_url, "current/")
    pg <- readLines(dl_url, warn = FALSE)
    ## find our target
    ##  https://nodejs.org/dist/v14.16.1/node-v14.16.1-win-x86.zip
    ##  https://nodejs.org/dist/v14.16.1/node-v14.16.1-win-x64.zip
    ##  https://nodejs.org/dist/v14.16.1/node-v14.16.1-linux-x64.tar.xz
    ##  https://nodejs.org/dist/v14.16.1/node-v14.16.1-darwin-x64.tar.gz
    rgxp <- paste0("https://nodejs\\.org/dist/v[[:digit:]\\.]+/node\\-v[[:digit:]\\.]+\\-", get_os2(), "-", bits, "\\.(zip|tar\\.gz|tar\\.xz)")
    dl_url <- pg[grep(rgxp, pg)]
    dl_url <- regmatches(dl_url, regexpr(rgxp, dl_url))
    if (length(dl_url) != 1) {
        stop("could not find download url")
    }
    zipname <- file.path(path, basename(dl_url))
    err <- utils::download.file(dl_url, destfile = zipname, mode = "wb")
    if (!err) {
        if (grepl("zip$", zipname)) {
            utils::unzip(zipname, exdir = path)
        } else {##if (grepl("xz$", zipname)) {
            archive::archive_extract(zipname, dir = path)
        }
    }
    ## now we should see the executable
    chk <- nr_node_exe()
    if (!is.null(chk)) chk else stop("Sorry, node install failed. You will need to install it yourself and ensure that it is on the system path.")
}

noder_app_dir <- function() rappdirs::user_data_dir(appname = "noder")


#' The path to the node executable
#'
#' @return The path to the executable, or `NULL` if not found
#'
#' @examples
#'
#' nr_node_exe()
#'
#' @export
nr_node_exe <- function() {
    exe_name <- paste0("node", if (get_os() == "windows") ".exe")
    chk <- Sys.which(exe_name)
    if (nzchar(chk)) return(chk)
    ## is it installed in user appdir?
    mydir <- file.path(noder_app_dir(), "node")
    if (!dir.exists(mydir)) return(NULL)
    chk <- fs::dir_ls(path = mydir, recurse = TRUE, regexp = paste0(exe_name, "$"), type = "file")
    chk <- chk[basename(chk) == exe_name]
    if (length(chk) == 1 && file.exists(chk)) chk else NULL
}


#' Add the path to node/npm to the system path
#'
#' If `npm` can already be seen by the system, the system path will not be changed. Otherwise, the system path will be prepended with the node/npm path.
#'
#' @return `TRUE` on success, invisibly
#'
#' @export
nr_add_node_path <- function() {
    if (!nzchar(Sys.which("npm"))) {
        if (is.null(nr_node_exe())) stop("could not find the node executable")
        node_dir <- dirname(nr_node_exe())
        if (nzchar(node_dir)) {
            psep <- if (get_os() == "windows") ";" else ":"
            Sys.setenv(PATH = paste0(node_dir, psep, Sys.getenv("PATH")))
        }
    }
    if (!nzchar(Sys.which("npm"))) stop("could not set the path to node and npm")
    invisible(TRUE)
}


## adapted from http://conjugateprior.org/2015/06/identifying-the-os-from-r/
get_os <- function() {
    if (.Platform$OS.type == "windows") return("windows")
    sysinf <- Sys.info()
    if (!is.null(sysinf)){
        os <- sysinf["sysname"]
        if (tolower(os) == "darwin")
            os <- "osx"
    } else {
        os <- .Platform$OS.type
        if (grepl("^darwin", R.version$os, ignore.case = TRUE))
            os <- "osx"
        if (grepl("linux-gnu", R.version$os, ignore.case = TRUE))
            os <- "linux"
    }
    os <- tolower(os)
    if (!os %in% c("windows", "linux", "unix", "osx"))
        stop("unknown operating system: ", os)
    os
}

get_os2 <- function() {
    os <- get_os()
    if (os == "osx") "darwin" else if (os == "windows") "win" else os
}
