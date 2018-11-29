#! /bin/bash
#Numbers summary MIXCR alignment/assemble/exportCLONES

set -o xtrace
set -o errexit
set -o pipefail

HOMEDIR=$HOME/sequencing

SEQDIR=$HOMEDIR/$1

# Directory for IMGT
IMGTDIR=$SEQDIR/IMGT


# Directory of the vdj.jar file

VDJDIR=$HOMEDIR/files_programs/vdjtools/vdjtools.jar

# Directory of VDJ results

VDJRESULTS=$IMGTDIR/VDJRESULTS

touch $VDJRESULTS/Reports/ReportSUM.txt


for NUM in $VDJRESULTS/Reports/reportASSEMBLE*;
do

#Copy relevant lines to report
head -n 2 $NUM | tail -n 1 >> ReportSUM.txt
head -n 7 $NUM | tail -n 1 >> ReportSUM.txt
head -n 9 $NUM | tail -n 1 >> ReportSUM.txt
#Adds empty line at end 
echo "" >> ReportSUM.txt

done

mv $VDJRESULTS/Reports/ReportSUM.txt $VDJRESULTS
