#!/bin/bash
#Pipeline Humble Beginnings (PHB)
set -o errexit
set -o xtrace

# Variables for all Directories! Don't forget to set $1 when starting script!
# Keep all files in $HOME/sequencing and create subfolders for different runs i.e
# miseq346 etc... $1 should be the name of the run (miseq346). Keep IMGT files in
# Subfolder miseq346/IMGT (This will be your $HOMEDIR)

HOMEDIR=$HOME/sequencing/$1/IMGT
AA=$HOMEDIR/5_AA
PROD=$HOMEDIR/5_AA/productive
VDJ=$HOMEDIR/5_AA/VDJ
CDR3=$HOMEDIR/5_AA/CDR3
CDR3AN=$HOMEDIR/5_AA/CDR3/CDR3AN
SHANNON=$CDR3/shannon

# Step 2: Copy and Rename IMGT FILES. Takes .txt file from imgt folder and copies it into given destination (end of command). Command also adds the name of the directory as a prefix to the .txt file. This command is very useful to get specific .txt file (such as the AA or NT .txt file from imgt) from many samples at once. Have them all in one directory and run this script.

if [ ! -d $AA ]; then mkdir -p $AA; fi;

# when you change the '.' to $HOMEDIR it doesn't work. Script needs to be executed when in folder for now

cd $HOMEDIR
find . -name '5*.txt' | cut -d/ -f 2- | pax -rws ':/:_:g' $AA


# Step 3: CreateProductive file. Goes through all .txt files, removes every sequence that is not productive and puts them into a extra file. Then a new folder is created in which all these files are moved to.

if [ ! -d $PROD ]; then mkdir -p $PROD; fi;

