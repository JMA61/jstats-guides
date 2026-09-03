# box_order_diff.R -- which "What you should see" boxes changed?
#
# Compares the console-field SEGMENT ORDER in the freshly rendered _site
# against the same pages on the live site. The S273 run_block() repair moves
# notes into their true position relative to printed output, so a box that
# changed shows up here as a different sequence of span classes:
#
#     cp-in   the "> " prompt line
#     cp-out  printed output
#     cp-msg  a note or warning
#     cp-err  an error
#
# WHY THE CLASS SEQUENCE AND NOT THE HTML. A raw HTML diff is unusable --
# Quarto rewrites ids and timestamps on every render, so everything "changes".
# And cp-out content is passed through fansi, which can emit NESTED spans, so
# matching whole <span>...</span> blocks would truncate at the inner close tag.
# The ordered list of class names is immune to both and is precisely what the
# repair alters.
#
# Run from the guides repo root, after rendering.

SITE_LOCAL <- "_site"
SITE_LIVE  <- "https://jma61.github.io/jstats-guides"

if (!dir.exists(SITE_LOCAL))
  stop("box_order_diff: no '", SITE_LOCAL, "' directory here. Run this from the ",
       "guides repo root, after a render. If your project builds somewhere else ",
       "(docs/, say), set SITE_LOCAL to that folder.", call. = FALSE)

# Ordered sequence of console-field classes in one page.
seq_of <- function(txt){
  m <- gregexpr('class="cp-(in|out|msg|err)"', txt, perl = TRUE)
  sub('class="cp-(.*)"', "\\1", regmatches(txt, m)[[1]])
}

read_local <- function(p)
  paste(readLines(p, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

read_live <- function(u){
  tf <- tempfile(fileext = ".html")
  on.exit(unlink(tf), add = TRUE)
  ok <- tryCatch({ download.file(u, tf, quiet = TRUE, mode = "wb"); TRUE },
                 error = function(e) FALSE, warning = function(w) FALSE)
  if (!ok) return(NULL)
  paste(readLines(tf, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
}

pages  <- list.files(SITE_LOCAL, pattern = "[.]html$", recursive = TRUE)
report <- list()

cat("\ncomparing", length(pages), "rendered pages against the live site\n")
cat(strrep("-", 74), "\n")

for (p in pages){
  new <- seq_of(read_local(file.path(SITE_LOCAL, p)))
  if (!length(new)) next                       # no console boxes on this page

  live <- read_live(paste0(SITE_LIVE, "/", p))
  if (is.null(live)){
    cat(sprintf("%-42s  %s\n", p, "not on the live site yet (new page?)"))
    next
  }
  old <- seq_of(live)

  if (identical(old, new)){
    cat(sprintf("%-42s  unchanged (%d segments)\n", p, length(new)))
  } else {
    cat(sprintf("%-42s  CHANGED\n", p))
    report[[p]] <- list(old = old, new = new)
  }
}

cat(strrep("-", 74), "\n")
if (!length(report)){
  cat("no box changed order.\n")
} else {
  cat(length(report), "page(s) changed. Detail:\n")
  for (p in names(report)){
    o <- report[[p]]$old; n <- report[[p]]$new
    cat("\n== ", p, " ==\n", sep = "")
    if (length(o) != length(n))
      cat("   segment COUNT changed: ", length(o), " -> ", length(n),
          " (look for a note that was previously merged or dropped)\n", sep = "")
    k <- min(length(o), length(n))
    d <- which(o[seq_len(k)] != n[seq_len(k)])
    if (length(d)){
      cat("   first divergence at segment ", d[1], "\n", sep = "")
      lo <- max(1, d[1] - 2); hi <- min(k, d[1] + 3)
      cat("     live:  ", paste(o[lo:hi], collapse = " "), "\n", sep = "")
      cat("     built: ", paste(n[lo:hi], collapse = " "), "\n", sep = "")
    }
  }
  cat("\nFor each change: open the box on the rendered page and confirm the new\n",
      "order matches what your own console does for that command.\n", sep = "")
}
