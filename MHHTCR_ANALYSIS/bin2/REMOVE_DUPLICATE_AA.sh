#!/bin/sh

HOMEDIR=$HOME/sequencing

# Folder of Miseq run -> $1 is the first string after bash script i.e typing 'PHB.sh $HOME/sequencing/miseq346'
# into the commandline will run the script and save $1 as the string '$HOME/sequencing/miseq346'.
# For this script always have a folder called "sequencing" in your home directory ($HOME/sequencing) and in there
# for each directory create a folder for every run (i.e miseq346). In the command line run script like 'script.sh miseq346'
SEQDIR=$HOMEDIR/$1

# Directory for IMGT
IMGTDIR=$SEQDIR/IMGT

# Folder with 3_Nt files
NTDIR=$IMGTDIR/3_Nt

PROD=$NTDIR/productive

# Directory of the vdj.jar file

VDJDIR=$HOMEDIR/files_programs/vdjtools/vdjtools.jar

# Directory of VDJ results

VDJRESULTS=$IMGTDIR/VDJRESULTS

if [ ! -d $VDJRESULTS/WOBBLE ]; then mkdir -p $VDJRESULTS/WOBBLE; fi;

for MERGED in $VDJRESULTS/*.txt
do
  echo `basename $MERGED` > $VDJRESULTS/METADATA_FILENAME
  sed -e 's/.txt//' $VDJRESULTS/METADATA_FILENAME > $VDJRESULTS/METADATA_SAMPLEID
  paste $VDJRESULTS/METADATA_FILENAME $VDJRESULTS/METADATA_SAMPLEID > $VDJRESULTS/METADATA
  echo -e "#file.name\tsample.id" | cat - $VDJRESULTS/METADATA > $VDJRESULTS/METADATA_HEAD
  java -jar $VDJDIR PoolSamples -m $VDJRESULTS/METADATA_HEAD $VDJRESULTS/MERGED_
  mv $MERGED $VDJRESULTS/WOBBLE
  rename "s/.pool.aa.table.txt/`basename $MERGED`/g" $VDJRESULTS/MERGED_.pool.aa.table.txt
  rm $VDJRESULTS/META*
  mv $VDJRESULTS/*pool* $VDJRESULTS/WOBBLE
done
