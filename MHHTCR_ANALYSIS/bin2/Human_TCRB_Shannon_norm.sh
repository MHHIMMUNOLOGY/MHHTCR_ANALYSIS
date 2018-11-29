#! /bin/bash
mkdir Nt
for i in 3*.txt;
do
find . -name '3*.txt' | cut -d/ -f 2- | pax -rws ':/:_:g' ./Nt
done

cd Nt
#sort for prod

for i in *.txt;
do
sed -e '1p' -e '/productive/!d' -e '/unproductive/d' $i > prod`basename $i`
done

wc -l prod* >summary_productive.txt


# cut columns into new file V-gene (col4), J-Gene (col5), D-Gene (col6), CDR3seq (col15)
for i in prod*.txt
do
    cut -f 4,5,6,15 $i >  Genes`basename $i`
done

rm prod*

#Shannon Index

for i in Genes*.txt
do
head -n 13001 $i > norm`basename $i`
done

for i in norm*.txt
do
sort $i | uniq -c | sort -n > all_`basename $i`
done



for i in all*.txt
do
awk -F " " '{print $1}' $i > counts`basename $i`
done

for i in all*.txt
do
awk -F " " '{print $1}' $i > shannon`basename $i`
done

for i in all*.txt
do
awk -F " " '{print $1}' $i | wc -l  > clones`basename $i`
done


mkdir Shannon
mv counts* Shannon
mv shannon* Shannon
mv clones* Shannon



cd Shannon
R
library("vegan")

fileNames<- Sys.glob("shannon*.txt")
for (fileName in fileNames) {
sample <-read.table(fileName, head=F, sep=" ")
sample.trans<-t(sample)
sh<-diversity(sample.trans)
write.table(sh, file=fileName)
}

quit(save = "default", status = 0, runLast = TRUE)
