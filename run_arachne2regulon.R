
#example of optparse usage https://gist.github.com/ericminikel/8428297
suppressPackageStartupMessages(require(optparse))
suppressPackageStartupMessages(require(Biobase))
suppressPackageStartupMessages(require(viper))

# function that loads expression matrix of unzipped or gzipped file
load_expr <- function(expr_file) {
	if (endsWith(expr_file, '.gz')) {
		expr <- as.matrix(read.table(gzfile(expr_file, 'rt'), row.names=1, sep='\t',
							check.names=FALSE, header=TRUE))
	} else {
		expr <- as.matrix(read.table(expr_file, row.names=1, sep='\t',
							check.names=FALSE, header=TRUE))
	}
	
	return(expr)
}

main <- function() {
	
	# allow for commandline args
	option_list = list(
	make_option(c("-d", "--dir"), action="store", default=NA, type='character',
				help='Full path to outdir.'),
	make_option(c("-e", "--expr"), action="store", default=NA, type='character',
				help='Full path to input expression matrix used to build ARACNE network.'),
	make_option(c("-n", "--network"), action="store", default=NA, type='character',
				help='Full path to ARACNE network.txt.')
	)
	
	opt = parse_args(OptionParser(option_list=option_list))
	
	# todo: make sure this works
	# todo: report which isn't working and exit
	if(any(is.na(c(opt$d, opt$e, opt$n)))) {
		cat("One or more variables have not been set!")
	}
	
	outdir=opt$d
	expr_aracne_fl=opt$e
	network_fl=opt$n
	
	# print session info
	writeLines(capture.output(sessionInfo()), paste(outdir, "RsessionInfo.txt", sep=""))
	
	print("Loading expression data from which ARACNE network was derived in R.")
	expr_a <- load_expr(expr_aracne_fl)
								 
	print("Loading ARACNE network in R and converting to regulon obj")
	regul <- aracne2regulon(network_fl, expr_a)
	
	#print("Writing out activity scores")
  save(regul, file=paste(outdir, 'regulons.tsv', sep=''))
	
}


main()


