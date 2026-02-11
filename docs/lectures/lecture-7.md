# Lecture 7: linear regression
Romain Ferrali

Today, we’re going to talk about linear regression, which is a
statistical method for modeling the relationship between a dependent
variable and one or more independent variables. It’s a powerful tool for
understanding how different factors affect an outcome, and it’s widely
used in many fields, including economics, psychology, and of course,
sports analytics. Linear regression builds upon the concepts we have
seen (p-value, confidence interval), and subsumes some of the tests we
have seen; specifically, the t-test.

Our goal: have a simpler answer to our question: did soccer get less
exciting over time?

``` r
library(tidyverse)
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

``` r
# some housekeeping: let's turn all the column names into lowercase
colnames(df) <- tolower(colnames(df))
```

## Linear regression: the basics

Linear regression models the relationship between a dependent variable
(y) and one or more independent variables (x) by fitting a linear
equation to the observed data. The simplest form of linear regression
has only one independent variable. In other words, you want to
**estimate** the **parameters** $\alpha$ and $\beta$ in the equation:

$$
y_i = \underbrace{\alpha}_{\text{intercept}} + \underbrace{\beta}_{\text{slope}} x_i + \epsilon_i, 
$$

where

- each $i$ is an **observation** in your data (i.e., a row in your data
  frame),
- $x_i$ is the **independent variable** (you can also call it the
  **predictor**. You can have more than one independent variable, but
  we’ll stick to one for now),
- $y_i$ is the **dependent variable** (the outcome you’re trying to
  predict). It’s called “dependent” because its value *depends* on the
  value of $x_i$.
- $\alpha$, $\beta$ are the **parameters** of the model that we want to
  estimate. Parameter $\alpha$ is called the **intercept**; it
  represents the expected value of $y$ when $x$ is zero. Parameter
  $\beta$ is called the **slope**; it represents the change in $y$ for a
  one-unit change in $x$.
- $\epsilon_i$ is the **error term** that captures the variability in
  $y$ that is not explained by $x$

How do we obtain the **best** fit line? By minimizing the sum of squared
errors; i.e., minimizing the distance between the observed values and
the line. What is the distance between the observed values and the line?
You can think of that distance as the **error** you make between your
**prediction** and the observed data.

$$
\underbrace{y_i}_{\text{observation}} - \underbrace{(\alpha + \beta x_i)}_{\text{prediction}} = \epsilon_i
$$

Because we don’t care about whether our error is positive or negative,
we square it to get rid of the negative signs. So we want to pick
$\alpha$ and $\beta$ that minimize:

$$
\min_{\alpha, \beta} \sum_i (y_i - (\alpha + \beta x_i))^2 = \sum_i \epsilon_i^2
$$

So really, we minimize the sum of squared errors. This is called the
**least squares** method, and it gives us the best fit line. This is why
you sometimes call linear regression “Ordinary Least Squares
regression”, or OLS.

Notice that we can still leverage the Central Limit Theorem to make
inferences about our parameters $\alpha$ and $\beta$. So we can get
p-values and confidence intervals. Let’s put this in practice:

We can also fairly easily visualize this relationship by plotting the
data and the fitted line.

## Where does that best fit line come from?

**When the independent variable ($x_i$) is binary, the best fit is
really the average.** It is quite intuitive: if you want to predict a
quantity, your best bet is to set the prediction is its average value
and attribute everything else to noise. Let’s see this in practice,
looking at home and away games:

When the independent variable is continuous, the best fit line is a bit
more complicated. It is given by the following formulas: $$
\hat{\beta} = \frac{\text{cov}(x, y)}{\sigma_x^2}
$$

## Linear regression with multiple independent variables

We can also have more than one independent variable. In that case, the
model looks like this: $$
y_i = \alpha + \beta_1 x_{1i} + \beta_2 x_{2i} + \ldots + \epsilon_i
$$

``` r
# predictions
```

## What if my data is not linear? A word

## A word on correlation vs. causation

``` r
# data cleaning
gss <- read_csv("./data/lecture-7-gss.csv") |>
  mutate(
    female = case_match(
      sex,
      "FEMALE" ~ 1,
      "MALE" ~ 0,
      .default = NA
    ),
    height = ifelse(rheight < 0, 0, rheight),
    height = height * 2.54,
    income = case_match(
      rincome,
      "$25000 OR MORE" ~ 25000,
      "$20000 - 24999" ~ 22500,
      "$15000 - 19999" ~ 17500,
      "$10000 - 14999" ~ 12500,
      "$8000 TO 9999" ~ 9000,
      "$7000 TO 7999" ~ 7500,
      "$6000 TO 6999" ~ 6500,
      "$5000 TO 5999" ~ 5500,
      "$4000 TO 4999" ~ 4500,
      "$3000 TO 3999" ~ 3500,
      "$1000 TO 2999" ~ 2000,
      "LT $1000" ~ 1000,
      .default = NA
    )
  ) |>
  select(female, height, income) |>
  na.omit()
```

    Rows: 3544 Columns: 6
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr (3): sex, rincome, ballot
    dbl (3): year, id_, rheight

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
