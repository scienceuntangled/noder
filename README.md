
<!-- README.md is generated from README.Rmd. Please edit that file -->

# noder

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

`noder` provides helper functions to install node JS into a
user-accessible directory (not a system installation), so that system
`node` calls can then be made from within R.

## Installation

You can install from [GitHub](https://github.com/scienceuntangled/noder)
with:

``` r
## install.packages("remotes") ## if needed
remotes::install_github("scienceuntangled/noder")
```

## Example usage

Install node. You only need to do this once.

``` r
library(noder)
nr_install_node()
```

The node executable should now be found:

``` r
nr_node_exe()
#>                                                                 node 
#> "/home/ben/.local/share/noder/node/node-v14.16.1-linux-x64/bin/node"
```

You can then call that node executable using `system()` or similar
commands. The `nr_exec_*` functions provide trivial wrappers around the
`sys::exec_*` functions, passing the full path to node as the `cmd`
argument to those functions:

``` r
## equivalent to a system call of `node --version`
nr_exec_wait("--version")
#> v14.16.1
#> [1] 0
```

Alternatively, add `node` to the system path with `nr_add_node_path()`,
and then subsequent system calls should find `node` or `npm`:

``` r
nr_add_node_path()
system2("node", "--version", stdout = TRUE)
#> [1] "v14.16.1"
system2("npm", "--version", stdout = TRUE)
#> [1] "6.14.12"
```
