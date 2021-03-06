% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/exec.R
\name{nr_exec_wait}
\alias{nr_exec_wait}
\alias{nr_exec_internal}
\alias{nr_exec_background}
\title{Execute node commands}
\usage{
nr_exec_wait(...)

nr_exec_internal(...)

nr_exec_background(...)
}
\arguments{
\item{...}{: as for \code{\link[sys:exec]{sys::exec_wait()}}, \code{\link[sys:exec]{sys::exec_background()}}, \code{\link[sys:exec]{sys::exec_internal()}}}
}
\value{
As for \code{\link[sys:exec]{sys::exec_wait()}}, \code{\link[sys:exec]{sys::exec_background()}}, \code{\link[sys:exec]{sys::exec_internal()}}
}
\description{
These functions call \code{\link[sys:exec]{sys::exec_wait()}}, \code{\link[sys:exec]{sys::exec_background()}}, or \code{\link[sys:exec]{sys::exec_internal()}}, using the \code{noder}-installed node executable as the \code{cmd} argument.
}
\examples{

nr_exec_wait("--version")

}
