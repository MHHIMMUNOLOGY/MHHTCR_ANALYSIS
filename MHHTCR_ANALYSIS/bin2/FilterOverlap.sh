#!/bin/sh
#Filter out all overlapping clonotypes with x frequency
#This version uses 0.1% of Input sample to be compared with 0.1% of preDLI

HOMEDIR=$HOME/sequencing
SEQDIR=$HOMEDIR/$1
IMGTDIR=$SEQDIR/IMGT
VDJRESULTS=$IMGTDIR/VDJRESULTS
SAMPLE1=$2
SAMPLE2=$3
SAMPLE3=$4

Rscript $HOME/bin2/FilterOverlap.R $VDJRESULTS $SAMPLE1 $SAMPLE2 $SAMPLE3
#Rscript $HOME/bin2/FilterOverlap.R $VDJRESULTS $SAMPLE1 $SAMPLE2 $SAMPLE3

if [ ! -d $VDJRESULTS/FilterOverlap2 ]; then mkdir -p $VDJRESULTS/FilterOverlap2; fi;

#mv $VDJRESULTS/Filter*.pdf $VDJRESULTS/FilterOverlap
mv $VDJRESULTS/Filter*.txt $VDJRESULTS/FilterOverlap2
