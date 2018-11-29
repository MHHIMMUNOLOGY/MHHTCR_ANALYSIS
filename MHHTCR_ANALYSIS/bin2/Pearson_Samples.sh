#!/bin/sh
#This is to choose specific files to be analysed by the Pearson SCRIPTS
#To start this script, move the folder where the files are
HOMEDIR=$HOME/sequencing

# Directory for IMGT
IMGTDIR=$PWD

TMPDIR=$HOMEDIR/tmp/IMGT

FILEGROUP=$1

if [ ! -d $IMGTDIR/VDJRESULTS ]; then mkdir -p $IMGTDIR/VDJRESULTS; fi;
if [ ! -d $IMGTDIR/VDJRESULTS/PEARSON ]; then mkdir -p $IMGTDIR/VDJRESULTS/PEARSON; fi;

if [ ! -d $HOMEDIR/tmp ]; then mkdir -p $HOMEDIR/tmp; fi;
if [ ! -d $HOMEDIR/tmp/IMGT ]; then mkdir -p $HOMEDIR/tmp/IMGT; fi;


rsync -avz $PWD/$FILEGROUP $T$MPDIR

Pearson_UNIX1.sh tmp

cp $TMPDIR/VDJRESULTS/PEARSON/PearsonScore $IMGTDIR/VDJRESULTS/PEARSON

rm -rf $TMPDIR
