#!/bin/baash


# Load modules
module load jje/jjeutils
module load jje/kent


# Create a working directory
mkdir partition_summary
cd partition_summary


# URL of the database
DB_URL=ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/current/fasta/*


# Download the fasta file for all chromosomes
wget -A *chromosome* -q $DB_URL
chromosome=$(ls *chromosome*)
download_messeage="The sequence $chromosome has been downloaded."
echo $download_messeage


# Check the integrity
if [ "$(wget -A *md5* -q -O - $DB_URL | grep chromosome | md5sum -c --status)" != "" ]; then
	echo "Sequences cannot pass the integrity check."
	exit 1
fi


# Calculate the following for all sequences ≤ 100kb and all sequences > 100kb
bioawk -c fastx 'length($seq) > 100000 { print ">"$name;print $seq; }' $chromosome \
| tee > long.fa \
| faSize /dev/stdin \
| gawk 'NR == 1 {print "For sequences with length > 100 kb, there are " $1 " bases in total, " $3 " Ns, " $12 " sequences)."}' \
> reports.txt

bioawk -c fastx 'length($seq) <= 100000 { print ">"$name;print $seq; }' $chromosome \
| tee  short.fa \
| faSize /dev/stdin \
| gawk 'NR == 1 {print "For sequences with length <= 100 kb, there are " $1 " bases in total, " $3 " Ns, " $12 " sequences)."}' \
>> reports.txt
# The uncut data is analyzed to validate the results above
faSize $chromosome \
| gawk 'NR == 1 {print "For all sequences, there are " $1 " bases in total, " $3 " Ns, " $12 " sequences)."}' \
>> reports.txt


# Plot
bioawk -c fastx '{ print length($seq); }' $chromosome \
| sort -rn \
| tee >(plotCDF /dev/stdin chromosome_size.png) \
| gawk 'NR == 1 {n = $1; print n} NR > 1 {n = n + $1; print n}' \
| plotCDF /dev/stdin chromosome_cumulative.png

bioawk -c fastx '{ print length($seq); }' long.fa\
| sort -rn \
| tee >(plotCDF /dev/stdin long_size.png) \
| gawk 'NR == 1 {n = $1; print n} NR > 1 {n = n + $1; print n}' \
| plotCDF /dev/stdin long_cumulative.png

bioawk -c fastx '{ print length($seq); }' short.fa\
| sort -rn \
| tee >(plotCDF /dev/stdin short_size.png) \
| gawk 'NR == 1 {n = $1; print n} NR > 1 {n = n + $1; print n}' \
| plotCDF /dev/stdin short_cumulative.png

bioawk -c fastx '{ print gc($seq); }' $chromosome \
| sort -rn \
| plotCDF /dev/stdin chromosome_gc.png

bioawk -c fastx '{ print gc($seq); }' long.fa \
| sort -rn \
| plotCDF /dev/stdin long_gc.png

bioawk -c fastx '{ print gc($seq); }' short.fa \
| sort -rn \
| plotCDF /dev/stdin short_gc.png


# Cleaning
module unload jje/jjeutils
module unload jje/kent
rm {short,long}.fa
cd ../