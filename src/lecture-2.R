#######################################
## Lecture 2: Object types, datasets ##
#######################################

## Git and GitHub -------------------------------

# commits

# reverting back to previous versions of your code

# syncing code from the repository to your local machine

## Object types -------------------------------

# numeric

a_number <- 42


# character

some_text <- "Hello, world!"
a_problem <- "42"

# logical

5 > 2 # TRUE
5 >= 2 # TRUE
2 + 2 == 5 # FALSE
2 + 2 != 5 # TRUE

# vectors: seq(), c(), rep()

c(2, 3, 5, 7, 11)
c(TRUE, 2, 5)
c(TRUE, "Hello", 42) # coercion
seq(1, 10, by = 2)
seq(1, 10, by = 1) 
some_numbers <- seq(1, 10) # default argument (by = 1)
(some_numbers * 2) + 1
some_other_numbers <- rep(5, times = 10)

some_numbers + some_other_numbers
c(some_numbers, some_other_numbers)

c(4, 5, rep(c(1,2, 3), 3))

dad <- c(31, 29, 42)
mom <- c(28, 34, 26)
dad > mom

# matrices (coercion, rbind(), cbind())

# lists

me <- list(
    name = "Alice",
    age = 30,
    height = 165,
    hobbies = c("reading", "hiking", "coding"),
    stuff = list(
        glasses = TRUE,
        shoes = c("sneakers", "boots")
    )
)
me
me$name
me$stuff$glasses

my_data <- list(
    name = c("Alice", "Bob", "Charlie"),
    age = c(30, 25, 35),
    height = c(165, 180, 175)
)

# knowing the type of an object: class()

class(my_data)
class(some_numbers)

# an important, more elaborate object: data.frame

my_data <- data.frame(
    name = c("Alice", "Bob", "Charlie"),
    age = c(30, 25, 35),
    height = c(165, 180, 175)
)
my_data
class(my_data)
my_data$age

## Datasets -------------------------------

# reading data

df <- read.csv("data/lecture-1-england.csv")

# exploring data: head(), summary(), table(), unique()

df # print the whole data frame, ugh
head(df) # first 6 rows
head(df$Season)
df$season
teams <- unique(c(df$home, df$visitor))
length(teams)

# accessing data: $, subsetting

head(df)
nrow(df[df$totgoal > 15,])
df[df$totgoal > 15,]

# counting things: length(), nrow(), ncol(), dim()
