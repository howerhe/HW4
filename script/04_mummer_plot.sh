#!/bin/baash
# Modified from the course material


# Load binaries and modules
source /pub/jje/ee282/bin/.qmbashrc
module load jje/jjeutils


# Directories
basedir=$(pwd)
raw=$basedir/data/raw
tmp=$basedir/tmp
processed=$basedir/data/processed
figures=$basedir/output/figures


# URL of the database
DB_URL=ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/current/fasta/*


# Download the fasta file for all chromosomes
cd $raw
wget -A *chromosome* -q $DB_URL
chromosome=$(ls *chromosome*)
download_messeage="The sequence $chromosome has been downloaded."
echo $download_messeage


# MUMmer plot
cd $tmp
faSplitByN $raw/$chromosome chromosome_split.fa 10

module unload jje/jjeutils
nucmer -l 100 -c 100 -d 10 -banded -D 5 -prefix "flybase_unitigs" \
chromosome_split.fa $processed/unitigs.fa

cd $figures
mummerplot --fat --layout --filter -p "flybase_unitigs" $tmp/flybase_unitigs.delta \
-R $tmp/chromosome_split.fa -Q $processed/unitigs.fa --png


# Cleaning
cd $basedir