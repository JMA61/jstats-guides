## Choosing a style: apa or report -- the finished follow-along script
## This is the completed version of the script built on the guide page.
## It runs from top to bottom without errors. Run the whole file with the
## Source icon, to the right of Run in the script toolbar.
## Run it a second time and jtable() asks before replacing
## Report_report.docx: close the file in Word first, then answer y.


## ---- 1. Load jstats and the saved results -----------------------------

## Load jstats and community, make community the default data frame, and
## save page 1's two results again: d1, descriptive statistics, and m1, a
## regression. quiet = TRUE skips jload()'s report, which page 1 shows;
## overwrite = TRUE replaces a copy loaded earlier without asking first
library(jstats)
jload("community", overwrite = TRUE, quiet = TRUE)
juse(community)
d1 <- jdesc(Age, Income, WellbeingScore, print = FALSE)
m1 <- jlm(WellbeingScore ~ Age + Income, print = FALSE)


## ---- 2. One table in report -------------------------------------------

## Make d1's table in the built-in report style, and show it
t1 <- jtable(d1, style = "report")

## print() is base R: it shows an object in the Console, here the table
print(t1)  # base R


## ---- 3. Report for the whole session ----------------------------------

## Make report the style for the rest of the session
joptions(style = "report")

## Remake page 3's tables and chart, now in report, and write them to one
## Word file
t1 <- jtable(d1, print = FALSE)
t2 <- jtable(m1, print = FALSE)
p1 <- jplot(Region)
jtable(list(t1, p1, t2), file = "Report_report.docx", open = TRUE)


## ---- 4. Back to apa ---------------------------------------------------

## Make apa the session's style again
joptions(style = "apa")
