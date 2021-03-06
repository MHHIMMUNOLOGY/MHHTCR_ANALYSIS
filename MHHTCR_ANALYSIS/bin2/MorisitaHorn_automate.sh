##!/bin/sh
#Chekc solais evernote for desciription

for i in *.txt;
do
head -n 20001 $i > 20k_`basename $i`
done

if [ ! -d $HOME/sequencing/$1/IMGT ]; then mkdir -p $HOME/sequencing/$1/IMGT; fi;

mv 20k_* $HOME/sequencing/$1/IMGT

#then use this to put each file in its own folder (named folder_*) and add a "3*" to its name
for f in $HOME/sequencing/$1/IMGT/*.txt;
do
mkdir $HOME/sequencing/$1/IMGT/folder_`basename $f`;
mv $f $HOME/sequencing/$1/IMGT/folder_`basename $f`/3_`basename $f`;
done                                                                                                                             

POST_IMGT.sh $1

REMOVE_DUPLICATE_AA.sh $1

Morisita_Horn.sh MH $1
