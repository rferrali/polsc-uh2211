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

# first, let's create a data frame that has just the columns we need,
# including the decade variable
# (since we'll be using it a lot, it makes sense to create it once and for all)
df_decade <- df |>
  select(season = Season, team = home, home_goals = hgoal, goals = totgoal) |>
  mutate(
    decade = floor(season / 10) * 10
  ) |>
  filter(decade > 1880, decade < 2020)

# now, let's get the average number of goals per game for each decade,
# and sort them in descending order
df_decade |>
  group_by(decade) |>
  summarize(goals = mean(goals)) |>
  # arrange() sorts the data frame by the specified variable;
  # by default, it sorts in ascending order,
  # but if you put a minus sign in front of the variable,
  # it sorts in descending order
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

df_decade |>
  group_by(decade, team) |>
  # get the average number of home goals for each team in each decade
  summarize(goals = mean(home_goals)) |>
  # then, remove the average number of home goals for each decade
  # to get the relative number of home goals
  group_by(decade) |>
  mutate(goals = goals - mean(goals)) |>
  # finally, remove the grouping structure and sort by goals in descending order
  # to view the teams with the most home goals relative to others
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

Now, we will be creating a plot with confidence intervals, which
requires a bit more complicated manipulation.

``` r
# this is the confidence interval function we created in lecture 5
# input: a vector of values (v)
# output: the lower and upper bounds of the confidence interval around mean(v)
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
```

Conceptually, to create this plot, we need a data frame that has the
following columns: - `decade`: the decade - `goals`: the average number
of goals per game in that decade - `lower.bound`: the lower bound of the
confidence interval around the average number of goals per game in that
decade - `upper.bound`: the upper bound of the confidence interval
around the average number of goals per game in that decade

Conceptually again, we want to:

1.  split the data by decade
2.  for each decade, get the average number of goals per game and the
    confidence interval around it
3.  combine the results into a single data frame

There are two main ways to do this: using loops, or using map functions.
The former is more traditional but, as you will see, more error-prone
and more complicated. Let’s see both approaches.

### Loops

A loop is a programming construct that allows you to repeat a block of
code multiple times. Here, we will be repeating the same block of code
for each decade. Before we start, we will Create an empty data frame to
store the results (let’s call this the stack). Our block will:

1.  Get the relevant data for that decade
2.  Calculate the output that we need (so, a data frame with one row and
    the columns `decade`, `goals`, `lower.bound`, and `upper.bound`)
3.  Add our output to the stack

``` r
# 0. create our stack; it's currently empty
# our loop will add rows to it
stack <- tibble(
  decade = numeric(),
  goals = numeric(),
  lower.bound = numeric(),
  upper.bound = numeric()
)

# let's get all the decades in our data, to repeat our block for each decade
decades <- unique(df_decade$decade)

# that's our loop: for each decade, we what's in the { ... } block
# each time our block runs, the value of this_decade changes to the next decade in our data,
# starting from the first element of the decades vector
for (this_decade in decades) {
  # 1. get the relevant data for that decade
  this_data <- df_decade |>
    filter(decade == this_decade)
  # 2. calculate the output that we need
  this_ci <- ci(this_data$goals) # get the confidence interval for that decade
  # create our 1-row data frame with the output we need
  this_output <- tibble(
    decade = this_decade, # column indicating the current decade
    goals = mean(this_data$goals), # mean number of goals per game in that decade
    lower.bound = this_ci["lower.bound"], # confidence interval
    upper.bound = this_ci["upper.bound"]
  )
  # 3. add our output to the stack
  stack <- bind_rows(stack, this_output)
}

# our stack now has the output we need for our plot
stack
```

    # A tibble: 13 × 4
       decade goals lower.bound upper.bound
        <dbl> <dbl>       <dbl>       <dbl>
     1   1890  3.61        3.54        3.67
     2   1900  2.99        2.95        3.03
     3   1910  2.86        2.81        2.91
     4   1920  3.06        3.03        3.09
     5   1930  3.37        3.34        3.40
     6   1940  2.94        2.90        2.98
     7   1950  3.24        3.22        3.27
     8   1960  3.03        3.01        3.06
     9   1970  2.55        2.53        2.57
    10   1980  2.66        2.64        2.69
    11   1990  2.58        2.56        2.61
    12   2000  2.57        2.55        2.59
    13   2010  2.63        2.61        2.65

### Map functions

Map functions use another approach: they apply a function to each
element of a list (or vector) and return a list (or vector) of the same
length. So, instead of creating an empty data frame and adding rows to
it, we can create a function that takes a decade as input and returns
the output we need for that decade, and then use a map function to apply
that function to each decade in our data. This is much cleaner and less
error-prone than using loops.

