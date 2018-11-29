#!/bin/sh
#Copy all InvSimpson Scores and put them in one file
VDJ=$HOME/sequencing/$1/IMGT/VDJRESULTS

for i in $VDJ/Experiment*;
do
  cp $i/TEXT/tcR_Diversity_Analysis.txt $VDJ/`basename $i`_div;
done;

for i in $VDJ/*_div;
do
  sed -i.bak -n -e '/Inverse/ ,$p' $i
  rm $VDJ/*.bak
done;

cat $VDJ/*_div > InvSimpsonScores
rm $VDJ/*_div
