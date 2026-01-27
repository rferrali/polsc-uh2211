#####################################################
## Lecture 3: Plots, means and standard deviations ##
#####################################################

# Our guiding question today: did soccer get less exciting over time?

# Installing and loading packages -------------------

# ggplot2, tibble, readr

# Datasets, continued -------------------------------

# reading data

# an aside: overwriting objects: df and df

df <- read.csv("data/lecture-1-england.csv")

# exploring data: head(), summary(), table(), unique()

# df # print the whole data frame, don't do that! (it's just too long and will clutter your console)
head(df) # first 6 rows
head(df$Season) # head() also works on vectors: first 6 elements of the Season column (a vector)
# let's try and see how many teams are in this dataset
teams <- unique(c(df$home, df$visitor)) # combine home and visitor columns, then get unique team names
length(teams) # how many unique teams are there?

# counting things: length(), nrow(), ncol(), dim()

# did soccer get less exciting over time? ---------------

# translating our question into numbers: what does exciting mean?

# translating numbers into code

# accessing data: $, subsetting

# creating columns (and deleting and renaming)

# calculating means and standard deviations: mean(), sd()
