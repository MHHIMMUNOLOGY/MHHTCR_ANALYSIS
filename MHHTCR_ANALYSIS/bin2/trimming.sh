#!/bin/bash

$1=

for FILE in $1;
do
  NAME=`basename $FILE`;

  fastq-mcf -q 10 n/a $FILE -o TRIM_$NAME;
done
