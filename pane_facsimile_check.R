# pane_facsimile_check.R -- machine assertion battery for pane_facsimile.R's
# run_block(): stream ordering (S273), expect_error_match (S273, wrap-proof
# matching S274), and a blank line printed after a message (S334).
#
# WHY THIS FILE EXISTS. run_block() is a shared asset: every "What you should
# see" box (show_block) and every Console facsimile (show_console) on the guide
# site runs through it, so one defect here is wrong output on several published
# pages at once. Both S272 defects were SILENT -- a both-streams statement
# rendered inverted, and expect_error = TRUE accepted whichever error happened
# to fire. Neither showed up as a broken render. This battery is the
# discriminator.
#
# NO jstats REQUIRED. Every fixture below is synthetic base R, so the check runs
# anywhere R runs -- no package install, no datasets, no render environment.
# That is deliberate: a check that needed the full render stack would be run
# rarely, and this one guards an asset that changes rarely but breaks quietly.
#
# HOW TO RUN
#   Rscript pane_facsimile_check.R
# Exit status 0 = all checks passed; 1 = at least one failed (and the failures
# are listed at the foot).
#
# ---------------------------------------------------------------------------
# SET THIS ONE PATH: where pane_facsimile.R lives, relative to this file or
# absolute. Everything else in the battery is location-independent.
PANE_FACSIMILE <- "pane_facsimile.R"
# ---------------------------------------------------------------------------

if (!file.exists(PANE_FACSIMILE))
  stop("pane_facsimile_check: cannot find '", PANE_FACSIMILE,
       "'. Set PANE_FACSIMILE at the head of this file to its location.",
       call. = FALSE)
source(PANE_FACSIMILE)

# ---- harness --------------------------------------------------------------
.fails <- character(0)
.n     <- 0L

ck <- function(id, what, got, want){
  .n <<- .n + 1L
  ok <- identical(got, want)
  if (!ok)
    .fails <<- c(.fails, sprintf("%s -- %s\n     wanted: %s\n     got:    %s",
                                 id, what, deparse1(want), deparse1(got)))
  cat(sprintf("%-6s %-58s %s\n", id, what, if (ok) "ok" else "FAIL"))
  invisible(ok)
}

# Collapse a segment list to its type sequence -- the thing the defects were in.
types <- function(segs) vapply(segs, function(s) s$type, character(1))
texts <- function(segs) vapply(segs, function(s) s$text,  character(1))

# Did this call stop(), and with what?
halted <- function(expr){
  tryCatch({ force(expr); NULL }, error = function(e) conditionMessage(e))
}

run <- function(code, ...) .obx$run_block(code, ...)

cat("\npane_facsimile_check -- run_block() stream ordering + expect_error_match\n")
cat(strrep("-", 78), "\n\n")

# ---- 1. STREAM ORDERING ---------------------------------------------------
# These are the checks that fail on the unrepaired file. C1 is the live defect
# shape: jload() signals its load confirmation (a message) BEFORE printing the
# scan narrative (stdout). Pre-repair, run_block() emitted stdout first
# unconditionally, so the box showed the narrative above the confirmation --
# reversing the deliberate S227/E17 ordering.

cat("1. STREAM ORDERING\n")

C1 <- run('{ message("confirmation"); cat("narrative\\n") }', echo = FALSE)
ck("C1", "message before stdout stays first (the jload shape)",
   types(C1), c("message", "stdout"))

C2 <- run('{ cat("printed\\n"); message("note") }', echo = FALSE)
ck("C2", "stdout before message stays first",
   types(C2), c("stdout", "message"))

C3 <- run('{ cat("one\\n"); message("mid"); cat("two\\n") }', echo = FALSE)
ck("C3", "stdout / message / stdout interleaves in true order",
   types(C3), c("stdout", "message", "stdout"))
ck("C3b", "  ... and carries the right text in each segment",
   texts(C3), c("one", "mid", "two"))

