# Lecture 6: the tidyverse
Romain Ferrali

Today, we’re going to talk about the tidyverse, a collection of R
packages that are designed to work together to make data manipulation
and visualization easier. All the packages we’ve seen before (`readr`,
`ggplot2`, `tibble`) are actually part of the tidyverse. It also
includes other packages, like `dplyr` for data manipulation, and `purrr`
for functional programming, as well as many others.

Our goal: make a super nice plot to definitively answer the question:
did soccer get less exciting over time?

``` r
library(tidyverse) # the mighty package!
```

    ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ✔ dplyr     1.1.4     ✔ readr     2.1.6
    ✔ forcats   1.0.1     ✔ stringr   1.6.0
    ✔ ggplot2   4.0.1     ✔ tibble    3.3.1
    ✔ lubridate 1.9.4     ✔ tidyr     1.3.2
    ✔ purrr     1.2.1     
    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
df <- read_csv("./data/lecture-1-england.csv")
```

    New names:
    Rows: 203956 Columns: 13
    ── Column specification
    ──────────────────────────────────────────────────────── Delimiter: "," chr
    (5): home, visitor, FT, division, result dbl (7): ...1, Season, hgoal, vgoal,
    tier, totgoal, goaldif date (1): Date
    ℹ Use `spec()` to retrieve the full column specification for this data. ℹ
    Specify the column types or set `show_col_types = FALSE` to quiet this message.
    • `` -> `...1`

## The pipe operator: chaining commands together

``` r
# example: turn lowercase letters into uppercase letters, then bind them together
```

## Data manipulation with dplyr

``` r
# select(): let's get rid of the columns we don't need
# rename(): I don't like upper case letters in column names, let's change them
# mutate(): let's create the decade variable
# filter(): remove incomplete decades

# which decade was most exciting?
# group_by() and summarize(): group-wise operations that compress data into a single row per group
# arrange(): sorting data

# which team had the most home goals relative to others?
# group_by() and mutate(): group-wise operations that keep the same number of rows
```

``` r
# average number of goals per decade
```

## More complicated manipulation: loops (bad) vs. map functions (good)

``` r
# let's add confidence intervals to our plot
```

``` r
# let's make the ultimate plot to answer the question: did soccer get less exciting over time?
```
