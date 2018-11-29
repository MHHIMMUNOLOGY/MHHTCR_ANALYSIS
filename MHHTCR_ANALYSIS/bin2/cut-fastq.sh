#!/bin/bash
set -o errexit
set -o xtrace
# Cut a FASTQ File so all sequences have x-Nt
# Set $1 when starting the script. Use following syntac "cut_fastq.sh "NAME*" Xsequencelength"
# You HAVE to be in the FOLDER of the fastq files and you HAVE to use "" for the file name.
# Set $2 as max. sequence length
######### Variables #########
FASTA=$PWD
FILE=$1
for CUT in $FASTA/$1;
do
  cut -c 1-${2} $CUT > $FASTA/CUT_${2}_`basename $CUT`
done
