#!/bin/baash
# Modified from the course material


# Load modules
module load jje/jjeutils


# Directories
basedir=$(pwd)
processed=$basedir/data/processed
reports=$basedir/output/reports


# n50
n50 () {
	bioawk -c fastx ' { print length($seq); n=n+length($seq); } END { print n; } ' $1 \
  	| sort -rn \
  	| gawk ' NR == 1 { n = $1 }; NR > 1 { ni = $1 + ni; } ni/n > 0.5 { print $1; exit; } '
}

n50 $processed/unitigs.fa > $reports/n50.txt


# Cleaning
module unload jje/jjeutils