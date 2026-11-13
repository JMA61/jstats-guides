## Several tables and a chart in one file -- the finished follow-along
## script. This is the completed version of the script built on the guide
## page. It runs from top to bottom without errors. Run the whole file
## with the Source icon, to the right of Run in the script toolbar.
## Run it a second time and jtable() asks before replacing Report.docx:
## close the file in Word first, then answer y.


## ---- 1. Load jstats, the saved results, and their tables --------------

## Load jstats and community, make community the default data frame, save
## page 1's two results again, and make their tables, t1 and t2.
## quiet = TRUE skips jload()'s report, which page 1 shows; overwrite = TRUE
## replaces a copy loaded earlier without asking first. print = FALSE keeps
## jtable() quiet; with no file, nothing is written to Word yet
library(jstats)
jload("community", overwrite = TRUE, quiet = TRUE)
juse(community)
d1 <- jdesc(Age, Income, WellbeingScore, print = FALSE)
m1 <- jlm(WellbeingScore ~ Age + Income, print = FALSE)
t1 <- jtable(d1, print = FALSE)
t2 <- jtable(m1, print = FALSE)


## ---- 2. A chart -------------------------------------------------------

## A bar chart of Region, saved as p1. It appears in the Plots tab
## (lower-right pane)
p1 <- jplot(Region)


## ---- 3. Tables and a chart in one file --------------------------------

## list() is base R: it puts the two tables and the chart together, in
## this order, and jtable() writes them all to one Word file
jtable(list(t1, p1, t2), file = "Report.docx", open = TRUE)
