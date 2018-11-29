#!/bin/sh
#Extract CDR3 region info from VDJ files

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

if [ ! -d $VDJRESULTS/CDR3_INFO ]; then mkdir -p $VDJRESULTS/CDR3_INFO; fi;


for SAMPLE in $VDJRESULTS/*.txt;
do
  Rscript $HOME/bin2/Extract_CDR3_from_VDJ.R $VDJRESULTS `basename $SAMPLE`
  mv $VDJRESULTS/tcR_CDR3_info $VDJRESULTS/CDR3_INFO/`basename $SAMPLE`_CDR3


# #This doesnt work yet as the field
#   awk '{dc[$2] += $1} END{for (seq in dc) {print dc[seq], seq}}' $VDJRESULTS/CDR3_INFO/`basename $SAMPLE`_CDR3 > $VDJRESULTS/CDR3_INFO/MERGED_`basename $SAMPLE`
#   #rename 's/.txt//g' $VDJRESULTS/CDR3_INFO/`basename $SAMPLE`_CDR3
#   sort -s -rn -k 1,1 $VDJRESULTS/CDR3_INFO/MERGED_`basename $SAMPLE`
#   rm $VDJRESULTS/CDR3_INFO/`basename $SAMPLE`_CDR3
done;
