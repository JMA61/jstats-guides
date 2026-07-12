## Loading, Saving, Converting Data -- the finished follow-along script
## This is the completed version of the script built on the guide page.
## It runs from top to bottom, repeatedly, without errors: the deliberate
## error and prompt lines from the page are commented out below (each with
## a note), and the saves use overwrite = TRUE. Run the whole file with the
## Source icon, to the right of Run in the script toolbar.


## ---- 1. Load the package and a dataset ---------------------------------

## Load the jstats library (needed once per R session)
library(jstats)

## Load the package dataset called community
## It's loaded as a data frame into the Environment
jload("community")


## ---- 2. Objects and the assignment operator ----------------------------

## "Objects" other than data frames can go into the Environment
## The "Assignment Operator" (less-than followed by a dash) is a key Base R fundamental
## Take the thing on the right and assign it to what's on the left
## Another Base R fundamental is how to refer to one variable within a data frame
## Take the Region variable from the community data frame and assign it to a new object
## The new object we'll call "MyObject"
MyObject <- community$Region ## (Base R Code)


## ---- 3. More than one dataset, and cleaning up -------------------------

## You can have more than 1 data frame in the Environment
jload("clinic")

## Remove MyObject from the Environment
## Note that this is a Base R function (j is not the first letter)
rm(MyObject)

## Remove community from the Environment
rm(community)

## Remove clinic from the Environment
rm(clinic)


## ---- 4. How much output you see ----------------------------------------

## The output level is set to "standard" by default
## After you learn more about jstats (and R) you might not want all of that output
joutput("minimal")

## With minimal output, you get less information
jload("community")

## Set the output level back to standard
joutput("standard")


## ---- 5. Functions with no arguments, and getting help ------------------

## A few functions work correctly without input between the parentheses, but most require input
## On the guide page, the next line demonstrates one of jstats's error
## messages -- it is disabled here so this file runs without errors
# jload()

## But this one will show you the current output settings for jstats
joutput()

## Here's a Base R function that works without arguments/input
## List the objects/data frames in the Environment
ls()

## Here's another one from Base R
## A working directory is the "path" to where your project is stored on your computer
## If you're not working in a project, you have to set this yourself (finicky)
getwd()

## The technical name for a function's inputs are "Arguments"
## View help files describing necessary and optional Arguments by running...
?jload

## The same ? help works for base R functions and functions from any installed package
?ls

## And this one opens the package overview: every jstats function, grouped by purpose
?jstats


## ---- 6. The overwrite prompt -------------------------------------------

## On the guide page, the next line demonstrates the y/n overwrite prompt in
## the Console -- it is disabled here so an unattended run doesn't pause
# jload("community")

## Set an optional overwrite argument/input to overwrite without the prompt
jload("community", overwrite = TRUE)


## ---- 7. Saving to a Data folder ----------------------------------------

## Use the assignment operator to copy community to a new data frame called MyData
MyData <- community

## Save it with no folder specified -- where does the file go?
## The console message shows the full path: it landed in your project's
## working directory, the default location
## It's the same path the Base R getwd() command showed you earlier
jsave(MyData, "WhereDidIGo.rds", overwrite = TRUE)

## Delete that test file
## file.remove() is base R -- the file-on-disk equivalent of the rm()
## you used for data frames. It replies with a cryptic [1] TRUE
file.remove("WhereDidIGo.rds")

## Now name a Data folder of your own
## jstats will create this folder upon first save
## Or you can create it manually
joptions(data.dir = "Data")

## Save the dataset to the Data folder and call it MyData_r.rds
## Specify R native format with the .rds extension
## The Data folder is created now, on this first save
jsave(MyData, "MyData_r.rds", overwrite = TRUE)

## Remove MyData and community data frames from the environment
## Does not remove the saved file from the Data folder
rm(MyData)
rm(community)


## ---- 8. Saving across formats, and missing values ----------------------

## Reload the saved MyData.rds dataset from the data folder
## (overwrite = TRUE in case an earlier run left MyData_r in the Environment)
jload("MyData_r.rds", overwrite = TRUE)

## The original community dataset carries SPSS-style missing values
## So it saves to SPSS format (.sav) without a problem
jsave(MyData_r, "MyData_spss.sav", overwrite = TRUE)

## But the SPSS-style missing-value codes need to be converted
## if you want to save to a format other than R or SPSS
## On the guide page, the next line demonstrates that error --
## it is disabled here so this file runs without errors
# jsave(MyData_r, "MyData_stata.dta")

## Convert to Stata format (.dta)
MyData_stata <- jconvert(MyData_r, to = "stata")
jsave(MyData_stata, "MyData_stata.dta", overwrite = TRUE)  # No error


## ---- 9. Reloading, and how missing codes travel ------------------------

## Remove all data frames from the environment
rm(list = ls())

## Load all data sets back
jload("MyData_r.rds")
jload("MyData_spss.sav")
jload("MyData_stata.dta")

## Examine how the missing codes are kept in the different formats
jfreq(MyData_r, Education)  # will print whatever was originally stored
jfreq(MyData_spss, Education)  # SPSS-style user-defined missing codes (UDMs)
jfreq(MyData_stata, Education) # Stata-style UDMs

MyData_r_with_stata_UDM <- jconvert(MyData_r, to = "stata")
jfreq(MyData_r_with_stata_UDM, Education) # Now the UDMs display in Stata format


## ---- 10. Turning up the digits -----------------------------------------

## By default, jstats shows up to 3 decimal places
## (jstats never prints trailing zeros, so a mean can show fewer than that)
jdesc(MyData_r, Age)   # note how many decimals the Age mean shows here

## Turn the display up to the maximum of 7 decimal places
joutput(digits = 7)
jdesc(MyData_r, Age)   # the same mean, now with more decimals shown


## ---- 11. The proof that nothing was lost -------------------------------

## Ask for the mean of Age from each of the three reloaded data frames
jdesc(MyData_r, Age)
jdesc(MyData_spss, Age)
jdesc(MyData_stata, Age)
## All three report the identical mean, to the last decimal:
## same data, three file formats, nothing lost along the way

## And one base R caution, shown live (the guide page explains):
## Income carries declared missing-value codes (-99, -98)
jdesc(MyData_spss, Income)   # the correct mean -- jdesc leaves the codes out
## Base R gives a bare, unlabeled number, so extra work is needed just to
## make it visible: cat() adds a label, and the "\n"s add blank lines to
## set it apart. Run line by line (interactively), a plain mean() prints
## only a cryptic [1] number; run with Source, it wouldn't appear at all
cat("\n\nBase R mean of Income:", mean(MyData_spss$Income), "\n\n\n")  # a poisoned mean

## Set the display back to the default before you go
joutput(digits = 3)

## Put the data folder setting back to its default (the working directory) too
## Passing "" clears it (data.dir = NULL would leave it unchanged)
## A finished script leaves your session exactly as it found it
joptions(data.dir = "")

