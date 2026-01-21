##################################
## Lecture 1: Introduction to R ##
##################################

## Preliminaries: the console and script files ---------------

# To open up the console (aka, the terminal):
# terminal > arrow near the + sign > R Terminal

# Scripts are better: they allow you to save your code, but really,
# they are just text files with .R extension. Their content is
# then just passed on to the R console to be executed.

# useful shortcuts:
# Ctrl (on mac: Cmd) + Enter : run current line/selection
# Ctrl (on mac: Cmd) + / : comment/uncomment current line/selection
# Ctrl (on mac: Cmd) + I : open up the AI assistant


## R as a calculator -----------------------------------------

1 + 1 # some comment here
2 + 2
3 + 3
4 + 4

## Creating, overwriting and deleting objects ----------------

number_42 <- 42
other_number <- 7
other_number # display an object

number_42 / other_number # do stuff with objects

other_number <- 14 # overwrite an object (was 7, is now 14)
other_number

# you can check the objects you have by clicking on the R icon 
# (leftmost bar)

rm(other_number) # delete an object (not very useful, but why not)

## Help and documentation -------------------------------------

# What is this rm() thing we just did?
# Let's check the help by typing ?rm
# ?rm -> not run: you typically run this in the console rather
# than in a script (you check the help, then forget about it)

## A little bit of cool: a function with AI ------------------

# a function that converts kg to pounds
convert <- function(quantity, to) {
    if (to == "kg") {
    quantity * 2.20462
    } else if (to == "pounds") {
    quantity / 2.20462
    }
}

# now, test the function

convert(10, to = "pounds") # 10 kg to pounds
convert(10, to = "kg")     # 10 pounds to kg
new_quantity <- convert(50, to = "pounds") # save the result in an object ;-)
