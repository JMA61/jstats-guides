## Changing a style by hand -- the finished follow-along script
## This is the completed version of the script built on the guide page.
## It runs from top to bottom without errors. Run the whole file with the
## Source icon, to the right of Run in the script toolbar.
## Block 4 is only comments: the change happens in the editor, not in R.
## Run it again and jstats asks before replacing a file it wrote earlier:
## answer n for mystyle.jstyle, to keep your changes, and y for the Word
## file (close it in Word first).


## ---- 1. Load jstats and the data --------------------------------------

## Load jstats and the community practice dataset, and make community the
## default data frame. quiet = TRUE skips jload()'s report on what it
## loaded; overwrite = TRUE replaces a copy already loaded in this session
## without asking first
library(jstats)
jload("community", overwrite = TRUE, quiet = TRUE)
juse(community)


## ---- 2. A table in the report style -----------------------------------

## Save a result, then make a table from it in the built-in report style
d1 <- jdesc(Age, Income, WellbeingScore, print = FALSE)
t1 <- jtable(d1, style = "report")

## print() is base R: it shows an object in the Console, here the table
print(t1)  # base R


## ---- 3. A copy of report to change ------------------------------------

## Keep this page's styles in a styles folder inside the project. jstats
## makes the folder; the setting lasts until R restarts
joptions(style.dir = "styles")

## Save a complete copy of report as mystyle, every setting written out
## with a note. open = TRUE opens the copy in a tab beside your script
jstyle("report", save.as = "mystyle", open = TRUE)


## ---- 4. Change two values, and save -----------------------------------

## In the mystyle.jstyle tab: font = Times New Roman, decimals = 1, saved


## ---- 5. Check the file ------------------------------------------------

## jstyle() reads the saved file and shows every setting. It stops at a
## line it cannot use, and names the line
jstyle("mystyle")


## ---- 6. The table in your style ---------------------------------------

## Make a table from the same result in your style, and write it to a
## Word file
t2 <- jtable(d1, style = "mystyle", file = "Table1_mystyle.docx", open = TRUE)
print(t2)  # base R
