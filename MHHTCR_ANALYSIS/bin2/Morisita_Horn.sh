#!/bin/bash
# Make a mix of Shell and R script
#How to use:
#Run Morisita_Horn.sh EXPNAME FOLDERNAME FILE1 FILE2 (...) FILE10
#It will create a new file with similarity information of your samples
############### Assign Variables #########################
figlet -c TcR MOUSE Analysis


# Experiment Name/Title
EXP=$1
# Directories $2 has to be the name of the sequencing run. $WD has to lead to the VDJ files.
WD=$HOME/sequencing/$2/IMGT/VDJRESULTS
VDJRESULTS=$WD
VDJDIR=$HOME/sequencing/files_programs/vdjtools/vdjtools.jar

ls $VDJRESULTS/MERGED* > $VDJRESULTS/METADATA_FILENAME.txt

# Take filename and remove the .txt and save into new .txt file (sample name)
cat $VDJRESULTS/METADATA_FILENAME.txt | sed -e 's/.txt/ /' > $VDJRESULTS/METADATA_SAMPLEID.txt

#Combine both to have one row with the filename and one with the sampleid
paste $VDJRESULTS/METADATA_FILENAME.txt $VDJRESULTS/METADATA_SAMPLEID.txt >$VDJRESULTS/METADATA.txt

#Add the header that is required for vdjtools to read the metadata file
echo -e "#file.name\tsample.id" | cat - $VDJRESULTS/METADATA.txt > $VDJRESULTS/METADATA_HEAD.txt

sed -e 's/ //' $VDJRESULTS/METADATA_HEAD.txt > $VDJRESULTS/METADATA_FINAL.txt

java -jar $VDJDIR CalcPairwiseDistances -m $VDJRESULTS/METADATA_FINAL.txt $VDJRESULTS/MorisitaHorn_

#############################################################################



#rm $VDJRESULTS/META*
#sed 's/MERGED_//' $VDJRESULTS/MorisitaHorn_* > $VDJRESULTS/MorisitaHorn_$2
#rm $VDJRESULTS/MorisitaHorn_.*
figlet -c 100% Complete
