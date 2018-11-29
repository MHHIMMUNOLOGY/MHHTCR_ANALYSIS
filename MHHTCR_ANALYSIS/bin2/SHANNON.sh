##!/bin/sh

# Directories $2 has to be the name of the sequencing run. $WD has to lead to the VDJ files.
WD=$HOME/sequencing/$1/IMGT/VDJRESULTS
VDJRESULTS=$WD
TCRRESULTS=$WD/`basename $EXP`_results
SCRIPTS=$HOME/bin2
CURRENT=$PWD

#extract the count column. Make sure all files end with .txt
for i in $VDJRESULTS/*.txt
do
awk -F " " '{print $1}' $i > $VDJRESULTS/SHANNON`basename $i`
done

#Remove the header line  that says "count"
for i in $VDJRESULTS/SHANNON*.txt
do
sed -i '1d' $i
done

#If youre not in the VDJRESULTS folder it will move there
cd $VDJRESULTS

#Start the R script to calc Shannon
Rscript $SCRIPTS/SHANNON.R $VDJRESULTS

#Remove the header line  that says "count"
for i in $VDJRESULTS/SHANNON*.txt
do
sed -i '1d' $i
done

#Puts all calculations in one folder
cat $VDJRESULTS/SHANNON* > $VDJRESULTS/vegan_SHANNON_INDEX.txt
rm $VDJRESULTS/SHANNON*.txt

#goes back to where ever the script started from
cd $CURRENT
