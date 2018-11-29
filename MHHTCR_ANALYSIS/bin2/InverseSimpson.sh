#!/bin/bash
# Make a mix of Shell and R script

############### Assign Variables #########################
figlet -c TcR HUMAN Analysis


# Experiment Name/Title
EXP=$1
# Directories $2 has to be the name of the sequencing run. $WD has to lead to the VDJ files.
WD=$HOME/sequencing/$2/IMGT/VDJRESULTS
VDJRESULTS=$WD
TCRRESULTS=$WD/`basename $EXP`_results
SCRIPTS=$HOME/bin2
VDJDIR=$HOME/sequencing/files_programs/vdjtools/vdjtools.jar

# Files that are from one experiment (i.e Input, D4, D14, D21)
FILE1=$3
FILE2=$4
FILE3=$5
FILE4=$6
FILE5=$7
FILE6=$8
FILE7=$9
FILE8=${10}
FILE9=${11}
FILE10=${12}
FILE11=${13}
FILE12=${14}
FILE13=${15}
FILE14=${16}
FILE15=${17}
FILE16=${18}
FILE17=${19}
FILE18=${20}
FILE19=${21}
FILE20=${22}
FILE21=${23}

#############################################################################

#Start the R Script that does all the analysis with the tcR-Package
Rscript $HOME/bin2/InverseSimpson.R $WD $FILE1 $FILE2 $FILE3 $FILE4 $FILE5 $FILE6 $FILE7 $FILE8 $FILE9 $FILE10 $FILE11 $FILE12 $FILE13 $FILE14 $FILE15 $FILE16 $FILE17 $FILE18 $FILE19 $FILE20 $FILE21 
