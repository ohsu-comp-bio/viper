#!/usr/bin/env Rscript
suppressPackageStartupMessages(require(optparse))
library(ggplot2)
library(reshape)

parser <- OptionParser(option_list=list(
  make_option(c("-o", "--outdir"), action="store", type='character',
        help='Path to output directory.'),

  make_option(c("-a", "--activity"), action="store", type='character',
        help='Path to VIPER activity output file.'),
        
  make_option(c("-s", "--sample"), action="store", type='character',
        help='Name of sample of interest.'),

  make_option(c("-n", "--gene"), action="store", type='character',
        help='Name of gene of interest.')
))

opt <- parse_args(parser)
outdir <- opt$o
activity <- opt$a
sample <- opt$s
gene <- opt$g

if (is.null(outdir)) {
  print_help(parser)
  stop("--outdir is required")
}
if (is.null(activity)) {
  print_help(parser)
  stop("--activity is required")
}
if (is.null(sample)) {
  print_help(parser)
  stop("--sample is required")
}
if (is.null(gene)) {
  print_help(parser)
  stop("--gene is required")
}

# Raw data
z <- read.csv(activity, sep="\t")
# Reshaped to column-major
m <- melt(t(z), varnames=c("sample", "gene"), value.name="activity")
names(m)[names(m) == 'value'] <- 'activity'

# Samples for the gene of interest
s1 <- m[m$gene == gene, ]
# Sample of interest for marker
s2 <- s1[s1$sample == sample, ]

ggplot(s1,
  aes(
    y=gene,
    x=reorder(sample, activity),
    height=0.25
  )
) +
geom_tile(aes(fill=activity)) + 
theme(
  axis.title = element_blank(),
  axis.text.y = element_blank(),
  axis.text.x = element_blank(),
  axis.ticks = element_blank(),
  plot.title = element_text(hjust = 0.5)
) + 
scale_fill_gradient2(
  high="red",
  mid="white",
  low="blue",
  midpoint=0
) + 
geom_point(
  data=s2,
  position=position_nudge(y=0.15),
  shape=25,
  fill="black"
) + 
geom_text(
  data=s2,
  aes(label=sample),
  position=position_nudge(y=0.22),
  hjust=0.5,
  size=3
) + 
ggtitle("ENSG00000001167.14")

ggsave("out.png", width=10, height=2)
