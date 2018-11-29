#!/bin/bash
#This script is used to unpack all IMGT .txz files and move them into specific folders

set -o xtrace
set -o errexit
set -o pipefail

############## DIRECTORY VARIABLES ##############

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

# unzip/tar all files from IMGT (put in one directory)
# This creates a directory named after the .tar file and moves the .tar file into the directory

# Extract .txt files from the tar !Move to the directory you want it to be unpacked -> $IMGTDIR!
for TARFILE in $IMGTDIR/*.txz;
do
 tar -xvf $TARFILE;
 mkdir $IMGTDIR/folder_`basename $TARFILE`;
 mv $IMGTDIR/*.txt $IMGTDIR/folder_`basename $TARFILE`;
done