C4 <- run('{ message("a"); message("b"); cat("x\\n") }', echo = FALSE)
ck("C4", "consecutive messages coalesce into ONE segment",
   types(C4), c("message", "stdout"))
ck("C4b", "  ... joined by a newline, as before the repair",
   texts(C4)[1], "a\nb")

# ---- 2. WHAT MUST NOT MOVE ------------------------------------------------
# Real top-level R defers warnings to the end of the call (options(warn = 0)),
# so end-of-statement is their FAITHFUL position -- not a second instance of the
# ordering defect. If a future change "fixes" these, the box starts disagreeing
# with the console in a new direction. See the S187 note in pane_facsimile.R.

cat("\n2. WHAT MUST NOT MOVE (warnings deferred, errors last)\n")

W1 <- run('{ cat("before\\n"); warning("careful"); cat("after\\n") }', echo = FALSE)
ck("W1", "warning is NOT interleaved -- deferred to end of statement",
   types(W1), c("stdout", "message"))
ck("W1b", "  ... and the two stdout halves coalesce around it",
   texts(W1)[1], "before\nafter")
ck("W1c", "  ... under R's own 'Warning message:' header",
   grepl("^Warning message:", texts(W1)[2]), TRUE)

W2 <- run('{ f2 <- function() { warning("first"); warning("second") }; f2() }',
          echo = FALSE)
ck("W2", "two warnings render as one numbered block, calls attached",
   texts(W2)[1], "Warning messages:\n1: In f2() : first\n2: In f2() : second")

# W3 pins a byte of TEXT, not a behaviour, and is the more important of the two.
# fmt_warn() deparses conditionCall(), so a warning raised at the top level of
# an evaluated block renders run_block()'s OWN eval call into the box. That
# makes the internal variable name part of published output: the first S273
# draft moved the eval into a helper with a renamed argument and silently
# rewrote this text. Harmless-looking, invisible in a render, and a real change
# to any page carrying such a warning. If this check fails, the eval call was
# renamed -- restore the literal eval(exprs[[i]], globalenv()) rather than
# re-pinning the expectation.
W3 <- run('warning("top level")', echo = FALSE)
ck("W3", "deparsed eval call unchanged from pre-S273 (published text)",
   texts(W3)[1], "Warning message:\nIn eval(exprs[[i]], globalenv()) : top level")

E1 <- run('{ cat("printed\\n"); stop("boom") }', echo = FALSE, expect_error = TRUE)
ck("E1", "output before an error precedes the error segment",
   types(E1), c("stdout", "error"))

# ---- 3. STRUCTURE PRESERVED FOR EVERY EXISTING PAGE -----------------------
# The repair must not reshape output for statements that DON'T interleave --
# that is every block on every page built before S273.

cat("\n3. STRUCTURE PRESERVED (no interleaving = unchanged segments)\n")

P1 <- run('cat("plain output\\n")')
ck("P1", "echo on: prompt + stdout, exactly two segments",
   types(P1), c("prompt", "stdout"))
ck("P1b", "  ... prompt echoes the line as typed",
   texts(P1)[1], '> cat("plain output\\n")')

P2 <- run('sqrt(144)  # find a square root')
ck("P2", "S189 trailing-comment echo fidelity intact",
   texts(P2)[1], "> sqrt(144)  # find a square root")
ck("P2b", "  ... and the visible value still prints",
   texts(P2)[2], "[1] 12")

P3 <- run('cat("quiet\\n")', echo = FALSE)
ck("P3", "S192 echo = FALSE still drops the prompt segment",
   types(P3), "stdout")

P4 <- run('x_multi <- c(1,\n  2,\n  3)')
ck("P4", "multi-line statement echoes with continuation prompts",
   texts(P4)[1], "> x_multi <- c(1,\n+   2,\n+   3)")

P5 <- run('cat("a\\n")\ncat("b\\n")')
ck("P5", "two statements produce two prompt/stdout pairs",
   types(P5), c("prompt", "stdout", "prompt", "stdout"))