#### A step-by-step example to map functions

``` r
# Let's do this step by step, to see how it works.
# At first, we will just replicate exactly what we did in the loop, but without the loop.

# let's create a function that takes a decade as input and returns the output we need for that decade
get_decade_info <- function(decade) {
  # get the relevant data for that decade
  df <- df_decade |>
    filter(decade == decade)
  # get the confidence interval for that decade
  this_ci <- ci(df$goals)
  # create our 1-row data frame with the output we need
  tibble(
    decade = unique(df$decade),
    goals = mean(df$goals),
    lower.bound = this_ci["lower.bound"],
    upper.bound = this_ci["upper.bound"]
  )
}

# let's check that this function works for one decade
get_decade_info(1890)
```

    # A tibble: 13 × 4
       decade goals lower.bound upper.bound
        <dbl> <dbl>       <dbl>       <dbl>
     1   1890  2.87        2.86        2.88
     2   1900  2.87        2.86        2.88
     3   1910  2.87        2.86        2.88
     4   1920  2.87        2.86        2.88
     5   1930  2.87        2.86        2.88
     6   1940  2.87        2.86        2.88
     7   1950  2.87        2.86        2.88
     8   1960  2.87        2.86        2.88
     9   1970  2.87        2.86        2.88
    10   1980  2.87        2.86        2.88
    11   1990  2.87        2.86        2.88
    12   2000  2.87        2.86        2.88
    13   2010  2.87        2.86        2.88

``` r
# now, we can use a map function to apply this function to each decade in our data
# first, we need to get the unique decades in our data, to use as input for our map function
decades <- unique(df_decade$decade)
# now, we can use map() to apply our function to each decade and combine the results into a single data frame
pl <- map(decades, get_decade_info)
# map() returns a list of data frames, so we need to combine them into a single data frame
pl <- bind_rows(pl)
pl
```

    # A tibble: 169 × 4
       decade goals lower.bound upper.bound
        <dbl> <dbl>       <dbl>       <dbl>
     1   1890  2.87        2.86        2.88
     2   1900  2.87        2.86        2.88
     3   1910  2.87        2.86        2.88
     4   1920  2.87        2.86        2.88
     5   1930  2.87        2.86        2.88
     6   1940  2.87        2.86        2.88
     7   1950  2.87        2.86        2.88
     8   1960  2.87        2.86        2.88
     9   1970  2.87        2.86        2.88
    10   1980  2.87        2.86        2.88
    # ℹ 159 more rows

#### A realistic use of map functions

Now, let’s do this more efficiently:

1.  since we’ll be using our `get_decade_info()` function only once, we
    can just define it inside the map() function, without giving it a
    name
2.  instead of using `unique()` to get the decades and have the function
    fetch the data from `df_decade`, we can just directly split our data
    by decade and feed that split data to our function

``` r
pl <- df_decade |>
  group_by(decade) |>
  # this splits the data frame into a list of data frames,
  # one for each group (i.e., decade)
  group_split() |>
  # map_dfr() works like map(), but expects the mapped function
  # to return a data frame, and it automatically applies bind_rows()
  # to combine the results into a single data frame
  map_dfr(function(df) {
    this_ci <- ci(df$goals)
    tibble(
      decade = unique(df$decade),
      goals = mean(df$goals),
      lower.bound = this_ci["lower.bound"],
      upper.bound = this_ci["upper.bound"]
    )
  })
```

We’ve seen `map` and `map_dfr`, a variant of `map`. But there’s a bunch
of other `map` functions.

- They allow you to specify the type of output you want and combine it
  in a way that makes sense. (`map` -\> `list`; `map_chr` -\> a
  character vector: your function must return a single character;
  `map_dbl` -\> a numeric vector: your function must return a single
  number; `map_lgl` -\> a logical vector: your function must return a
  single TRUE/FALSE value, etc.)
- They allow you to specify how many arguments your function takes.
  `map` assumes your function takes one argument, but there are variants
  like `map2` and `pmap` that allow you to specify functions with two
  (`map2`) or more arguments (`pmap`).

## The plot

Soccer got significantly less exciting over time: the confidence
intervals around the average number of goals per game in each decade do
not overlap, and they show a clear downward trend.

``` r
# let's make the ultimate plot to answer the question: did soccer get less exciting over time?

ggplot(pl, aes(x = decade, y = goals, ymin = lower.bound, ymax = upper.bound)) +
  geom_line() +
  geom_point() +
  geom_ribbon(alpha = .5) +
  labs(
    x = "Decade",
    y = "Average number of goals per game",
    title = "Did soccer get less exciting over time?"
  )
```

![](lecture-6_files/figure-commonmark/data%20visualization%202-1.png)
