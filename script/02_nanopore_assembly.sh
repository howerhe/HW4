#!/bin/bash
# Modified from the course material


# Load modules
module load jje/jjeutils


# Create a priject with the script
createProject "nanopore_assembly" .
cd nanopore_assembly
basedir=$(pwd)
raw=$basedir/data/raw
processed=$basedir/data/processed
# Original file is too big
ln -sf /bio/share/solarese/hw4/rawdata/iso1_onp_a2_1kb.fastq $raw/reads.fq


# Assembly
minimap -t 32 -Sw5 -L100 -m0 $raw/reads.fq{,} \
| gzip -1 \
> $processed/onp.paf.gz

miniasm -f $raw/reads.fq $processed/onp.paf.gz \
> $processed/reads.gfa

awk ' $0 ~/^S/ { print ">" $2" \n" $3 } ' $processed/reads.gfa \
| fold -w 60 \
> $processed/unitigs.fa


# Cleaning
module unload jje/jjeutils