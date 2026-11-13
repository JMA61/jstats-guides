## Several results in one table -- the finished follow-along script.
## This is the completed version of the script built on the guide
## page. It runs from top to bottom without errors. Run the whole file
## with the Source icon, to the right of Run in the script toolbar.
## Run it a second time and jtable() asks before replacing Models.docx:
## close the file in Word first, then answer y.


## ---- 1. Load jstats and the saved regression --------------------------

## Load jstats and community, make community the default data frame, and
## save page 1's regression again as m1. quiet = TRUE skips jload()'s
## report, which page 1 shows; overwrite = TRUE replaces a copy loaded
## earlier without asking first
library(jstats)
jload("community", overwrite = TRUE, quiet = TRUE)
juse(community)
m1 <- jlm(WellbeingScore ~ Age + Income, print = FALSE)


## ---- 2. A second model ------------------------------------------------

## The first model's predictors, and daily commute time
m2 <- jlm(WellbeingScore ~ Age + Income + CommuteTime, print = FALSE)


## ---- 3. Two models in one table ---------------------------------------

## list() is base R: it puts the two models together, each under the name
## that will head its columns. jtable() sets them side by side in one
## table, and writes it to a Word file
t3 <- jtable(list("Age and income" = m1, "Adding commute time" = m2),
             file = "Models.docx", open = TRUE)

## Optional: the table in the Console as well
print(t3)  # base R
