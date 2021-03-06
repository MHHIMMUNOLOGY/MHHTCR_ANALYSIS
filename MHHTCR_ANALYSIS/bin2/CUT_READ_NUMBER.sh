#!/bin/sh
#This script will cut the NT file in the IMGT folders to a specified row/read number.

#The first variable needs to be your experiment/run name that will give the path to
#the correct "IMGT" folder
IMGT=$HOME/sequencing/$1/IMGT
#The second variable given is the number of reads desired
CUTNUMBER=$2
#We add 1 to the desired number of reads because the header row is  also included
FINALCUTNUMBER=$((CUTNUMBER + 1))

#This will now go into every IMGT folder and create a new 3_NT FIle with the desired read number
  for NT in ./folder*/ ;
  do
  (cd "$NT" && head -n $FINALCUTNUMBER 3*.txt > 3_Nt-sequencesNEW.txt                                  );
  done                                                   

#This will change the name of the original file name so the POST_IMGT.sh script does not
#get confused as to which 3_Nt file to use

  for NT in ./folder*/ ;
  do
  (cd "$NT" && mv 3_                                          Nt-sequences.txt UNCUT_3_Nt-sequences.txt);
  done                                                   

  #The POST_IMGT.sh script also requires the file name to stay 3_Nt-sequenes.txt
  #So we rename it back

  for NT in ./folder*/ ;
  do
  (cd "$NT" && mv 3_Nt-sequencesNEW.txt 3_Nt-sequences.txt                                  );
  done                                                   