P6 <- run('invisible(42)', echo = FALSE)
ck("P6", "invisible result produces no segments",
   length(P6), 0L)

# ---- 4. expect_error_match ------------------------------------------------
# expect_error = TRUE asserts only that AN error occurred. M2 is the S272 case:
# a broken install raised "could not find function ..." and would have been
# published in the box as though it were the package's considered refusal.

cat("\n4. expect_error_match\n")

# PREFLIGHT. Run against a pre-S273 pane_facsimile.R, every call below raises
# "unused argument" -- which halted() would happily report as a halt, so the
# halt-shaped checks would pass for entirely the wrong reason and the battery
# would crash out before sections 5 and 6 ran. Establish the argument EXISTS
# first, then assert on message CONTENT rather than mere haltedness.
HAS_MATCH <- "expect_error_match" %in% names(formals(.obx$run_block))
ck("M0", "run_block() accepts expect_error_match at all",
   HAS_MATCH, TRUE)

if (!HAS_MATCH){
  cat("       (section 4 skipped -- the argument is absent from this file)\n")
} else {

M1 <- run('stop("you must choose a convention")', echo = FALSE,
          expect_error_match = "must choose")
ck("M1", "matching phrase passes and renders the error segment",
   types(M1), "error")

M2 <- halted(run('stop("could not find function jdeclare_missing")', echo = FALSE,
                 expect_error_match = "must choose"))
ck("M2", "WRONG error halts (the S272 broken-install case)",
   !is.null(M2) && grepl("raised the WRONG error", M2), TRUE)
ck("M2b", "  ... and the halt names the phrase wanted",
   grepl("must choose", M2, fixed = TRUE), TRUE)
ck("M2c", "  ... and the error actually received",
   grepl("could not find function jdeclare_missing", M2, fixed = TRUE), TRUE)

M3 <- halted(run('cat("no error here\\n")', echo = FALSE,
                 expect_error_match = "must choose"))
ck("M3", "NO error at all halts -- the demonstration did not happen",
   !is.null(M3) && grepl("raised NO", M3), TRUE)

M4 <- run('stop("bad value (see ?joptions)")', echo = FALSE,
          expect_error_match = "(see ?joptions)")
ck("M4", "match is plain substring: regex metacharacters are literal",
   types(M4), "error")

M5 <- halted(run('stop("x")', echo = FALSE, expect_error_match = c("a", "b")))
ck("M5", "non-scalar match is rejected up front",
   !is.null(M5) && grepl("single non-empty string", M5), TRUE)

M6 <- run('stop("boom")', echo = FALSE, expect_error_match = "boom")
ck("M6", "expect_error_match implies expect_error (not passed here)",
   types(M6), "error")

# WRAP-PROOF MATCHING (S274). The jstats emitters width-wrap, so any phrase
# long enough to be specific is long enough to straddle a wrap point. M8 and
# M9 fail on the pre-S274 file -- that is what makes them evidence rather than
# decoration; M10 is their negative control, confirming the flattening did not
# loosen the match into a word-soup that accepts anything.
# halted() rather than a bare run() throughout: on the unflattened file these
# calls HALT, and a bare run() would abort the battery instead of recording a
# failure and continuing.

M8 <- halted(run('stop("No missing-value convention is\\nselected, so choose one")',
                 echo = FALSE, expect_error_match = "convention is selected"))
ck("M8", "phrase spanning a wrapped line still matches",
   is.null(M8), TRUE)

M9 <- halted(run('stop("Choose one for this session:\\n      Lowercase markers behave as true NAs.")',
                 echo = FALSE, expect_error_match = "session: Lowercase markers"))
ck("M9", "  ... including across an indented continuation line",
   is.null(M9), TRUE)

M10 <- halted(run('stop("No missing-value convention is\\nselected")',
                  echo = FALSE, expect_error_match = "convention selected"))
ck("M10", "flattening does not loosen the match: absent phrase still halts",
   !is.null(M10) && grepl("raised the WRONG error", M10), TRUE)

}   # end section 4

