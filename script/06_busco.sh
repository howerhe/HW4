#!/bin/bash
# Modified from the course material
#$ -N busco
#$ -q free128,free72i,free56i,free48i,free40i,free32i,free64
#$ -pe openmp 32
#$ -R Y
### -m beas
### -M huiyuh3@uci.edu


# Load binaries and modules
module load augustus/3.2.1
module load blast/2.2.31 hmmer/3.1b2 boost/1.54.0
source /pub/jje/ee282/bin/.buscorc


# Directories and files
cd nanopore_assembly
INPUTTYPE="geno"
MYLIBDIR="/pub/jje/ee282/bin/busco/lineages/"
MYLIB="diptera_odb9"
OPTIONS="-l ${MYLIBDIR}${MYLIB}"
QRY="data/processed/unitigs.fa"
MYEXT="tmp/chromosome_split.fa"


# BUSCO
BUSCO.py -c 32 -i ${QRY} -m ${INPUTTYPE} -o $(basename ${QRY} ${MYEXT})_${MYLIB}${SPTAG} ${OPTIONS}