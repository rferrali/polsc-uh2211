#######################################
## Lecture 2: Object types, datasets ##
#######################################

## Git and GitHub -------------------------------

# commits

# reverting back to previous versions of your code:
# - hit the "Source Control" tab (looks like a branch)
# - below the green button, there's the Changes pane.
# - hover over it, and click the back arrow.

# syncing code from the repository to your local machine
# - you can only do this when your local code is "clean" (no changes)
# - at the bottom left of the window, near "main", hit the circular arrow button

## Object types -------------------------------

# numeric

a_number <- 42

# character

some_text <- "Hello, world!"
a_problem <- "42" # looks like a numeric, but is actually character

# logical

5 > 2 # TRUE
5 >= 2 # TRUE
2 + 2 == 5 # FALSE
2 + 2 != 5 # TRUE

# vectors: seq(), c(), rep()

c(2, 3, 5, 7, 11)
c(TRUE, 2, 5) # coercion: when surrounded by numerics, logicals become numerics (TRUE = 1, FALSE = 0)
c(TRUE, "Hello", 42) # coercion: when surrounded by characters, everything becomes character
seq(1, 10, by = 2) # create a sequence from 1 to 10, incrementing by 2
seq(1, 10, by = 1) # same as above, incrementing by 1
some_numbers <- seq(1, 10) # default argument (by = 1)
some_other_numbers <- rep(5, times = 10) # repeat the number 5, ten times
# ?rep # to see the documentation for the rep() function -> this one is quite easy to read

# combining vectors
c(some_numbers, some_other_numbers) # add some_other_numbers to the end of some_numbers
c(4, 5, rep(c(1, 2, 3), 3)) # combine all we have learned so far!

# vectorized operations

(some_numbers * 2) + 1 # multiply each element by 2, then add 1 to each element
some_numbers + some_other_numbers # add a vector to another vector, element by element
# so the first element of some_numbers gets added to the first element of some_other_numbers, etc.

# a useful example with logical comparisons
husbands <- c(31, 29, 42) # ages of 3 husbandss
wives <- c(28, 34, 26) # ages of 3 wivess
husbands > wives # which husbands is older than his corresponding wives?

# lists
# lists are the most flexible object type in R.
# They can contain any other R object, even other lists!

# let's use a list to store a person's information
me <- list(
  name = "Alice",
  age = 30,
  height = 165,
  hobbies = c("reading", "hiking", "coding"),
  # a list within a list, to store that person's belongings
  stuff = list(
    glasses = TRUE,
    shoes = c("sneakers", "boots")
  )
)
me # print the whole list
me$name # access the "name" element of the list
me$stuff$glasses # access the "glasses" element of the "stuff" sub-list

# we can use lists to store tabular data as well
# actually, data.frames (more on those later) are just special kinds of lists
my_data <- list(
  name = c("Alice", "Bob", "Charlie"),
  age = c(30, 25, 35),
  height = c(165, 180, 175)
)

# knowing the type of an object: class()

class(my_data)
class(some_numbers)

# an important, more elaborate object: data.frame

my_new_data <- data.frame(
  name = c("Alice", "Bob", "Charlie"),
  age = c(30, 25, 35),
  height = c(165, 180, 175)
)
my_new_data
class(my_new_data)
my_new_data$age # access the "age" column of the data frame -> this is a vector

## Datasets -------------------------------

# reading data

df <- read.csv("data/lecture-1-england.csv")

# exploring data: head(), summary(), table(), unique()

# df # print the whole data frame, don't do that! (it's just too long and will clutter your console)
head(df) # first 6 rows
head(df$Season) # head() also works on vectors: first 6 elements of the Season column (a vector)
# let's try and see how many teams are in this dataset
teams <- unique(c(df$home, df$visitor)) # combine home and visitor columns, then get unique team names
length(teams) # how many unique teams are there?

# accessing data: $, subsetting

# a little bit of magic: how many crazy games (with more than 15 total goals) were there?
nrow(df[df$totgoal > 15, ]) # just one
df[df$totgoal > 15, ] # let's look at it