M7 <- halted(run('stop("uncaught")', echo = FALSE))
ck("M7", "publish gate intact: unexpected error still halts",
   !is.null(M7) && grepl("uncaught", M7), TRUE)

# ---- 5. SINK HYGIENE ------------------------------------------------------
# The repair sinks stdout to a file. A sink left standing after a halt would
# silence the rest of the render -- the failure would look like a blank page,
# not like an error.

cat("\n5. SINK HYGIENE\n")

s0 <- sink.number()
invisible(halted(run('stop("uncaught")', echo = FALSE)))
ck("S1", "sink unwound after an uncaught error",
   sink.number(), s0)

invisible(run('{ cat("x\\n"); message("y") }', echo = FALSE))
ck("S2", "sink unwound after a normal both-streams run",
   sink.number(), s0)

if (HAS_MATCH){
  invisible(halted(run('stop("x")', echo = FALSE, expect_error_match = "nope")))
  ck("S3", "sink unwound after an expect_error_match halt",
     sink.number(), s0)
}

# ---- 6. MID-LINE MESSAGE (documented caveat) ------------------------------
# cat() with no trailing newline, interrupted by a message. The ORDER must be
# right; the added line break is the documented caveat in run_block()'s header.
# Pinned so that if the rendering ever learns to join segments, this check is
# the reminder to revisit the caveat.

cat("\n6. MID-LINE MESSAGE (documented caveat)\n")

X1 <- run('{ cat("abc"); message("note"); cat("def\\n") }', echo = FALSE)
ck("X1", "partial line flushed in true order, not held back",
   types(X1), c("stdout", "message", "stdout"))
ck("X1b", "  ... partial line kept whole in its own segment",
   texts(X1), c("abc", "note", "def"))

# ---- 7. A BLANK LINE PRINTED AFTER A MESSAGE (S334) -----------------------
# jstats writes a blank line to stdout after a note that would otherwise sit
# against the next prompt (joptions(data.dir = ), v0.9.211). The flush that
# carries it holds one newline and nothing else; until S334 that became "" and
# was dropped, so the box showed the note against the prompt where the Console
# shows a blank line. B1 and B2 fail on the unrepaired file; B3-B5 hold what
# must not change.

cat("\n7. A BLANK LINE PRINTED AFTER A MESSAGE\n")

B1 <- run('{ cat("echo\\n"); message("note"); cat("\\n") }', echo = FALSE)
ck("B1", "a lone newline after a message is kept as an empty segment",
   types(B1), c("stdout", "message", "stdout"))
ck("B1b", "  ... whose text is empty: one blank line, no more",
   texts(B1), c("echo", "note", ""))

B2 <- run('{ message("a"); cat("\\n"); message("b") }', echo = FALSE)
ck("B2", "a blank line between two messages keeps them apart",
   texts(B2), c("a", "", "b"))

B3 <- run('invisible(1)', echo = FALSE)
ck("B3", "a statement that prints nothing still adds no segment",
   length(B3), 0L)

B4 <- run('{ cat("a\\n"); cat("\\n") }', echo = FALSE)
ck("B4", "a blank line straight after printed text rides in its segment",
   texts(B4), "a\n")

B5 <- run('message("")', echo = FALSE)
ck("B5", "an empty MESSAGE is still dropped: only stdout can be empty",
   length(B5), 0L)

# ---- foot -----------------------------------------------------------------
cat("\n", strrep("-", 78), "\n", sep = "")
if (length(.fails)){
  cat(sprintf("%d of %d checks FAILED\n\n", length(.fails), .n))
  for (f in .fails) cat("  ", f, "\n\n", sep = "")
  quit(status = 1)
}
cat(sprintf("all %d checks passed\n", .n))
