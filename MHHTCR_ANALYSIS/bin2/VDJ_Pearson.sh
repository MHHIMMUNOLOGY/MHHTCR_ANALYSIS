#! /bin/bash
#VDJ R-Correlation Plot

set -o xtrace
set -o errexit
set -o pipefail

HOMEDIR=$HOME/sequencing

SEQDIR=$HOMEDIR/$1

# Directory for IMGT
IMGTDIR=$SEQDIR/IMGT

# Directory of the vdj.jar file

VDJDIR=$HOMEDIR/files_programs/vdjtools/vdjtools.jar

# Directory of VDJ results

VDJRESULTS=$IMGTDIR/VDJRESULTS

#SampleNames
TARGETFOLDER=$VDJRESULTS/$2

SAMPLE1=$3

SAMPLE2=$4

PDFDIR=$TARGETFOLDER/FIGURES
TXTDIR=$TARGETFOLDER/TEXT


#if [ ! -d $PEARSON]; then mkdir -p $PEARSON; fi;

java -jar $VDJDIR OverlapPair -p  $VDJRESULTS/$SAMPLE1 $VDJRESULTS/$SAMPLE2 Overlap_

#It is important to move each file that is presented and not just do a "*.pdf" or "*.txt" as several
# PDFs and TXTs file are produced and the command doesnt know which one to move and RENAME.
#rm $VDJRESULTS/Overlap_*table.collapsed.pdf

mv $VDJRESULTS/Overlap_*scatter.pdf $TARGETFOLDER/OVERLAP_SCATTER_`basename $SAMPLE1`_vs_`basename $SAMPLE2`.pdf
mv $VDJRESULTS/Overlap_*table.collapsed.pdf $TARGETFOLDER/OVERLAP_TABLE.COLLAPSED_`basename $SAMPLE1`_vs_`basename $SAMPLE2`.pdf
mv $VDJRESULTS/Overlap_*summary.txt $TARGETFOLDER/OVERLAP_SUMMARY_`basename $SAMPLE1`_vs_`basename $SAMPLE2`.txt
mv $VDJRESULTS/Overlap_*table.txt $TARGETFOLDER/OVERLAP_TABLE_`basename $SAMPLE1`_vs_`basename $SAMPLE2`.txt
mv $VDJRESULTS/Overlap_*table.collapsed.txt $TARGETFOLDER/OVERLAP_TABLE.COLLAPSED_`basename $SAMPLE1`_vs_`basename $SAMPLE2`.txt
