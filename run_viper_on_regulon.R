require(optparse)
suppressWarnings(library(Biobase))
suppressWarnings(library(viper))

option_list = list(
  make_option(c("-d", "--dir"), action="store", default=NA, type='character',
        help='Path to output directory.'),

  make_option(c("-n", "--network"), action="store", default=NA, type='character',
        help='Path to file containing ARACNE network')
        
  make_option(c("-e", "--expr"), action="store", default=NA, type='character',
        help='Path to file containing expression of samples for which viper\n
        activity scores are desired.')		
)

opt = parse_args(OptionParser(option_list=option_list))

outdir=opt$d
net_fl = opt$n
expr_fl = opt$e

# print session info
writeLines(capture.output(sessionInfo()), file.path(outdir, "RsessionInfo.txt"))

print("Loading expression data of samples for which VIPER scores are desired.")
expr_s <- as.matrix(read.table(expr_fl, row.names=1, sep='\t', check.names=FALSE, header=TRUE))
               
print("Loading ARACNE network in R and converting to regulon obj")
regul <- load(net_fl)

print("Running VIPER")
vpres <- viper(expr_s, regul, verbose=FALSE)

print("Writing out activity scores")
write.table(vpres, file=file.path(outdir, 'viper_activities_ensembl.tsv'), sep='\t', quote=FALSE)
