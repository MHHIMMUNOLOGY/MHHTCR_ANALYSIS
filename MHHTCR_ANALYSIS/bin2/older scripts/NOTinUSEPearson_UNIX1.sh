#!/bin/bash
#Prepare Pearson Score
set -o errexit
set -o xtrace

# Variables for all Directories! Don't forget to set $1 when starting script!
# Keep all files in $HOME/sequencing and create subfolders for different runs i.e
# miseq346 etc... $1 should be the name of the run (miseq346). Keep IMGT files in
# Subfolder miseq346/IMGT (This will be your $HOMEDIR)

HOMEDIR=$HOME/sequencing/$1/IMGT
AA=$HOMEDIR/PearsonCalculation
PROD=$AA/productive
VDJ=$AA/VDJ
CDR3=$AA/CDR3
CDR3AN=$AA/CDR3/CDR3AN
SHANNON=$CDR3/shannon

# Step 2: Copy and Rename IMGT FILES. Takes .txt file from imgt folder and copies it into given destination (end of command). Command also adds the name of the directory as a prefix to the .txt file. This command is very useful to get specific .txt file (such as the AA or NT .txt file from imgt) from many samples at once. Have them all in one directory and run this script.

if [ ! -d $AA ]; then mkdir -p $AA; fi;

# when you change the '.' to $HOMEDIR it doesn't work. Script needs to be executed when in folder for now

cd $HOMEDIR
find . -name '5*.txt' | cut -d/ -f 2- | pax -rws ':/:_:g' $AA


# Step 3: CreateProductive file. Goes through all .txt files, removes every sequence that is not productive and puts them into a extra file. Then a new folder is created in which all these files are moved to.

if [ ! -d $PROD ]; then mkdir -p $PROD; fi;

for i in $AA/*.txt;
do
sed -e '1p' -e '/productive/!d' -e '/unproductive/d' $i > $PROD/p`basename $i`
done


# Step 4: Cut columns into new file V-gene (col4), J-Gene (col5), D-Gene (col6), CDR3seq (col15)

if [ ! -d $VDJ ]; then mkdir -p $VDJ; fi;

for i in $PROD/p*.txt
do
    cut -f 2,4,5,15 $i >  $VDJ/VDJ_`basename $i`
done


# Step 5: Merge columns in these files and shows how many copies each Sequence has

if [ ! -d $CDR3 ]; then mkdir -p $CDR3; fi;

for i in $VDJ/VDJ*.txt;
do
awk -F "\t" '{print $4}' $i | sort | uniq -c | sort -n | cut -f 2 > $CDR3/m`basename $i`
done

mv $CDR3/m* $AA
rm $AA/folder*
#rm -rf $VDJ
rm -rf $CDR3
rm -rf $PROD
