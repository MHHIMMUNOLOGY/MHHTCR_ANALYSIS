#!/bin/sh
#This will download the IMGT database and annotate your fastq files. They dont have to be unzipped, just use the files you get back from Illumina and put them into the experiment folder $SEQDIR
#Run this script from your experiment folder ($SEQDIR) like this:
#ANNOTATE_IMGT.sh foldername loci(this is either TRA, TRB, TRD, TRG or IGH, IGL etc..) species(write human or mouse, make sure to use this when downloading the reference library)
set -o xtrace
set -o errexit

HOMEDIR=$HOME/sequencing

SEQDIR=$HOMEDIR/$1

# Directory for IMGT
IMGTDIR=$SEQDIR/IMGT


VDJRESULTS=$IMGTDIR/VDJRESULTS
VDJDIR=$HOME/sequencing/files_programs/vdjtools/vdjtools.jar

#loci for mixcr alignment
LOCI=$2

SPECIES=$3

FASTQ_FILE=$4

if [ ! -d $VDJRESULTS ]; then mkdir -p $VDJRESULTS; fi;

for SAMPLE in $FASTQ_FILE
do
  mixcr align -s $SPECIES -l $LOCI -nw $SAMPLE `basename $SAMPLE`.vdjca
  mixcr assemble `basename $SAMPLE`.vdjca `basename $SAMPLE`.clns
  mixcr exportClones `basename $SAMPLE`.clns $VDJRESULTS/`basename $SAMPLE`_MIXCR_IMGT.txt
  $VDJDIR Convert -S mixcr $VDJRESULTS/`basename $SAMPLE`_MIXCR_IMGT.txt $VDJRESULTS/VDJTOOLS_
  rm *.vdjca
  rm *.clns
  rm $VDJRESULTS/`basename $SAMPLE`_MIXCR_IMGT.txt
done
