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

# approach 1: intermediate variables
upperletters <- toupper(letters)
paste(upperletters, collapse = "")
```

    [1] "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

``` r
# this is bad because you end up storing a lot of intermediate variables
# those end up cluttering your environment
# which makes it harder to keep track of what's going on
# e.g.: you create a new object, will it overwrite an existing one?

# approach 2: nesting functions
paste(toupper(letters), collapse = "")
```

    [1] "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

``` r
# you fix the clutter problem, but it can get hard to
# read when you have a lot of nested functions

# approach 3: the pipe operator
# the pipe operator takes the output of one function and
# feeds it into the first argument of the next function
letters |> toupper() # this
```

     [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S"
    [20] "T" "U" "V" "W" "X" "Y" "Z"

``` r
toupper(letters) # is the same as this
```

     [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S"
    [20] "T" "U" "V" "W" "X" "Y" "Z"

``` r
# so we can chain together multiple functions
# without having to create intermediate variables or nest functions
letters |>
  toupper() |>
  paste(collapse = "")
```

    [1] "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

## Data manipulation with dplyr

### The basics: select(), rename(), mutate(), filter(), group_by(), summarize()

``` r
# let's get the mean number of goals per game for each decade
# we store this into a new data frame called pl, my shorthand for "plot"
pl <- df |>
  # select(): selects only the columns you need
  select(Season, totgoal) |>
  # rename(): rename columns to make them easier to work with
  rename(season = Season, goals = totgoal) |>
  # mutate(): create new variables based on existing ones
  mutate(
    # you can do any kind of transformation you want in mutate()
    decade = season / 10,
    # they are applied sequentially, so you can use the variables you just created
    decade = floor(decade) * 10
  ) |>
  # filter(): filter rows based on some condition
  # you apply multiple filters sequentially, and they are combined with "and"
  filter(decade > 1880, decade < 2020) |>
  # magic trick: you can use group_by() and summarize() to do group-wise operations
  group_by(decade) |>
  summarize(goals = mean(goals))
```

``` r
ggplot(pl, aes(x = decade, y = goals)) +
  geom_line() +
  geom_point() +
  labs(
    x = "Decade",
    y = "Average number of goals per game",
    title = "Did soccer get less exciting over time?"
  )
```

![](lecture-6_files/figure-commonmark/data%20visualization%201-1.png)

### More on group_by()

``` r
# you can group by multiple variables, and then summarize or mutate within those groups
# e.g., we want the mean number of home goals per team per season
df |>
  select(season = Season, team = home, goals = hgoal) |>
  group_by(season, team) |>
  summarize(goals = mean(goals))
```

    `summarise()` has grouped output by 'season'. You can override using the
    `.groups` argument.

    # A tibble: 9,555 × 3
    # Groups:   season [123]
       season team              goals
        <dbl> <chr>             <dbl>
     1   1888 Accrington F.C.    2.36
     2   1888 Aston Villa        4   
     3   1888 Blackburn Rovers   4   
     4   1888 Bolton Wanderers   3.18
     5   1888 Burnley            1.91
     6   1888 Derby County       2   
     7   1888 Everton            2.18
     8   1888 Notts County       2.27
     9   1888 Preston North End  3.55
    10   1888 Stoke City         1.36
    # ℹ 9,545 more rows

``` r
# notice that the output is a data frame with one row per team per season
# also notice that it still has a grouping structure
# The output says: "Groups:   season [123]"
# this means that the data frame is still grouped by season,
# so if we do another group-wise operation, it will be done within each season
# this may or may not be what we want, depending on what we want to do next
# to remove the grouping structure, we can use ungroup()

df |>
  select(season = Season, team = home, goals = hgoal) |>
  group_by(season, team) |>
  summarize(goals = mean(goals)) |>
  ungroup()
