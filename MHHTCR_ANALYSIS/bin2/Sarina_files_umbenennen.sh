#!/bin/sh

figlet TCR ANALYSIS
read -n1 -r -p "Are you in the directory of the sample? [Press Enter to continue]"
HOMEDIR=$PWD
IMGTDIR=$HOME/sequencing/$1/IMGT
mkdir $IMGTDIR
PEARSON=$IMGTDIR/VDJRESULTS/PEARSON

IMGTDIR=$PWD
mkdir $IMGTDIR
mv *.txt $IMGTDIR


#USE THIS TO FORMAT SARINAS FILES-------------------
mkdir IMGT
mv *.txt IMGT
cd IMGT
ls
IMGTDIR=$PWD
for i in *.txt;
do
  mkdir folder_`basename $i`
  mv $i folder_`basename $i`
  mv $IMGTDIR/folder_`basename $i`/* $IMGTDIR/folder_`basename $i`/5_AA-sequences.txt
done;

rename 's/_//g' *
rename 's/5AA-sequences.txt//g' *
rename 's/AA-sequences.txt//g' *
#rename 's/folder//g' *
rename 's/.txt//g' *
rename 's/-//g' *
#USE THIS TO FORMAT SARINAS FILES-------------------

sed i.bak 's/CDR3_freq_Genesprodfolder//g' $PEARSON/PearsonScore
sed i.bak 's/_5_AA-sequences//g' $PEARSON/PearsonScore
