## Telling jstats about missing values -- the finished follow-along script
## This is the completed version of the script built on the guide page.
## It runs from top to bottom, repeatedly, without errors: the deliberate
## error line from block 3 is commented out below (with a note), and block
## 6 carries the answer to the page's closing exercise. Run the whole file
## with the Source icon, to the right of Run in the script toolbar.


## ---- 1. Load the data, and see what jstats already noticed ------------

## Start from a fresh copy of the clinic practice dataset
## You wouldn't normally write this pair: clinic is there by name as soon
## as jstats is loaded, and juse() usually comes once per session. The
## reload makes this page start clean whatever you did on another page
jload("clinic", overwrite = TRUE)
juse(clinic)

## MoodRating is meant to run from 1 to 10. Ask for its descriptives
jdesc(MoodRating)


## ---- 2. What a missing-value convention is ----------------------------

## jstats can keep missing-value codes in any of three forms, one for each
## major program. It will not choose one for you. We start with no
## convention chosen -- the package default -- so you see what happens
## (If you've chosen one on another page or in your Project's .Rprofile,
## this line clears it for the current session only; restarting R brings
## your .Rprofile choice back)
joptions(missing.convention = "none")


## ---- 3. Declare, and meet the gate ------------------------------------

## Declare -99 and -98 as missing on MoodRating, with labels
## With no convention chosen, jstats stops and asks instead of guessing
## On the page this line demonstrates that refusal -- disabled here so the
## file runs clean; block 4 makes the same call successfully
# clinic <- jdeclare_missing(clinic, MoodRating,  # an error, on purpose
#                            codes = c(Refused = -99, "Don't know" = -98))


## ---- 4. Choose, declare, check ----------------------------------------

## Choose the Stata-style convention -- the one jstats itself recommends
## for anyone who also runs base R
joptions(missing.convention = "stata")

## Now the same declaration goes through
clinic <- jdeclare_missing(clinic, MoodRating,
                           codes = c(Refused = -99, "Don't know" = -98))

## The mean sits inside 1-10 again, and the codes count as missing
jdesc(MoodRating)

## A frequency table shows the codes set aside, with their labels
jfreq(MoodRating)

## With nothing in the parentheses, joptions() shows your current
## settings, including this one
joptions()


## ---- 5. Bring the rest in line ----------------------------------------

## Stress arrived with its codes declared SPSS-style. Ask base R's mean()
## for its average, with and without na.rm = TRUE (which tells mean() to
## drop NAs). To base R the codes are ordinary numbers, so both go in
mean(clinic$Stress)  # base R -- the codes are averaged in
mean(clinic$Stress, na.rm = TRUE)  # na.rm has no NAs to drop yet

## One line converts every SPSS-style column in clinic to the Stata form
clinic <- jconvert(clinic, to = "stata")

## Now base R sees the missing values too: the mean is NA (loud, not wrong),
## and na.rm = TRUE gives the right answer
mean(clinic$Stress)
mean(clinic$Stress, na.rm = TRUE)


## ---- 6. Finding undeclared codes in your own data ---------------------

## jstats named MoodRating and Anxiety2 as clinic loaded. Data that arrive
## some other way come with no message, so learn the symptoms: screen the
## whole data frame...
jscreen()

## ...then look at the one column still carrying the problem
jfreq(Anxiety2)

## THE CLOSING EXERCISE -- the page asks you to declare Anxiety2 yourself.
## This finished file carries the answer: the call from block 4, with the
## column name changed. Run the frequency table again to see the codes move
## into the Missing section
clinic <- jdeclare_missing(clinic, Anxiety2,
                           codes = c(Refused = -99, "Don't know" = -98))
jfreq(Anxiety2)


## ---- 7. Make it permanent ---------------------------------------------

## The convention you chose is a session setting: it lasts until you
## restart R. This page leaves it switched on -- one last look
joptions()

## To have it chosen automatically at the start of every session in this
## Project, put the same joptions(missing.convention = "stata") line in
## your Project's .Rprofile file. The Loading jstats automatically page
## shows where that file lives and how to create it
