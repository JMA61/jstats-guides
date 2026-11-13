## Saving results -- the finished follow-along script
## This is the completed version of the script built on the guide page.
## It runs from top to bottom without errors. Run the whole file with the
## Source icon, to the right of Run in the script toolbar.
## Run it a second time in the same session and jload() asks before
## replacing community: answer y.


## ---- 1. Load jstats and the data --------------------------------------

## Load jstats for this session
library(jstats)

## Load the community practice dataset into your workspace, then make it
## the default data frame, so the commands below can leave its name out
jload("community")
juse(community)


## ---- 2. Save a result -------------------------------------------------

## Save jdesc()'s result for three variables in an object named d1.
## It prints as well, as it would without d1 <-
d1 <- jdesc(Age, Income, WellbeingScore)


## ---- 3. Save a second result, without printing ------------------------

## Save a regression in an object named m1. print = FALSE: nothing is
## printed, since a table is what we're after
m1 <- jlm(WellbeingScore ~ Age + Income, print = FALSE)
