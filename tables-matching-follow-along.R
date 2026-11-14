## Matching the look of a published table -- the finished follow-along
## script. This is the completed version of the script built on the guide
## page. It runs from top to bottom without errors. Run the whole file
## with the Source icon, to the right of Run in the script toolbar.
## Block 3 is only comments: that step happens in your AI assistant.
## Run it again and jstats asks before replacing a file it wrote earlier:
## answer n for mymatch.jstyle, to keep the changes your assistant made,
## and y for the Word file (close it in Word first).


## ---- 1. Load jstats and the data --------------------------------------

## Load jstats and the community practice dataset, and make community the
## default data frame. quiet = TRUE skips jload()'s report on what it
## loaded; overwrite = TRUE replaces a copy already loaded in this session
## without asking first
library(jstats)
jload("community", overwrite = TRUE, quiet = TRUE)
juse(community)


## ---- 2. A copy of report, and a copy to upload ------------------------

## Keep this page's styles in a styles folder inside the project
joptions(style.dir = "styles")

## Save a complete copy of report as mymatch, every setting written out
## with a note
jstyle("report", save.as = "mymatch")

## file.copy() is base R: it copies a file. The copy, ending in .txt, is
## the one to upload
file.copy("styles/mymatch.jstyle", "mymatch.txt", overwrite = TRUE)  # base R


## ---- 3. Ask your assistant (outside R) --------------------------------

## Upload mymatch.txt and the example with the request on the guide page,
## and save the file that comes back as mymatch.jstyle in the styles
## folder, replacing the copy there


## ---- 4. Check what came back ------------------------------------------

## jstyle() reads the file and shows every setting. It stops at a line it
## cannot use, and names the line
jstyle("mymatch")


## ---- 5. One table of each kind, in one file ---------------------------

## Save a result of each kind named in the request
d1 <- jdesc(Age, Income, WellbeingScore, print = FALSE)
m1 <- jlm(WellbeingScore ~ Age + Income, print = FALSE)
x1 <- jcrosstab(Volunteer ~ Region, print = FALSE)

## Make a table from each result in mymatch. list() is base R: it puts
## the three tables together, and jtable() writes them to one Word file
t1 <- jtable(d1, style = "mymatch")
t2 <- jtable(m1, style = "mymatch")
t3 <- jtable(x1, style = "mymatch")
jtable(list(t1, t2, t3), file = "Tables_mymatch.docx", open = TRUE)
