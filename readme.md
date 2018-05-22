This repo contains simple CLI wrapper scripts and environment configuration (docker, conda)
for running [VIPER](https://bioconductor.org/packages/release/bioc/html/viper.html),
a tool for "inference of protein activity from gene expression data".

The wrappers are written in R. See `install_packages.r` for the required R packages.
`build.sh` and `meta.yaml` describe the [conda](https://conda.io) package, and there's
a `Dockerfile`.

The docker container is published to [ohsucompbio/viper:1.12-55312ce](https://hub.docker.com/r/ohsucompbio/viper/).  

`docker run ohsucompbio/viper`

The conda package is published to [buchanae/ohsu-compbio-viper](https://anaconda.org/buchanae/ohsu-compbio-viper).  

`conda install -c buchanae ohsu-compbio-viper `

# Usage

There are three wrapper scripts:

### run_aracne2regulon.r

This command runs `aracne2regulon` to convert an [aracne](https://github.com/califano-lab/ARACNe-AP) network to VIPER regulons. The output is a serialized R object (RDS format).

Example:  
`run_aracne2regulon.r --expr data/expression.tsv --network data/network.txt --output data/regulons.rds`

```
Usage: run_aracne2regulon.r [options]

Options:
	-o OUTPUT, --output=OUTPUT
		Path to output.

	-e EXPR, --expr=EXPR
		Path to input expression matrix used to build ARACNE network.

	-n NETWORK, --network=NETWORK
		Path to ARACNE network.txt.
```

### run_viper.r

This command runs the inference analysis, outputing a matrix of regulator activity values per sample (TSV format).

Example:  
`run_viper.r --regulons data/regulons.rds --expr data/expression.tsv --output data/activity.tsv`

```
Usage: run_viper.r [options]

Options:
	-o OUTPUT, --output=OUTPUT
		Path to output file.

	-r REGULONS, --regulons=REGULONS
		Path to RDS file containing network regulons.

	-e EXPR, --expr=EXPR
		Path to file containing expression of samples for which viper activity scores are desired.

	--nes
		Use the normalized enrichment score (NES)
```


### viper_report.r

This command generates a visualization of the activity of a list of regulator gene for a given sample. Output is a PNG image for each gene in the list.

Example:  
`viper_report.r --activity data/activity.tsv --sample sample1 --genes gene-list.txt --output data/sample1-ENSG00000169083.15.png`

```
Usage: viper_report.r [options]

Options:
	-o OUTPUT, --output=OUTPUT
		Path to output directory to store reports.

	-a ACTIVITY, --activity=ACTIVITY
		Path to VIPER activity data.

	-s SAMPLE, --sample=SAMPLE
		Name of sample of interest.

	--genes=GENES
		Path to file containing a list of genes to generate reports for, one per line.
```
