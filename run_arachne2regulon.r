#!/usr/bin/env Rscript
suppressPackageStartupMessages(require(optparse))
suppressPackageStartupMessages(require(Biobase))
suppressPackageStartupMessages(require(viper))

parser <- OptionParser(option_list=list(
  make_option(c("-o", "--output"), action="store", type='character',
        help='Path to output.'),
  make_option(c("-e", "--expr"), action="store", type='character',
        help='Path to input expression matrix used to build ARACNE network.'),
  make_option(c("-n", "--network"), action="store", type='character',
        help='Path to ARACNE network.txt.')
))

opt <- parse_args(parser)
output <- opt$o
expr_fl <- opt$e
network_fl <- opt$n

if (is.null(output)) {
  print_help(parser)
  stop("--output is required")
}

if (is.null(expr_fl)) {
  print_help(parser)
  stop("--expr is required")
}

if (is.null(network_fl)) {
  print_help(parser)
  stop("--network is required")
}

cat("Loading expression data from which ARACNE network was derived in R.")
expr_dt <- read.table(expr_fl, row.names=1, sep='\t', check.names=FALSE, header=TRUE)
expr_a <- as.matrix(expr_dt)
               
cat("Loading ARACNE network in R and converting to regulon obj")
regul <- aracne2regulon(network_fl, expr_a)

saveRDS(regul, file=output)
