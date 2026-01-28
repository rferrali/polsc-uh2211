#####################################################
## Lecture 3: Plots, means and standard deviations ##
#####################################################

# Our guiding question today: did soccer get less exciting over time?

# Installing and loading packages -------------------

# 1. install packages
# install.packages("ggplot2")
# install.packages(c("readr", "tibble"))
# 1.1. notice that we put the pacakge name in "", because we don't have it yet
# we're telling R to look for it on CRAN (the package repository)
# we only need to do this once per package. once we have it, it's
# installed on the computer, and we can use it again even if we close R
# 1.2. because you won't type this line again, I put it in a comment
# typically, you install packages directly in the console, so it doesn't
# dirty up your script

# load packages
# ggplot2 is a package for making plots
library(ggplot2)
# tibble is a package that improves on the base R data frame
# (it prints better in the console, among other things)
library(tibble)
# readr is a package for reading data; it improves on base R functions
library(readr)

# Datasets, continued -------------------------------

# reading data

# the old read.csv() function from base R:
# a. doesn't give much information when reading in data
# b. gives us a data.frame
# c. isn't very smart at guessing column types
df <- read.csv("data/lecture-1-england.csv")
df # see how a data.frame looks in the console: not very pretty
df <- as_tibble(df) # convert to tibble
df # see how a tibble looks in the console: much better!

# the new read_csv() function from readr:
# a. gives us information about the data when reading it in
# b. gives us a tibble right away
# c. is smarter at guessing column types
# (see how the Date column was automatically read as a date rather than as text)
df <- read_csv("data/lecture-1-england.csv")

# exploring data: head(), summary(), table(), unique()

# combine these two columns into one vector
# so we can get all teams that played in the league
all_teams <- c(df$home, df$visitor)

# unique() gives us the unique values in a vector
# this way, we can have just the names of each team once
# (we dropped duplicates)
teams <- unique(all_teams)

# table() gives us a frequency table: we know how many times each team played
table(all_teams)

# summary() gives summaries of things. its output depends on what you feed it
# for a vector of text, it doesn't say much
summary(all_teams)
# for a numeric vector, it gives us useful statistics
summary(df$totgoal)
# for a data.frame or tibble, it gives us summaries of each column
summary(df)

# counting things: length(), nrow(), ncol(), dim()

# length() gives us the length of a vector
length(teams) # how many teams are there?
# but for 2D objects (like a data.frame), length() isn't very useful
length(df) # gives us the number of columns, not very intuitive
# for 2D objects, use nrow() and ncol()
nrow(df) # number of rows
ncol(df) # number of columns
dim(df) # both at once: rows (first) and columns (second)

# did soccer get less exciting over time? ---------------

# translating our question into numbers: what does boring mean?
# - fewer goals scored per game -> mean number of goals scored per game goes down
# - games that all look the same -> smaller standard deviation in number of goals scored
# -> we're going to calculate the mean and standard deviation of total goals
# over an early decade an a late decade

# translating numbers into code

# which decades to compare?
summary(df$Season) # the data ranges from 1888 to 2021
# we could have gotten this with
min(df$Season)
max(df$Season)
# -> so we'll compare the first full decade (1890s) to the most recent full decade (2010s)
# to do so, we need to get all games from those decades
# i.e., we need to access subsets of the data

# First thing: let's create a new column in the data frame
# that indicates the decade of each season
# e.g., 1890 for seasons 1890-1899, 1900 for seasons 1900-1909, etc.
# we'll take the season year, divide by 10, round down to the nearest integer
# and multiply by 10 again
# let's test on a small example first

years <- c(1890, 1895, 1903, 2017)
decades <- floor(years / 10) * 10
decades # looks good!
# let's do this on the full data frame now
# we create a new column by using the $ operator
df$decade <- floor(df$Season / 10) * 10
# notice that we can also replace existing columns this way
df$decade <- df$decade + 1 # adds 1 to each decade value
# (that's bad, because we broke our decades, so lets fix it)
df$decade <- floor(df$Season / 10) * 10 # put it back

# A long aside: subsetting
# to access parts of an object, we use square brackets: []
# let's start with vectors
letters # built-in vector of all the letters in the alphabet
letters[2] # access the 2nd element -> b
letters[c(2, 5, 10)] # access the 2nd, 5th and 10th letter (using a vector)
letters[2:5] # access letters 2 to 5 (using a range)
# aside: 2:5 is shorthand for seq(2, 5)
2:5
# we can also use logical vectors to access elements
years <- c(1888, 1945, 2015)
# let's get the first and third year only
condition <- c(TRUE, FALSE, TRUE)
years[condition]
years[c(TRUE, FALSE, TRUE)] # more compactly
# that's boring, because we had to create the logical vector ourselves
# typically, we create it by applying a condition
condition <- years < 1900 # which years are before 1900?
years[condition]
years[years < 1900] # more compactly

# now, let's do this for data frames (and tibbles)
# data frames are 2D, so we need to specify rows and columns
# the format is: df[rows, columns]; if you leave one blank, it means "all"
df[1, ] # first row, all columns
df[1:5, ] # first 5 rows, all columns
df[, 1] # all rows, first column
df[, c(1, 3, 5)] # all rows, columns 1, 3 and 5

# you can also use column names instead of numbers
df[, "Season"] # all rows, "Season" column
# notice that we don't have a vector, but a tibble with one column
# to get a vector, we can use the $ operator instead
df$Season # all rows, "Season" column as a vector

# let's eyeball our new decade column to make sure it looks right
df[, c("Season", "decade")] # all rows, "Season" and "decade" columns

# now, let's get all rows where the decade is 1890
condition <- df$decade == 1890
df[condition, ]

# let's create our new datasets for the two decades we want to compare
df_old <- df[df$decade == 1890, ]
df_new <- df[df$decade == 2010, ]
# actually, there's a bunch of columns we don't need for this analysis, so
# let's only get the columns we need
df_old <- df[df$decade == 1890, c("Season", "decade", "totgoal")]
df_new <- df[df$decade == 2010, c("Season", "decade", "totgoal")]

# alternative ways of using logical conditions: we didn't really need to create
# the decade column. we could have created a logical condition directly
# that checks whether the season is in the 1890s or the 2010s
# the & operator means "and"
condition_old <- df$Season >= 1890 & df$Season < 1900
condition_new <- df$Season >= 2010 & df$Season < 2020

# together: let's get all rows that are either in the 1890s or the 2010s
# the | operator means "or"
# parentheses set priorities
condition <- (df$Season >= 1890 & df$Season < 1900) |
  (df$Season >= 2010 & df$Season < 2020)

# now, let's calculate means and standard deviations of total goals
# the summary function gives us some of this information already
summary(df_old$totgoal)
summary(df_new$totgoal)

# but there are built-in functions to get exactly what we want
# mean() and sd()
mean(df_old$totgoal)
mean(df_new$totgoal)

sd(df_old$totgoal)
sd(df_new$totgoal)

# this is a bit hard to read
# so let's create a new tibble to summarize our results
tibble(
  decade = c(1890, 2010),
  mean = c(
    mean(df_old$totgoal),
    mean(df_new$totgoal)
  ),
  sd = c(
    sd(df_old$totgoal),
    sd(df_new$totgoal)
  )
)

# conclusion: yes, soccer got less exciting over time
# fewer goals per game (mean went down from 3.61 to 2.63)
# and games look more similar (sd went down from 2.63 to 1.62)
