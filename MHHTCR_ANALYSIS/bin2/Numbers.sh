#! /bin/bash
#Pearson Correlation Sarina Preparation

set -o xtrace
set -o errexit
set -o pipefail

HOMEDIR=$HOME/sequencing

SEQDIR=$HOMEDIR/$1

# Directory for IMGT
IMGTDIR=$SEQDIR/IMGT

# Folder with 3_Nt files
NTDIR=$IMGTDIR/3_Nt

NUMBERS=$IMGTDIR/Numbers

PROD=$NUMBERS/productive

# Directory of the vdj.jar file

VDJDIR=$HOMEDIR/files_programs/vdjtools/vdjtools.jar

# Directory of VDJ results

VDJRESULTS=$IMGTDIR/VDJRESULTS


# Output Directory of Pearson Correlation

PEARSON=$VDJRESULTS/PEARSON

if [ ! -d $NUMBERS ]; then mkdir -p $NUMBERS; fi;

cd $IMGTDIR
find . -name '5*.txt' | cut -d/ -f 2- | pax -rws ':/:_:g' $NUMBERS


for i in $NUMBERS/folder*.txt;
do
sed -e '1p' -e '/productive/!d' -e '/unproductive/d' $i > $NUMBERS/prod`basename $i`
done

for i in $NUMBERS/folder*.txt;
do
sed -e '1p' -e '/unproductive/!d' $i > $NUMBERS/unprod`basename $i`
done

wc -l $NUMBERS/prod*.txt| sed 's/.txt//' > $NUMBERS/summary_productive.txt

wc -l $NUMBERS/unprod*.txt| sed 's/.txt//' > $NUMBERS/summary_unproductive.txt

rm $NUMBERS/*folder*

sed -i.bak 's|/home/imm_admin/sequencing/004CSFExtracted/IMGT/Numbers/||' $NUMBERS/summary_*
rm $NUMBERS/*.bak
sed -i.bak 's|.txz_5_AA-sequences||' $NUMBERS/summary_*
rm $NUMBERS/*.bak

for i in $NUMBERS/summary_*
do
  sed -i.bak 's/ *//' $i
  rm $NUMBERS/*.bak
done

Rscript $HOME/bin2/Numbers.R $NUMBERS summary_productive.txt summary_unproductive.txt

rm $NUMBERS/summary_*

sed -i.bak "s|$IMGTDIR||" $NUMBERS/Numbers.txt
sed -i.bak "s|/Numbers/prodfolder_||" $NUMBERS/Numbers.txt
rm $NUMBERS/*.bak
