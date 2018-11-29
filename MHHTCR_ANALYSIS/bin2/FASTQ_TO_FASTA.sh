#!/bin/bash
# Convert FASTQ to FASTA for IMGT

set -o xtrace
set -o errexit
set -o pipefail

############## DIRECTORY VARIABLES ##############

# Home for sequencing
HOMEDIR=$HOME/sequencing

# Folder of Miseq run -> $1 is the first string after bash script i.e typing 'PHB.sh $HOME/sequencing/miseq346'
# into the commandline will run the script and save $1 as the string '$HOME/sequencing/miseq346'.
# For this script always have a folder called "sequencing" in your home directory ($HOME/sequencing) and in there
# for each directory create a folder for every run (i.e miseq346). In the command line run script like 'script.sh miseq346'
SEQDIR=$HOMEDIR/$1

# Folder for fastq files
QDIR=$SEQDIR/fastq

# Folder for FASTA files
FASTADIR=$SEQDIR/FASTA

if [ ! -d $FASTADIR ]; then mkdir -p $FASTADIR; fi;

for FASTA in $QDIR/*.fastq;
do
 #cat $FASTA | paste - - - - | sed 's/^@/>/g'| cut -f1-2 | tr '\t' '\n' > $FASTADIR/`basename $FASTA`.fasta
 sed -n '1~4s/^@/>/p;2~4p' $FASTA > `basename $FASTA`.fasta
done

mv *.fastq.fasta $FASTADIR
