## Making a table in Word -- the finished follow-along script
## This is the completed version of the script built on the guide page.
## It runs from top to bottom without errors. Run the whole file with the
## Source icon, to the right of Run in the script toolbar.
## Run it a second time and jtable() asks before replacing each Word file
## it wrote: close the files in Word first, then answer y.


## ---- 1. Load jstats and save the two results again --------------------

## Load jstats and community, make community the default data frame, and
## save page 1's two results again: d1, descriptive statistics, and m1, a
## regression. quiet = TRUE skips jload()'s report, which page 1 shows;
## overwrite = TRUE replaces a copy loaded earlier without asking first
library(jstats)
jload("community", overwrite = TRUE, quiet = TRUE)
juse(community)
d1 <- jdesc(Age, Income, WellbeingScore, print = FALSE)
m1 <- jlm(WellbeingScore ~ Age + Income, print = FALSE)


## ---- 2. Choose a folder for your Word files ---------------------------

## Make Tables the output folder, where jtable() writes its Word files.
## jstats creates the folder right away (if it isn't already there)
joptions(output.dir = "Tables")


## ---- 3. A table in Word -----------------------------------------------

## Make a table from d1, save it as t1, and write it to a Word file.
## open = TRUE opens the file once it is written
t1 <- jtable(d1, file = "Descriptives.docx", open = TRUE)

## Optional: print() is base R, and shows the table in the Console as
## well, laid out as in Word. Leave the line out if you don't need it
print(t1)  # base R


## ---- 4. A second table, in a file of its own --------------------------

## Make a table from m1, save it as t2, and write it to a second Word file
t2 <- jtable(m1, file = "Regression.docx", open = TRUE)

## Optional, as in block 3: the table in the Console as well
print(t2)  # base R
