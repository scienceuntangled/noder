
<!-- README.md is generated from README.Rmd. Please edit that file -->

# noder

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

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
#> /home/ben/.local/share/noder/node/node-v14.16.1-linux-x64/bin/node
```

You can then call that node executable in whatever way you like. The
`nr_exec_*` functions provide trivial wrappers around the `sys::exec_*`
functions:

``` r
nr_exec_wait("--version")
#> v14.16.1
#> [1] 0
```
