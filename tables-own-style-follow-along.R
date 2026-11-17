## Making your own style -- the finished follow-along script
## This is the completed version of the script built on the guide page.
## It runs from top to bottom without errors. Run the whole file with the
## Source icon, to the right of Run in the script toolbar.
## Run it again and jstyle() asks before replacing myreport.jstyle with a
## fresh copy of report: answer y, or n to keep the copy you have.


## ---- 1. Load jstats and the data --------------------------------------

## Load jstats and the community practice dataset, and make community the
## default data frame. quiet = TRUE skips jload()'s report on what it
## loaded; overwrite = TRUE replaces a copy already loaded in this session
## without asking first
library(jstats)
jload("community", overwrite = TRUE, quiet = TRUE)
juse(community)


## ---- 2. A style folder, and a copy in it ------------------------------

## Keep this page's styles in a Styles folder inside the project. jstats
## makes the folder; the setting lasts until R restarts
joptions(style.dir = "Styles")

## Save a complete copy of report as myreport.jstyle in the style folder
jstyle("report", save.as = "myreport")


## ---- 3. Where jstats looks --------------------------------------------

## The styles jstats can find, and the folders it looks in, in order
jstyle()


## ---- 4. A style found by its name -------------------------------------

## Save a result, then make a table from it in myreport, which jstats
## finds in the style folder
d1 <- jdesc(Age, Income, WellbeingScore, print = FALSE)
t1 <- jtable(d1, style = "myreport")
