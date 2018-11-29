#!/bin/sh


#You need this to combine all the PearsonScores
DIR=$HOME/sequencing
LN="33"

for ((i=1;i<=${LN};i++));
do
  FILE="$(head -n $i "$HOME/SARINA_FILES" | tail -n 1 | cut -f 1)";
  PEARSON=$DIR/$FILE/IMGT/VDJRESULTS/PEARSON/PearsonScore
  mv $PEARSON ${FILE}_PearsonScore
done
cat $DIR/*PearsonScore > $DIR/TCD_PearsonScore
sed -i.bak 's/CDR3_freq_Genesprodfolder//g' $DIR/TCD_PearsonScore
sed -i.bak 's/_5_AA-sequences.txt//g' $DIR/TCD_PearsonScore
#
# #Use this to extract all the files and format them for use with Pearson_Score
# LN="33"
# for ((i=1;i<=${LN};i++));
# do
#   DIR=$HOME/sequencing
#   FILE="$(head -n $i "$DIR/SAMPLES" | tail -n 1 | cut -f 1)";
#   ls $DIR/$FILE > $DIR/SAMPLES2
#   LN2="$(wc -l $DIR/SAMPLES2 | cut -d " " -f 1)"
#   for ((i=1;i<=${LN2};i++));
#   do
#     FILE2="$(head -n $i "$DIR/SAMPLES2" | tail -n 1 | cut -f 1)";
#     IMGT=$DIR/$FILE/IMGT
#     if [ ! -d $IMGT ]; then mkdir -p $IMGT; fi;
#     if [ ! -d $IMGT/folder_${FILE2} ]; then mkdir -p $IMGT/folder_${FILE2}; fi;
#     mv $DIR/$FILE/$FILE2 $IMGT/folder_${FILE2}/
#     cd $IMGT
#     rename 's/_//g' folder*
#     rename 's/5AA-sequences.txt//g' folder*
#     rename 's/AA-sequences.txt//g' folder*
#     #rename 's/folder//g' *
#     rename 's/.txt//g' folder*
#     cd $DIR
#   done;
# done;


# rename 's/_//g' *
# rename 's/5AA-sequences.txt//g' *
# rename 's/AA-sequences.txt//g' *
# #rename 's/folder//g' *
# rename 's/.txt//g' *


#USE THIS to get txt files into order
DIR=$HOME/sequencing
cd $DIR/
$NUMBER=1510
mv $DIR/$NUMBER/$NUMBER/*.txt $DIR/$NUMBER/
rmdir $DIR/$NUMBER/$NUMBER
