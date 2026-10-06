## One-way ANOVA -- the finished follow-along script
## This is the completed version of the script built on the guide page.
## It runs from top to bottom, repeatedly, without errors: the deliberate
## error line from block 10 is commented out below (with a note). Run the
## whole file with the Source icon, to the right of Run in the script
## toolbar.


## ---- 1. Load jstats and choose the data -------------------------------

## Load jstats for this session, then make the clinic practice dataset
## the default, so the commands below can leave its name out
library(jstats)
juse(clinic)


## ---- 2. Run the standard ANOVA ----------------------------------------

## Is there evidence that average flourishing differs across the four
## treatment conditions? The outcome goes left of the ~, the groups right
jaov(Flourishing ~ Condition)


## ---- 3. The other version, Welch's ANOVA ------------------------------

## The same question, without assuming the groups are equally spread out
jaov(Flourishing ~ Condition, welch = TRUE)


## ---- 4. Check equal variances with Levene's test ----------------------

## Levene's test asks whether the groups differ in spread. It is off by
## default, so ask for it
jaov(Flourishing ~ Condition, levene = TRUE)


## ---- 5. When Levene's test is significant -----------------------------

## A different outcome, daily screen time, whose spread does differ
## across the conditions. Watch for the note under the Levene table
jaov(ScreenTime ~ Condition, levene = TRUE)


## ---- 6. Which groups differ, Tukey HSD --------------------------------

## Post-hoc comparisons test every pair of groups. After the standard
## ANOVA, the method is Tukey HSD
jaov(Flourishing ~ Condition, posthoc = TRUE)


## ---- 7. Which groups differ after Welch's, Games-Howell ---------------

## The same request after Welch's ANOVA gives Games-Howell comparisons,
## which do not assume equal variances either
jaov(Flourishing ~ Condition, welch = TRUE, posthoc = TRUE)


## ---- 8. Look at the groups with jplot() -------------------------------

## Save the result under a name, then hand it to jplot() for a box plot
## of each group. The plot appears in the Plots tab (lower-right pane)
Results <- jaov(Flourishing ~ Condition)
jplot(Results)


## ---- 9. A group with one case -----------------------------------------

## No group in clinic is that small, so make one for this call only:
## subset = keeps every client who is not in CBT (condition 2), plus one
## who is (!= means "is not equal to", and | means "or")
jaov(Flourishing ~ Condition, posthoc = TRUE,
     subset = Condition != 2 | ClientID == "C016")


## ---- 10. One case under Welch's ANOVA ---------------------------------

## The same cases as a Welch's ANOVA. It needs each group's own variance,
## and one case has none, so jstats stops and says so
## On the page this line demonstrates that stop -- disabled here so the
## file runs clean; block 9 runs the standard ANOVA on the same cases
# jaov(Flourishing ~ Condition, welch = TRUE,  # an error, on purpose
#      subset = Condition != 2 | ClientID == "C016")


## ---- 11. Everything in one call ---------------------------------------

## full = TRUE asks for Levene's test, the confidence intervals, the
## effect size, and the post-hoc comparisons together
jaov(Flourishing ~ Condition, full = TRUE)