```

    `summarise()` has grouped output by 'season'. You can override using the
    `.groups` argument.

    # A tibble: 9,555 × 3
       season team              goals
        <dbl> <chr>             <dbl>
     1   1888 Accrington F.C.    2.36
     2   1888 Aston Villa        4   
     3   1888 Blackburn Rovers   4   
     4   1888 Bolton Wanderers   3.18
     5   1888 Burnley            1.91
     6   1888 Derby County       2   
     7   1888 Everton            2.18
     8   1888 Notts County       2.27
     9   1888 Preston North End  3.55
    10   1888 Stoke City         1.36
    # ℹ 9,545 more rows

``` r
# which decade was most exciting?
# group_by() and summarize(): group-wise operations that compress data into a single row per group
# arrange(): sorting data

df_decade <- df |>
  select(season = Season, goals = totgoal) |>
  mutate(
    decade = floor(season / 10) * 10
  ) |>
  filter(decade > 1880, decade < 2020)

df_decade |>
  group_by(decade) |>
  summarize(goals = mean(goals)) |>
  arrange(-goals)
```

    # A tibble: 13 × 2
       decade goals
        <dbl> <dbl>
     1   1890  3.61
     2   1930  3.37
     3   1950  3.24
     4   1920  3.06
     5   1960  3.03
     6   1900  2.99
     7   1940  2.94
     8   1910  2.86
     9   1980  2.66
    10   2010  2.63
    11   1990  2.58
    12   2000  2.57
    13   1970  2.55

``` r
# which team had the most home goals relative to others?
# group_by() and mutate(): group-wise operations that keep the same number of rows

df |>
  select(season = Season, team = home, goals = hgoal) |>
  mutate(
    decade = floor(season / 10) * 10
  ) |>
  filter(decade > 1880, decade < 2020) |>
  group_by(decade, team) |>
  summarize(goals = mean(goals)) |>
  group_by(decade) |>
  mutate(goals = goals - mean(goals)) |>
  ungroup() |>
  arrange(-goals)
```

    `summarise()` has grouped output by 'decade'. You can override using the
    `.groups` argument.

    # A tibble: 1,092 × 3
       decade team              goals
        <dbl> <chr>             <dbl>
     1   2010 Manchester City   1.17 
     2   1920 Carlisle United   0.958
     3   1940 Rotherham United  0.940
     4   1890 Aston Villa       0.884
     5   1890 Birmingham City   0.859
     6   1890 Bootle            0.856
     7   2000 Arsenal           0.820
     8   2000 Manchester United 0.762
     9   1930 Everton           0.738
    10   2000 Chelsea           0.731
    # ℹ 1,082 more rows

## More complicated manipulation: loops (bad) vs. map functions (good)

``` r
ci <- function(v) {
  x_bar <- mean(v)
  s <- sd(v)
  n <- length(v)
  std_error <- s / sqrt(n)
  lower_bound_z <- x_bar + std_error * qnorm(p = 0.025, mean = 0, sd = 1)
  upper_bound_z <- x_bar + std_error * qnorm(p = 0.975, mean = 0, sd = 1)
  c(
    "lower.bound" = lower_bound_z,
    "upper.bound" = upper_bound_z
  )
}

df_decade
```

    # A tibble: 199,620 × 3
       season goals decade
        <dbl> <dbl>  <dbl>
     1   1890     2   1890
     2   1890     6   1890
     3   1890    13   1890
     4   1890     5   1890
     5   1890     3   1890
     6   1890     5   1890
     7   1890     0   1890
     8   1890     4   1890
     9   1890     5   1890
    10   1890     3   1890
    # ℹ 199,610 more rows

``` r
pl <- tibble(
  decade = numeric(),
  goals = numeric(),
  lower.bound = numeric(),
  upper.bound = numeric()
)

decades <- unique(df_decade$decade)

for (this_decade in decades) {
  this_data <- df_decade |>
    filter(decade == this_decade)
  this_ci <- ci(this_data$goals)
  this_pl <- tibble(
    decade = this_decade,
    goals = mean(this_data$goals),
    lower.bound = this_ci["lower.bound"],
    upper.bound = this_ci["upper.bound"]
  )
  pl <- bind_rows(pl, this_pl)
}

# let's add confidence intervals to our plot
```

``` r
# let's make the ultimate plot to answer the question: did soccer get less exciting over time?
```
