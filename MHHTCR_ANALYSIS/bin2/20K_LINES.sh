#!/bin/sh
# useby copy and pasting it manually into terminal
#This script will extract 20k lines/sequences if the file includes a header.

#First use this to extract a set number of lines
for i in *.txt;
do
head -n 20001 $i > 20k_`basename $i`
done

#then use this to put each file in its own folder (named folder_*) and add a "3*" to its name
for f in *.txt;
do
mkdir folder_`basename $f`;
mv $f folder_`basename $f`/3_`basename $f`;
done                                                                                                                             

#get things from a flder

for file in folder_*;
do mv $file/*.txt $HOME/sequencing/SFB900_TRG_NT/InverseSimpson_NT
done
