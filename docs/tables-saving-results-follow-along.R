## Saving results -- the finished follow-along script
## This is the completed version of the script built on the guide page.
## It runs from top to bottom without errors. Run the whole file with the
## Source icon, to the right of Run in the script toolbar.
## Run it a second time in the same session and jload() asks before
## replacing community: answer y. When the file m1.rds is already in
## your folder, jsave() asks before replacing it: answer y.


## ---- 1. Load jstats and the data --------------------------------------

## Load jstats for this session
library(jstats)

## Load the community practice dataset into your workspace, then make it
## the default data frame, so the commands below can leave its name out
jload("community")
juse(community)


## ---- 2. Save a result -------------------------------------------------

## Save jdesc()'s result for three variables in an object named d1.
## The output still appears in the Console, as it would without d1 <-
d1 <- jdesc(Age, Income, WellbeingScore)


## ---- 3. Save a second result without Console output -------------------

## Save a regression in an object named m1. print = FALSE keeps the
## output out of the Console, since the Word table is what we're after
m1 <- jlm(WellbeingScore ~ Age + Income, print = FALSE)


## ---- 4. Save a result in a file ---------------------------------------

## Save the result m1 in a file. jsave() names the file m1.rds
jsave(m1)

## Remove m1 from the Environment, as ending the session would.
## rm() is base R, and shows nothing in the Console when it works
rm(m1)  # base R


## ---- 5. Load the result from the file ---------------------------------

## Load the result saved in m1.rds. It comes back as an object named m1
jload("m1")
