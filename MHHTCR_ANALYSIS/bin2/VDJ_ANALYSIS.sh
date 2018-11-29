#!/bin/bash
#Further VDJ analysis

set -o xtrace
set -o errexit
#set -o pipefail

HOMEDIR=$HOME/sequencing

SEQDIR=$HOMEDIR/$1

# Directory for IMGT
IMGTDIR=$SEQDIR/IMGT

# Folder with 3_Nt files
NTDIR=$IMGTDIR/3_Nt

PEARSONCALC=$IMGTDIR/PEARSON

PROD=$PEARSONCALC/productive

# Directory of the vdj.jar file

VDJDIR=$HOMEDIR/files_programs/vdjtools/vdjtools.jar

# Directory of VDJ results

VDJRESULTS=$IMGTDIR/VDJRESULTS

# $1 has to be the name of the run, $2 has to be the Samplefile name, $3 the name of the
#Experiment results Folder as defined by tcR script (i.e Experiment3_results)
SAMPLE=$2
TARGETFOLDER=$VDJRESULTS/$3
PDFDIR=$TARGETFOLDER/FIGURES
TXTDIR=$TARGETFOLDER/TEXT

cd $VDJRESULTS
#Stacked bargraph (Spectratype Graph)

for SPECTRATYPE in $VDJRESULTS/$SAMPLE
do
  java -jar $VDJDIR PlotFancySpectratype -t 20 $SAMPLE Spectratype_
  mv $VDJRESULTS/Spectratype_*.pdf $TARGETFOLDER/Spectratype_`basename $SPECTRATYPE`.pdf
  mv $VDJRESULTS/Spectratype_*.txt $TARGETFOLDER/Spectratype_`basename $SPECTRATYPE`.txt

  #this just removes ".txt" from the filename
  for file in $TARGETFOLDER/Spectratype_`basename $SPECTRATYPE`*;
  do
    #This code sucks. If any of your input files dont end with .txt the script will stop here. Should use a better
    #way of renaming files.
    mv "${file}" "${file/.txt/}";
  done

done

#Plot VJ Usage
for VJ in $VDJRESULTS/$SAMPLE
do
  java -jar $VDJDIR PlotFancyVJUsage $SAMPLE VJUSAGE_
  mv $VDJRESULTS/VJUSAGE_*.pdf $TARGETFOLDER/VJUSAGE_`basename $VJ`.pdf
  mv $VDJRESULTS/VJUSAGE_*.txt $TARGETFOLDER/VJUSAGE_`basename $VJ`.txt

  #this just removes ".txt" from the filename
  for file in $TARGETFOLDER/VJUSAGE_`basename $VJ`*;
  do
    mv "${file}" "${file/.txt/}";
  done
done

#Plot Quantile Stats
for QUANTILE in $VDJRESULTS/$SAMPLE
do
  java -Xmx4G -jar $VDJDIR PlotQuantileStats $SAMPLE QUANTILE_
  mv $VDJRESULTS/QUANTILE_*.pdf $TARGETFOLDER/QUANTILE_`basename $QUANTILE`.pdf
  mv $VDJRESULTS/QUANTILE_*.txt $TARGETFOLDER/QUANTILE_`basename $QUANTILE`.txt
  #this just removes ".txt" from the filename
  for file in $TARGETFOLDER/QUANTILE_`basename $QUANTILE`*;
  do
    mv "${file}" "${file/.txt/}";
  done
done

if [ ! -d $PDFDIR ]; then mkdir -p $PDFDIR; fi;
if [ ! -d $TXTDIR ]; then mkdir -p $TXTDIR; fi;

mv $TARGETFOLDER/*.pdf $PDFDIR
mv $TARGETFOLDER/*.txt $TXTDIR
