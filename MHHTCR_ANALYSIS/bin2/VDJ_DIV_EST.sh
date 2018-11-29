#!/bin/bash
# VDJ Diversity Estimation Plots and Tables

set -o xtrace
set -o errexit
set -o pipefail

# Home for sequencing
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

############## PlotQuantileStats ##############

for diversityestimation in $VDJRESULTS/VDJTOOLS_*
do
  java -Xmx4G -jar $VDJDIR PlotQuantileStats -t 10 $diversityestimation QuantileStats_`basename $diversityestimation`
done

if [ ! -d $VDJRESULTS/QuantileStats ]; then mkdir -p $VDJRESULTS/QuantileStats; fi;

mv *qstat* $VDJRESULTS/QuantileStats
