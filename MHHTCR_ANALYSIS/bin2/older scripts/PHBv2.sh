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

############## Demultiplex FASTQ files ##############


############## Prepare all MiSeq FASTQ files for IMGT Upload ##############

# Extract all .gz files

for GUNZIPFILE in $SEQDIR/*.gz;
do
  gunzip -d *.gz
done

# If there is no directory named X, then make it. If there is, don't do anything
if [ ! -d $QDIR ]; then mkdir -p $QDIR; fi;

# If there is no directory named X, then make it. If there is, don't do anything
if [ ! -d $FASTADIR ]; then mkdir -p $FASTADIR; fi;

# Take files out of the individual fastq-folders and moves them into the directory 'fastq'
mv $QDIR/*/*.fastq $QDIR
rmdir $QDIR/.itmsp

# Join the two reads together using ea-utils fastq-join
if [ ! -d $JDIR ]; then mkdir -p $JDIR; fi;
set -o xtrace
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

  pear -f $QDIR/$R1 -r $QDIR/$R2 -o $WINDIR/JOINED_$R1;
done

 # Convert FASTQ to FASTA for IMGT
for FASTA in $QDIR/*.fastq;
do
  #cat $FASTA | paste - - - - | sed 's/^@/>/g'| cut -f1-2 | tr '\t' '\n' > $FASTADIR/`basename $FASTA`.fasta
  sed -n '1~4s/^@/>/p;2~4p' $FASTA > `basename $FASTA`.fasta
done

#for copy n paste
for FASTA in $HOME/sequencing/miseq346/fastq/*.fastq;
do
  #cat $FASTA | paste - - - - | sed 's/^@/>/g'| cut -f1-2 | tr '\t' '\n' > $FASTADIR/`basename $FASTA`.fasta
  sed -n '1~4s/^@/>/p;2~4p' $FASTA > `basename $FASTA`.fasta
done


############## Convert all IMGT files into VDJtools Format ##############

# unzip/tar all files from IMGT (put in one directory)
# This creates a directory named after the .tar file and moves the .tar file into the directory

for FILE in *.txz;
do
 DIR="${FILE%.*}.itmsp" #Stores the name of the .tar file minus the extension in the variable DIR
 mkdir -p "$DIR"
 mv "$FILE" "$DIR"
done

# Extract .txt files from the tar
for TARFILE in *.txz;
do
  mkdir _`basename $TARFILE`;
  tar -xvf $TARFILE
  mv *.txt _$TARFILE;
done

# Extract the IMGT File needed for further analysis (like 3_Nt or 5_AA)

cd /home/imm_admin/sequencing/SolaiIMGT
mkdir 3_Nt

 for NT in 3*.txt;
 do
 find . -name '3*.txt' | cut -d/ -f 2- | pax -rws ':/:_:g' ./3_Nt
 done

#clean up the file names
FILES=/home/imm_admin/sequencing/SolaiIMGT/3_Nt/*
for filename in $FILES;
do
  [ -f "$filename" ] || continue
  mv $filename ${filename//.itmsp_3_Nt-sequences/}
done

# Read files with VDJtools and convert into VDJtool format
# First create a Metadatafile that includes all sample names
HOME=/home/imm_admin/sequencing
ls $HOME/SolaiIMGT/3_Nt > $HOME/vdjtools/METADATA_FILENAME.txt

# Take filename and remove the .txt and save into new .txt file (sample name)
cat $HOME/vdjtools/METADATA_FILENAME.txt | sed -e 's/.txt/ /' > $HOME/vdjtools/METADATA_SAMPLEID.txt

#Combine both to have one row with the filename and one with the sampleid
paste $HOME/vdjtools/METADATA_FILENAME.txt $HOME/vdjtools/METADATA_SAMPLEID.txt > $HOME/vdjtools/METADATA.txt

#Add the header that is required for vdjtools to read the metadata file
echo -e "#file.name\tsample.id" | cat - $HOME/vdjtools/METADATA.txt > $HOME/SolaiIMGT/3_Nt/METADATA_HEAD.txt

#Copy the java vdjtools file into the same directory as all the samples are in
cp vdjtools-1.0.6.jar $HOME/SolaiIMGT/3_Nt
cd $HOME/SolaiIMGT/3_Nt

#Run vdjtools and convert all samples using the METADATA with all sample names
java -jar vdjtools-1.0.6.jar Convert -S imgthighvquest -m ./METADATA_HEAD.txt VDJTOOLS_

mkdir VDJtools-files

mv VDJTOOLS_* VDJtools-files

#paste $HOME/vdjtools/HEADER1.txt $HOME/vdjtools/HEADER2.txt | column -s $'\t' -t > $HOME/vdjtools/HEADER_MERGED.txt

#paste $HOME/vdjtools/METADATA.txt $HOME/vdjtools/HEADER_MERGED.txt > $HOME/SolaiIMGT/3_Nt/METADATA_FINAL.txt

# To paste to files and have column: paste file1 file2 | column -s $'\t' -t




############## Read all files into R using tcR Package ##############


############## Do all analysis that are required ##############
