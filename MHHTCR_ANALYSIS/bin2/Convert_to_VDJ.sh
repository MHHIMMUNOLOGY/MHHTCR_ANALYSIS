#!/bin/sh
PROD=$PWD
VDJRESULTS=$PROD/VDJRESULTS
VDJDIR=$HOME/sequencing/files_programs/vdjtools/vdjtools.jar


ls $PROD > $PROD/METADATA_FILENAME.txt

# Take filename and remove the .txt and save into new .txt file (sample name)
cat $PROD/METADATA_FILENAME.txt | sed -e 's/.txt/ /' > $PROD/METADATA_SAMPLEID.txt

#Combine both to have one row with the filename and one with the sampleid
paste $PROD/METADATA_FILENAME.txt $PROD/METADATA_SAMPLEID.txt >$PROD/METADATA.txt

#Add the header that is required for vdjtools to read the metadata file
echo -e "#file.name\tsample.id" | cat - $PROD/METADATA.txt > $PROD/METADATA_HEAD.txt

# If there is no directory named X, then make it. If there is, don't do anything
if [ ! -d $VDJRESULTS ]; then mkdir -p $VDJRESULTS; fi;

#Run vdjtools and convert all samples using the METADATA with all sample names
java -jar $VDJDIR Convert -S imgthighvquest -m $PROD/METADATA_HEAD.txt $VDJRESULTS/VDJTOOLS_

rm $VDJRESULTS/*METADATA*

rename 's/VDJTOOLS_.//' $VDJRESULTS/*
rename 's/ //' $VDJRESULTS/*
#clean up the file names

# for file in $VDJRESULTS/*.txt;
# do
#   mv "${file}" "${file/VDJTOOLS_.profolder_/}";
# done
