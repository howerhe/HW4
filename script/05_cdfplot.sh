#!/bin/baash
# Modified from the course material


# Load modules
module load jje/jjeutils
module load rstudio/0.99.9.9


# Directories
basedir=$(pwd)
raw=$basedir/data/raw
tmp=$basedir/tmp
processed=$basedir/data/processed
figures=$basedir/output/figures


# Analysis
cd $raw
chromosome=$(ls *chromosome*)

bioawk -c fastx ' { print length($seq) } ' $chromosome \
| sort -rn \
| awk ' BEGIN { print "Assembly\tLength\nFB_Scaff\t0" } { print "FB_Scaff\t" $1 } ' \
> $tmp/r6scaff.txt

faSplitByN $chromosome /dev/stdout 10 \
| bioawk -c fastx ' { print length($seq) } ' \
| sort -rn \
| awk ' BEGIN { print "Assembly\tLength\nFB_Ctg\t0" } { print "FB_Ctg\t" $1 } ' \
> $tmp/r6ctg.txt

bioawk -c fastx ' { print length($seq) } ' $processed/unitigs.fa \
| sort -rn \
| awk ' BEGIN { print "Assembly\tLength\nTruSeq_Ctg\t0" } { print "TruSeq_Ctg\t" $1 } ' \
> $tmp/truseq.txt


# Plot
plotCDF2 $tmp/{r6scaff,r6ctg,truseq}.txt $figures/r6_v_seq.png


# Cleaning
module unload jje/jjeutils
module unload rstudio/0.99.9.9
cd $basedir