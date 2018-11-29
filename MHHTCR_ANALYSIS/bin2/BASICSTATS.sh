#!/bin/bash
# DOWNSAMPLE ALL VDJ FILES IN VDJRESULTS FOLDER

#Use following Syntax when running the script:
#DOWNSAMPLE.sh NUMBER_OF_READS_TO_DOWNSAMPLE FOLDERNAME

############### Assign Variables #########################
figlet -c BASIC STATS


# Experiment Name/Title
#Diectories $1 has to be the name of the sequencing run. $WD has to lead to the VDJ files.
WD=$HOME/sequencing/$1/IMGT/VDJRESULTS/BASICSTATS
VDJRESULTS=$WD
SCRIPTS=$HOME/bin2
VDJDIR=$HOME/sequencing/files_programs/vdjtools/vdjtools.jar

if [[ "$PWD" != "$WD" ]]; then echo "----- YOU ARE NOT IN THE VDJRESULTS DIRECTORY. Please move to $WD <-- ********";
			echo "Type: cd $HOME/sequencing/FOLDERNAME/IMGT/VDJRESULTS"
			echo "Then use following Syntax when running the script:";
			echo "BASICSTATS.sh FOLDERNAME"; 
			exit 1  ;fi

ls * > $VDJRESULTS/META_LIST

cut $VDJRESULTS/META_LIST -d"=" -f2 | sed '/^$/d' > $VDJRESULTS/META_FILENAME
sed -e 's/.txt//' $VDJRESULTS/META_FILENAME > $VDJRESULTS/META_SAMPLEID
paste $VDJRESULTS/META_FILENAME $VDJRESULTS/META_SAMPLEID > $VDJRESULTS/METADATA
echo -e "#file.name\tsample.id" | cat - $VDJRESULTS/METADATA > $VDJRESULTS/METADATA_HEAD

#USES THE VDJTOOLS DOWNSAMPLE FUNCTUON
#-x is the option to decide how many reads it should be downsampled to. 
#-c can be used to compress output
#-u can be used to not weight clonotypes by frequency. Check what that means.  

java -jar $VDJDIR CalcBasicStats -m $VDJRESULTS/METADATA_HEAD $VDJRESULTS/BASICSTATS_
			
rm $VDJRESULTS/META*
