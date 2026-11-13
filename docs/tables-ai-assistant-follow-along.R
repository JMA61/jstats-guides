## Changing a style with an AI assistant -- the finished follow-along
## script. This is the completed version of the script built on the guide
## page. It runs from top to bottom without errors: the deliberate error
## line from block 8 is commented out below (with a note). Run the whole
## file with the Source icon, to the right of Run in the script toolbar.
## Block 5 is only comments: that step happens in your AI assistant.
## Run it again and jstats asks before replacing a file it wrote earlier:
## answer y for the two Word files (close them in Word first), and n for
## myblue.jstyle, to keep the changes your assistant made.


## ---- 1. Load jstats and the data --------------------------------------

## Load jstats and the community practice dataset, and make community the
## default data frame. quiet = TRUE skips jload()'s report on what it
## loaded; overwrite = TRUE replaces a copy already loaded in this session
## without asking first
library(jstats)
jload("community", overwrite = TRUE, quiet = TRUE)
juse(community)


## ---- 2. Make a table in the report style ------------------------------

## Keep a result, then make its table in the built-in report style and write
## it to a Word file. open = TRUE opens the file once it is written
d1 <- jdesc(Age, Income, WellbeingScore, print = FALSE)
t1 <- jtable(d1, style = "report", file = "Table1_report.docx", open = TRUE)

## print() is base R: it shows an object in the Console, here the table
print(t1)  # base R


## ---- 3. A folder for your styles, and a copy of report ----------------

## Keep this page's styles in a styles folder inside the project. jstats
## makes the folder; the setting lasts until R restarts
joptions(style.dir = "styles")

## A complete copy of report, every setting written out with a note.
## Run this line once: run again, it asks before replacing myblue.jstyle,
## and n (no) keeps the changes your assistant made
jstyle("report", save.as = "myblue", open = TRUE)


## ---- 4. A copy to upload ----------------------------------------------

## file.copy() is base R: it copies a file. overwrite = TRUE replaces an
## older copy, so run this line again before each upload
file.copy("styles/myblue.jstyle", "myblue.txt", overwrite = TRUE)  # base R


## ---- 5. Ask your assistant (outside R) --------------------------------

## Upload myblue.txt with the request on the guide page, and save the file
## that comes back as myblue.jstyle in the styles folder, replacing the
## copy there


## ---- 6. Check what came back ------------------------------------------

## jstyle() reads the file and prints every setting. It stops at a line it
## cannot use, and names the line
jstyle("myblue")


## ---- 7. The table in your style ---------------------------------------

## The same result in the new style, to a second Word file
t2 <- jtable(d1, style = "myblue", file = "Table1_myblue.docx", open = TRUE)


## ---- 8. If the file comes back as .txt --------------------------------

## Make a style file that ends in .txt, from the upload copy
file.copy("myblue.txt", "styles/mytest.txt", overwrite = TRUE)

## jstats reads a style only from a file ending in .jstyle, so this stops
## (on purpose) and gives the line that renames the file
## On the page this line demonstrates that stop -- disabled here so the
## file runs clean; block 9 renames the file
# jstyle("mytest")  # an error, on purpose


## ---- 9. Rename it -----------------------------------------------------

## file.rename() is base R. The line jstyle() printed does the same, with
## the full paths
file.rename("styles/mytest.txt", "styles/mytest.jstyle")  # base R

## The style is found now: jtable() builds the table in it
t3 <- jtable(d1, style = "mytest")