for i in $HOMEDIR/5_AA/*.txt;
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
awk -F "\t" '{print $1}' $i | sort | uniq -c | sort -n | > $CDR3/m`basename $i`
done

if [ ! -d $CDR3AN ]; then mkdir -p $CDR3AN; fi;

cp $CDR3/m*.txt $CDR3AN

# Step 5.1: Adds PREFIX "2" to every file in the folder (use this file later to paste the CDR3 length)
cd $CDR3AN
for i in *.txt;
do
mv "$i" "2_$i"
done

# Step 6: Calculates CDR3 length, then moves into the folder it was saved in and pastes the length into the file with actual sequences.


for i in $CDR3/m*.txt;
do
awk '{print $2}' $i | awk '{print length($0);}' > $CDR3AN/`basename $i`
done

cd $CDR3AN
for i in m*.txt;
do
paste $i  2_$i > $CDR3/length_`basename $i`
done

rm $CDR3AN/2*.txt
#rm $CDR3AN/m*.txt
#rmdir $CDR3AN

# Step 7: Create file that lists number of unique/abundant sequences. Then adds that information to the file with all sequences

for i in $CDR3/length*.txt;
do
awk '{print $2}' $i | uniq -c > $CDR3/uq_`basename $i`
done

cd $CDR3

for i in length*.txt;
do
paste $i uq_$i > $CDR3/CDR3_`basename $i`
done

rm $CDR3/uq*
rm $CDR3/length*

# Step 7.1:  Add header line to all the CDR3 files
for i in $CDR3/CDR3*;
do
echo -e "Length\tCount\tSequence\tAbundance\tCount" | cat - $i > $CDR3/CDR3_Header_`basename $i`
done

rm $CDR3/CDR3_l*

# Step 8: List output of orignial sequence numbers + new sequence numbers in a text file
#First move back to folder AA (hence the cd .. commands)

#count amount of rows in text file in AA folder (note: it counts the header too -> substract 1?)
for i in $AA/*.txt;
do
wc -l $i > $AA/numbers_`basename $i`
done

#combine all counts into one file
cat $AA/numbers*.txt > $AA/count.txt
rm $AA/numbers*.txt

mv $AA/count.txt $PROD


#count the number of sequences after only productive sequences have been sorted
for i in $PROD/p*.txt;
do
wc -l $i > $PROD/numbers_`basename $i`
done

#combine those with previous counts
cat $PROD/numbers_*.txt > $PROD/count2.txt
paste $PROD/count.txt $PROD/count2.txt | column -s '\t' | awk '{print $2 "\t" $1 "\t" $3}' > $PROD/count3.txt

rm $PROD/numbers*.txt
rm $PROD/count.txt
rm $PROD/count2.txt
mv $PROD/count3.txt $CDR3

#add a header
echo -e "Name\tAll\tProductive" | cat - $CDR3/count3.txt > $CDR3/1_Numbers.txt

rm $CDR3/count3.txt

# Step 9 Calculate the Shannon Index

for i in $CDR3/CDR3*.txt;
do
awk '{print $2}' $i > $CDR3/sh_`basename $i`
done

if [ ! -d $SHANNON ]; then mkdir -p $SHANNON; fi;
mv $CDR3/sh_*.txt $SHANNON


#remove header that says "Count"
sed -i -e '/Count/d' $SHANNON/sh*.txt

#Start R and load vegan library
#change directory according to where the R Script is

Rscript $HOME/bin2/shannon.R $SHANNON

#merge all shannon indeces

# Could use: tail -n +1 div*.txt > 2_Shannon.txt
#But better:

grep "" $SHANNON/div*.txt > $CDR3/2_Shannon.txt

rm $SHANNON/div*.txt

rmdir --ignore-fail-on-non-empty $SHANNON

#Step 10: make dot plot illustrating uniqe sequences

for i in $CDR3/CDR*.txt;
do
awk '{print $4,$5}' $i   > $CDR3/plot1_`basename $i`
done

#start R-script to plot
#change directory according to where the R Script is
Rscript $HOME/bin2/ggplot2.R $CDR3

rm $CDR3/plot1*
#rm $CDR3/.RData
#rm $CDR3/*.Rout
#rm $CDR3/Rplots.pdf

if [ ! -d $CDR3/Uniq_Graphs ]; then mkdir -p $CDR3/Uniq_Graphs; fi;

mv $CDR3/uniq*.pdf $CDR3/Uniq_Graphs

#Step 11: make stacked bar graph to illustrate CDR3 clonotypes

Rscript $HOME/bin2/stacked.R $CDR3

if [ ! -d $CDR3/stacked ]; then mkdir -p $CDR3/stacked; fi;
mv $CDR3/stacked_* $CDR3/stacked


rm $CDR3/mVDJ*


#clean up the file names

# CDR3 Info Files
for filename in $CDR3/*sequences.txt;
do
  [ -f "$filename" ] || continue
  mv $filename ${filename//Header_CDR3_length_mVDJ_p_/};
done

for filename in $CDR3/*sequences.txt;
do
  [ -f "$filename" ] || continue
  mv $filename ${filename//.txz_5_AA-sequences/};
done

# Stacked Bar Graph files

for filename in $CDR3/stacked/*.pdf;
do
  [ -f "$filename" ] || continue
  mv $filename ${filename//Header_CDR3_length_mVDJ_p_/};
done

for filename in $CDR3/stacked/*.pdf;
do
  [ -f "$filename" ] || continue
  mv $filename ${filename//_.txt/};
done

for filename in $CDR3/stacked/*.pdf;
do
  [ -f "$filename" ] || continue
  mv $filename ${filename//.txz_5_AA-sequences.txt.txt/};
done

# Uniq sequences plots
for filename in $CDR3/Uniq_Graphs/*.pdf;
do
  [ -f "$filename" ] || continue
  mv $filename ${filename//.txtplot1_CDR3_Header_CDR3_length_mVDJ_p_/};
done

for filename in $CDR3/Uniq_Graphs/*.pdf;
do
  [ -f "$filename" ] || continue
  mv $filename ${filename//.txz_5_AA-sequences.txt.txt/};
done

# Remove path in Numbers file with the command sed
# in this case ':' is used as a delimiter, but you can use whatever you want
# it will be what ever follows the 's'. '-i' will edit the file in place (no need
# to save to different file). It ends with '::' because we want the expression
# deleted. If we would want it replaced we can add a string i.e ':replacement:'
# This is the syntac: sed -options 's:OLD-STRING:NEW-STRING:' FILE
# since delimitter can be decided it can also be: sed -options 's/OLD-STRING/NEWSTRING/' FILE

sed -ri  's:/home/imm_admin/sequencing/miseq326/IMGT/5_AA/_::' $CDR3/1_Numbers.txt
sed -ri  's:.txz_5_AA-sequences.txt::' 1_Numbers.txt
sed -ri  's:/home/imm_admin/sequencing/miseq326/IMGT/5_AA/CDR3/shannon/div_::' $CDR3/2_Shannon.txt
sed -ri  's:sh_CDR3_Header_CDR3_length_mVDJ_p_::' $CDR3/2_Shannon.txt
sed -ri  's:_R1.txz_5_AA-sequences.txt::' $CDR3/2_Shannon.txt
sed -ri  's:/home/imm_admin/sequencing/miseq346/IMGT/5_AA/_::' $HOME/sequencing/miseq346/IMGT/5_AA/CDR3/1_Numbers.txt
sed -ri  's:/home/imm_admin/sequencing/miseq371/IMGT/5_AA/folder_::' $CDR3/1_Numbers.txt
