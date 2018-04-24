suppressPackageStartupMessages(require(optparse))
suppressPackageStartupMessages(library(Biobase))
suppressPackageStartupMessages(library(viper))


parser <- OptionParser(option_list=list(
  make_option(c("-o", "--outdir"), action="store", type='character',
        help='Path to output directory.'),

  make_option(c("-r", "--regulons"), action="store", type='character',
        help='Path to RDS file containing network regulons.'),
        
  make_option(c("-e", "--expr"), action="store", type='character',
        help='Path to file containing expression of samples for which viper\n
        activity scores are desired.')		
))

opt <- parse_args(parser)
outdir <- opt$o
reg_fl <- opt$r
expr_fl <- opt$e

if (is.null(outdir)) {
  print_help(parser)
  stop("--outdir is required")
}
if (is.null(reg_fl)) {
  print_help(parser)
  stop("--regulons is required")
}
if (is.null(expr_fl)) {
  print_help(parser)
  stop("--expr is required")
}

# print session info
writeLines(capture.output(sessionInfo()), file.path(outdir, "RsessionInfo.txt"))
               
cat("Loading network regulons.")
regul <- readRDS(reg_fl)

cat("Loading expression data.")
expr_dt <- read.table(expr_fl, row.names=1, sep='\t', check.names=FALSE, header=TRUE)
expr_s <- as.matrix(expr_dt)

cat("Running VIPER")
vpres <- viper(expr_s, regul, verbose=TRUE)

cat("") # "verbose" from viper() doesn't terminate its last line correctly.
cat("Writing out activity scores")
write.table(vpres, file=file.path(outdir, 'viper_activities.tsv'), sep="\t", quote=FALSE)
