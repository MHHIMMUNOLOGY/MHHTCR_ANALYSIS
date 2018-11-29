#!/bin/sh

#rename every file

HOMEDIR=$HOME/sequencing

SEQDIR=$HOMEDIR/$1

# Directory for IMGT
IMGTDIR=$SEQDIR/IMGT


# Directory of VDJ results

VDJRESULTS=$IMGTDIR/VDJRESULTS


if [ ! -d $IMGTDIR ]; then mkdir -p $IMGTDIR; fi;

mv $SEQDIR/*.txt $IMGTDIR

for i in $IMGTDIR/*.txt;
do
  mkdir $IMGTDIR/folder_`basename $i`
  mv $i $IMGTDIR/folder_`basename $i`
  mv $IMGTDIR/folder_`basename $i`/* $IMGTDIR/folder_`basename $i`/5_AA-sequences.txt
  #rename "s/`basename $i`/5_AA-sequences/" $IMGTDIR/folder_`basename $i`/*
  # mv $IMGTDIR/folder_`basename $i`/$i $IMGTDIR/folder_`basename $i`/5_AA-sequences.txt
  #  rename 's/_//' $IMGTDIR/folder*
  #  rename 's/5AA-sequences.txt//g' $IMGTDIR/folder*
  # rename 's/AA-sequences.txt//g' $IMGTDIR/folder*
  # rename 's/folder//g' $IMGTDIR/folder*
  # rename 's/.txt//g' $IMGTDIR/folder*

done;

for file in $IMGTDIR/*; do
    mv "$file" "${file/_/}"
done

for file in $IMGTDIR/*; do
    mv "$file" "${file/5AA-sequences.txt/}"
done
