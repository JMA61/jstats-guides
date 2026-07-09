## Load the jstats library
library(jstats)


## Load the package dataset called community
## It's loaded as a data frame into the Environment
jload("community")

## "Objects" other than data frames can go into the Environment
## The "Assignment Operator" (less-than followed by a dash) is a key Base R fundamental
## Take the thing on the right and assign it to what's on the left
## Another Base R fundamental is how to refer to one variable within a data frame
## Take the Region variable from the community data frame and assign it to a new object
## The new object we'll call "MyObject"
MyObject <- community$Region ## (Base R Code)

## You can have more than 1 data frame in the Environment
jload("clinic")

## Remove MyObject from the Environment
## Note that this is a Base R function (j is not the first letter)
rm(MyObject)

## Remove community from the Environment
rm(community)

## Remove clinic from the Environment
rm(clinic)


## The output level is set to "standard" by default
## After you learn more about jstats (and R) you might not want all of that output
joutput("minimal")

## With minimal output, you get less information
jload("community")

## Set the output level back to standard
joutput("standard")


## A few functions work correctly without input between the parentheses, but most require input
jload()  # This will cause an error with a message about how you might fix the error

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

## The output you get in the Console Pane can include a confirmation prompt
## Here, jstats will not overwrite community unless you give it permission
jload("community") # Look at the y/n prompt in the console


## Set an optional overwrite argument/input to overwrite without the prompt
jload("community", overwrite = TRUE)

## Get some actual analysis output from the community data frame
jdesc(community,Age)

## Specify the number of digits in the output
joutput(digits = 4)
## At digits = 4 the Age mean reads 40.6505; at digits = 2 it rounds to 40.65
jdesc(community,Age)

joutput(digits = 2)
jdesc(community,Age)


## Use the assignment operator to copy community to a new data frame called MyData
MyData <- community


## Specify your project's Data directory
## jstats will create this folder upon first save
## Or you can create it manually
joptions(data.dir = "Data")


## Save the package dataset to the Data folder and call it MyData_r.rds
## Specify R native format with the .rds extension
## The Data folder is created now, on this first save
jsave(MyData, "MyData_r.rds")

## Remove MyData and community data frames from the environment
## Does not remove the dataset from the data folder
rm(MyData)
rm(community)


## Reload the saved MyData.rds dataset from the data folder.
jload("MyData_r.rds")

## The original community dataset carries SPSS-style missing values
## So it saves to SPSS format (.sav) without a problem
jsave(MyData_r, "MyData_spss.sav")

## But the SPSS-style missing-value codes need to be converted
## if you want to save to a format other than R or SPSS
jsave(MyData_r, "MyData_stata.dta")  # This will draw an error

## Convert to Stata format (.dta)
MyData_stata <- jconvert(MyData_r, to = "stata")
jsave(MyData_stata, "MyData_stata.dta")  # Now no error


## Remove all data frames from the environment
rm(list = ls())

## Load all data sets back
jload("MyData_r.rds")
jload("MyData_spss.sav")
jload("MyData_stata.dta")

## Examine how the missing codes are kept in the different formats
jfreq(MyData_r,Education)  # will print whatever was originally stored
jfreq(MyData_spss,Education)  # SPSS-style user-defined missing codes (UDMs)
jfreq(MyData_stata,Education) # Stata-style UDMs

MyData_r_with_stata_UDM <- jconvert(MyData_r, to = "stata")
jfreq(MyData_r_with_stata_UDM,Education) # Now the UDMs display in Stata format

## Run a regression
jlm(WellbeingScore ~ Income + Age, MyData_r)

