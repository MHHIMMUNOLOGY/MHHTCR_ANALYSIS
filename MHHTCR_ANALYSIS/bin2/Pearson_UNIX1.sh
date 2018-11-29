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

PEARSONCALC=$IMGTDIR/PEARSON

PROD=$PEARSONCALC/productive

# Directory of the vdj.jar file

VDJDIR=$HOMEDIR/files_programs/vdjtools/vdjtools.jar

# Directory of VDJ results

VDJRESULTS=$IMGTDIR/VDJRESULTS


# Output Directory of Pearson Correlation

PEARSON=$VDJRESULTS/PEARSON

if [ ! -d $PEARSONCALC ]; then mkdir -p $PEARSONCALC; fi;

# for i in folder*
# do
# find $IMGTDIR/$i -name '5*.txt' | xargs cp -t $PEARSONCALC | rename "s/5_AA-sequences.txt/${i}.txt/" $PEARSONCALC/5_AA-sequences.txt
# done

# cd $IMGTDIR
 find . -name '5*.txt' | cut -d/ -f 2- | pax -rws ':/:_:g' $PEARSONCALC


for i in $PEARSONCALC/*.txt;
do
sed -e '1p' -e '/productive/!d' -e '/unproductive/d' $i > $PEARSONCALC/prod`basename $i`
done
# cut columns into new file V-gene (col4), J-Gene (col5), D-Gene (col6), CDR3seq (col15)
for i in $PEARSONCALC/prod*.txt
do
    cut -f 15 $i >  $PEARSONCALC/Genes`basename $i`
done
wc -l $PEARSONCALC/prod*.txt| sed 's/.txt//' > $PEARSONCALC/summary_productive.txt

if [ ! -d $PROD ]; then mkdir -p $PROD; fi;

mv $PEARSONCALC/prod*.txt $PROD
mv $PEARSONCALC/summary_productive.txt $PROD


# Calculate CDR3 frequency

for i in $PEARSONCALC/Genes*.txt
do
awk -F "\t" '{print $1}' $i | sort | uniq -c | sort -n > $PEARSONCALC/CDR3_freq_`basename $i`
done

for i in $PEARSONCALC/CDR3*
do
  sed -i 's/ *//' $i
done

rm $PEARSONCALC/Genes*.txt
rm $PEARSONCALC/folder*

rm -rf $PROD
#read -n1 -r -p "[Press Enter to continue] [Press CTRL-C to Abort]"

Pearson_UNIX2.sh $1

#Preparation for overlap analysis (PEARSON)
#for i in $PEARSONCALC/CDR3*.txt
#do
#awk -F " "  '{print $1}' $i  > $PEARSONCALC/counts_`basename $i`
#done

#for i in $PEARSONCALC/CDR3*.txt
#do
#awk -F " "  '{print $2}' $i  > $PEARSONCALC/AA_`basename $i`
#done


#for i in $PEARSONCALC/AA
#paste $PEARSONCALC/AA_sample1 $PEARSONCALC/counts_sample1 > $PEARSONCALC/sample1

#Overlap between sample1 and sample2
#awk 'FNR==NR{a[$1]=$2 FS $3;next}{ print $0, a[$1]}' $PEARSONCALC/sample1 $PEARSONCALC/sample2 > $PEARSONCALC/sample1_sample2.txt

#awk 'FNR==NR{a[$1]=$2 FS $3;next}{ print $0, a[$1]}' $PEARSONCALC/sample2 $PEARSONCALC/sample1 > $PEARSONCALC/sample2_sample1.txt
