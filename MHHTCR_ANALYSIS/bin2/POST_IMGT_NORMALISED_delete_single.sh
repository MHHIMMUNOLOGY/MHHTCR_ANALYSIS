#!/bin/bash
# After files come back from IMGT

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

#Number of Reads that should be used for analysis (Normalisation of Samples)
CUTNUMBER=$2
#We add 1 to the desired number of reads because the header row is  also included
FINALCUTNUMBER=$((CUTNUMBER + 1))

############## Convert all IMGT files into VDJtools Format ##############

# Extract the IMGT File needed for further analysis (like 3_Nt or 5_AA)

if [ ! -d $IMGTDIR/3_Nt ]; then mkdir -p $IMGTDIR/3_Nt; fi;

cd $IMGTDIR
 for NT in 3*.txt;
 do
 find . -name '3*.txt' | cut -d/ -f 2- | pax -rws ':/:_:g' ./3_Nt
 done

#clean up the file names

# for file in $NTDIR/*.txt;
# do
#   mv "${file}" "${file/.txz_3_Nt-sequences.txt/}";
# done

for file in $NTDIR/*.txt;
do
  mv "${file}" "${file/_3_Nt-sequences.txt/}";
done

# Remove all 'unproductive' and 'no results' sequences because VDJtools does not remove unproductive

# for filename in $NTDIR/folder_*;
# do
#   sed '/unproductive/d ' $filename > $NTDIR/xpro`basename $filename`
#   sed -i.bak '/No results/d ' $NTDIR/xpro`basename $filename`
#   sed -i.bak '/unknown/d ' $NTDIR/xpro`basename $filename`
#   sed -i.bak '/No rearrangement found/d ' $NTDIR/xpro`basename $filename`
# done

# rm $NTDIR/*.bak

#This uses a R code that will remove all reads that are unique (will keep clones that occur at least more than once)
for FILE in $NTDIR/folder_*;
do
  Rscript $HOME/bin2/Remove_Single_Reads.R $NTDIR `basename $FILE`

  mv $NTDIR/DUP.txt $NTDIR/xpro`basename $FILE`
  mv $NTDIR/Numbers.txt $NTDIR/Numbers_`basename $FILE`
done
touch $NTDIR/DUP_NUMBERS.txt
cat $NTDIR/Numbers_* >> $NTDIR/DUP_NUMBERS.txt
rm $NTDIR/Numbers_*

#After produtive reads have been filtered out, we can  normalise all samples by taking n reads for analysis
for filename in $NTDIR/xpro*;
do
  head -n $FINALCUTNUMBER $filename > $NTDIR/profolder_`basename $filename`;
done


if [ ! -d $NTDIR/all ]; then mkdir -p $NTDIR/all; fi;
if [ ! -d $PROD ]; then mkdir -p $PROD; fi;

mv $NTDIR/folder_* $NTDIR/all

mv $NTDIR/profolder_* $PROD

#rm $NTDIR/xpro*

# Read files with VDJtools and convert into VDJtool format
# First create a Metadatafile that includes all sample names

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

mv $NTDIR/DUP_NUMBERS.txt $VDJRESULTS/NumberOfDuplicates
rm $VDJRESULTS/*METADATA*

#clean up the file names

for file in $VDJRESULTS/*.txt;
do
  mv "${file}" "${file/VDJTOOLS_.profolder_xprofolder_/}";
done

rename 's/ //' $VDJRESULTS/*.txt                             

#This line will delete "every other line" starting from line 3. This is because the file "NumberOfDuplicates" has the
#header row in every other line, which is why I start at line 3 (to keep a header in line 1) and then delete every other one.
sed '3~2d' $VDJRESULTS/NumberOfDuplicates > $VDJRESULTS/Numbers_DUP.txt
rm  $VDJRESULTS/NumberOfDuplicates























############## Do all analysis that are required ##############
