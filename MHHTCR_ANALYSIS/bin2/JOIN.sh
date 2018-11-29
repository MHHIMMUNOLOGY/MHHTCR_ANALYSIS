#!/bin/bash
# Pipeline Humble Beginnings version 2.0 (PHB v2.0)
# Copyright 2016 Solaiman Raha All Rights Reserved
# References:

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

# Folder with Joined FASTA files
JDIR=$SEQDIR/JOINED


############### Join the two reads together using PEAR #################

if [ ! -d $JDIR ]; then mkdir -p $JDIR; fi;

ls $QDIR > $SEQDIR/JOINLIST

# wc shows the number of lines in the file JOINLIST - the cut command removes the
# PATH that is also printed with the wc command
FILENUMBER=`wc -l $SEQDIR/JOINLIST | cut -d " " -f 1`;

# grep is used to create one file that lists all R1 filenames and one for R2
grep "_R1_" $SEQDIR/JOINLIST > $SEQDIR/R1LIST
grep "_R2_" $SEQDIR/JOINLIST > $SEQDIR/R2LIST

# seq creates numbers from x - y (in this case 1 to $FILENUMBER)
for i in `seq 1 $FILENUMBER`;
do

# It displays the $i lines of $FILENUMBER (with head) and then the tail command takes
# only the last line of that output (tail -n 1)
# so starting with 1 and going all the way to however many files are saved in $FILENUMBER

  R1=`head "$SEQDIR/R1LIST" -n $i | tail -n 1`;
  R2=`head "$SEQDIR/R2LIST" -n $i | tail -n 1`;

# fastq-join is a program that is part of the ea-utils package and allows joining of
# paired-end reads

  pear -f $QDIR/$R1 -r $QDIR/$R2 -o $JDIR/JOINED_$R1;
done

 # Convert FASTQ to FASTA for IMGT
for FASTA in $QDIR/*.fastq;
do
  #cat $FASTA | paste - - - - | sed 's/^@/>/g'| cut -f1-2 | tr '\t' '\n' > $FASTADIR/`basename $FASTA`.fasta
  sed -n '1~4s/^@/>/p;2~4p' $FASTA > `basename $FASTA`.fasta
done
