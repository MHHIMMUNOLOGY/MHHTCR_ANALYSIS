#!/bin/sh
#Script to merge similar sequences of VDJ CDR3 region file
#There they merge similar NT sequences, due to the wobble base one AA sequence
# might occur twice in there list.

#Move to the Directory the extracted CDR3 regions are in (use Extract_CDR3_from_VDJ.sh script)
CDR3_INFO=$PWD

for AASEQUENCE in $CDR3_INFO/$1;
do
  #remove the header line as it messes with the calculation
  sed -i.bak 1d $AASEQUENCE
  #see how many lines the file will have
  LN="$(wc -l $AASEQUENCE | cut -d " " -f 1)"
  echo "File `basename $AASEQUENCE` is now being processed."


  for ((i=1;i<=${LN};i++));
  do
    #create a variable that will have just the AA-sequence
    STRING="$(cut -f2 $AASEQUENCE | head -n $i| tail -n 1 | cut -f 1)";
    #create a variable that will have COUNT+AA-sequence, this is in case
    #this AA occurs only once, then it can just be pasted into the new file without
    #having to add up anything (its in the "elese" statement below)
    UNIQ="$(head -n $i $AASEQUENCE | tail -n 1)"

    for DUPLICATE in $AASEQUENCE;
    do
      #create variable that will display the line count. If it is highter than 1 we know
      #this AA-sequence occurs more than once, and we can than continue with a script
      #that adds them up. If it is 1 the script will jump to the "else" statement and
      #just copy the line from $UNIQ
      VAR="$(grep -w "${STRING}" $DUPLICATE | wc -l)"
      #This will have the total sum of this AA-sequence
      TOTALCOUNT="$(grep -w "${STRING}" $DUPLICATE | cut -f1 | awk '{SUM += $1} END {print SUM}')"
      #This just creates an empty file that the new count and AA-sequence can be added to
      touch $CDR3_INFO/MERGED_`basename $AASEQUENCE`
      #The IF-statement checks if the AA occurs more than once
      #If it does a second IF-statement checks if this AA-sequence has already been added
      #If it hasnt been added, it will be, if not nothing happens.
      ALREADYMATCHED="$(grep -w "${STRING}" $CDR3_INFO/MERGED_`basename $AASEQUENCE` | wc -l)"
      if [[ "$VAR" > 1 ]];
      then if [[ "$ALREADYMATCHED" != 0 ]]; then paste <(echo "$TOTALCOUNT") <(echo "$STRING") --delimiters ' '>> $CDR3_INFO/MERGED_`basename $AASEQUENCE` ;fi;
      else echo $UNIQ >> $CDR3_INFO/MERGED_`basename $AASEQUENCE` ;fi
    done;
  done;
done;
